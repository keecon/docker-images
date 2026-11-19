import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;

class TestDistrolessFFmpeg {
    private static String run(String... args) throws Exception {
        Process process = new ProcessBuilder(args).redirectErrorStream(true).start();
        String output = new String(process.getInputStream().readAllBytes());
        if (process.waitFor() != 0) {
            throw new IllegalStateException(Arrays.toString(args) + "\n" + output);
        }
        return output;
    }

    public static void main(String[] args) throws Exception {
        if (javax.tools.ToolProvider.getSystemJavaCompiler() != null) {
            throw new IllegalStateException("JRE image must not contain a Java compiler");
        }
        Path dir = Files.createTempDirectory("ffmpeg-test-");
        Path mp3 = dir.resolve("input.mp3");
        Path flac = dir.resolve("output.flac");
        Path list = dir.resolve("input.txt");
        Path merged = dir.resolve("merged.mp3");
        Path svg = dir.resolve("input.svg");
        Path png = dir.resolve("output.png");

        run("ffmpeg", "-v", "error", "-f", "lavfi", "-i", "sine=frequency=1000:duration=1",
            "-af", "loudnorm", "-c:a", "libmp3lame", mp3.toString());
        run("ffmpeg", "-v", "error", "-i", mp3.toString(), "-c:a", "flac", flac.toString());
        Files.writeString(list, "file '" + mp3 + "'\nfile '" + mp3 + "'\n");
        run("ffmpeg", "-v", "error", "-f", "concat", "-safe", "0", "-i", list.toString(),
            "-c", "copy", merged.toString());
        Files.writeString(svg, "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"2\" height=\"2\"><rect width=\"2\" height=\"2\" fill=\"red\"/></svg>");
        run("ffmpeg", "-v", "error", "-i", svg.toString(), "-frames:v", "1", png.toString());
        if (Files.size(png) == 0) throw new IllegalStateException("empty PNG");
        String duration = run("ffprobe", "-v", "error", "-show_entries", "format=duration",
            "-of", "default=nw=1", merged.toString());
        if (!duration.startsWith("duration=") || Double.parseDouble(duration.substring(9).trim()) < 1.5) {
            throw new IllegalStateException(duration);
        }
        System.out.println("Java ProcessBuilder: MP3, loudnorm, FLAC, concat, SVG, ffprobe OK");
    }
}
