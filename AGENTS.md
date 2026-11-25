# AGENTS.md

## OpenTelemetry 이미지 갱신 정책

OpenTelemetry 이미지를 갱신할 때는 Google distroless(`gcr.io/distroless/java<major>-debian13`)를 기준으로 관련 설정과 버전을 맞춥니다.

- 맞출 항목: Debian 릴리스, Temurin 버전, 사용자 `nonroot` 65532:65532, `LANG=C.UTF-8`
- 기준값 확인: `docker run --rm gcr.io/distroless/java<major>-debian13 -version`, `docker image inspect --format '{{json .Config.Env}}' <image>` (`JAVA_VERSION` 포함)
- 버전 위치
  - Agent 버전·SHA256: `open-telemetry/agent/otel-v2.env`
  - Temurin 버전: `.github/workflows/open-telemetry2-jdk{17,21,25}.yml`의 `build-java-images.sh` 인자
- 새 파일을 추가하면 워크플로 3개의 `paths:`(push, pull_request)에도 넣습니다. 빠지면 CI가 실행되지 않습니다.
- 검증
  - `python3 -m unittest discover -s open-telemetry/agent/tests` (Docker 불필요)
  - `open-telemetry/agent/build-java-images.sh <major> <temurin-version> false <variant>` (로컬은 `publish=false`)
- `open-telemetry/old/`와 README의 "관리하지 않는 이미지"는 수정하지 않습니다.

## 커밋

Conventional Commits 형식에 설명은 한국어로 씁니다. 예: `docs: README 이미지 안내 정리`
