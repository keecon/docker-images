import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class BuildJavaImagesTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        root = Path(self.directory.name)
        self.script = root / 'build-java-images.sh'
        shutil.copy(Path(__file__).resolve().parent.parent / self.script.name, self.script)
        self.log = root / 'calls'
        docker = root / 'docker'
        docker.write_text('#!/bin/sh\nprintf "docker %s\\n" "$*" >> "$CALL_LOG"\ncase "$*" in *"${FAIL_BUILD:-never-match}"*) exit 1;; esac\n')
        docker.chmod(0o755)
        test = root / 'test-java-image.sh'
        test.write_text('#!/bin/sh\nprintf "test %s %s\\n" "$DOCKER_DEFAULT_PLATFORM" "$*" >> "$CALL_LOG"\n[ "${FAIL_TEST:-}" != "$5" ]\n')
        test.chmod(0o755)
        self.env = dict(os.environ, PATH=f'{root}:{os.environ["PATH"]}', CALL_LOG=str(self.log), OTEL_VERSION='2.3.4', OTEL_SHA256='test')

    def run_build(self, major, publish, fail_test='', fail_build='', variant='ffmpeg'):
        return subprocess.run([str(self.script), str(major), f'{major}.0.1_2', publish, variant], env=dict(self.env, FAIL_TEST=fail_test, FAIL_BUILD=fail_build or 'never-match'), capture_output=True, text=True)

    def calls(self):
        return self.log.read_text().splitlines()

    def test_each_variant_is_tested_before_publishing(self):
        for major in (17, 21, 25):
            for variant in ('distroless', 'jdk', 'jre', 'ffmpeg'):
                with self.subTest(major=major, variant=variant):
                    self.log.unlink(missing_ok=True)
                    self.assertEqual(self.run_build(major, 'true', variant=variant).returncode, 0)
                    calls = self.calls()
                    builds = [i for i, call in enumerate(calls) if call.startswith('docker buildx build ')]
                    tests = [i for i, call in enumerate(calls) if call.startswith('test ')]
                    pushes = [i for i, call in enumerate(calls) if call.startswith('docker push ')]
                    self.assertEqual(len(builds), 1)
                    self.assertEqual(len(tests), 2)
                    self.assertEqual(len(pushes), 2)
                    self.assertLess(max(tests), min(pushes))
                    for i in pushes:
                        self.assertTrue(calls[i - 1].startswith('docker tag local/open-telemetry:2.3.4-'))
                        self.assertEqual(calls[i - 1].split()[-1], calls[i].split()[-1])
                        self.assertEqual(calls[i - 1].split()[-2].split('2.3.4-', 1)[1], calls[i].rsplit(':', 1)[1].split('-', 1)[1])
                    build = calls[builds[0]]
                    if variant in ('jdk', 'jre'):
                        self.assertIn(f'--build-arg TEMURIN_VERSION={major}.0.1_2', build)
                        self.assertIn(f'--build-arg JAVA_KIND={variant}', build)
                        self.assertIn('--build-arg JAVA_BASE_TAG=debian:13-slim', build)
                        self.assertRegex(build, r'--file \S+/Dockerfile ')
                    else:
                        self.assertNotIn('TEMURIN_VERSION', build)
                        self.assertRegex(build, rf'--file \S+/Dockerfile\.{variant} ')
                        self.assertIn('-debian13:latest', build)

    def test_invalid_variant_is_rejected(self):
        self.assertNotEqual(self.run_build(25, 'true', variant='jre-alpine').returncode, 0)
        self.assertFalse(self.log.exists())

    def test_failed_build_prevents_all_publication(self):
        self.assertNotEqual(self.run_build(25, 'true', fail_build='Dockerfile.ffmpeg').returncode, 0)
        self.assertFalse(any(call.startswith(('docker tag ', 'docker push ')) for call in self.calls()))

    def test_pull_request_never_publishes(self):
        self.assertEqual(self.run_build(25, 'false').returncode, 0)
        self.assertFalse(any(call.startswith(('docker tag ', 'docker push ')) for call in self.calls()))

    def test_failed_test_prevents_all_publication(self):
        self.assertNotEqual(self.run_build(25, 'true', 'distroless-ffmpeg').returncode, 0)
        self.assertFalse(any(call.startswith(('docker tag ', 'docker push ')) for call in self.calls()))


if __name__ == '__main__':
    unittest.main()
