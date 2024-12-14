package com.example.compressor;

public class CompressCommandBuilder {
    public static String[] buildCompressionCommand(String videoPath, String outputPath, int width, int height) {
        if (width * height > 1920 * 1080) { // 1080p or higher
            return new String[]{
                    "-y", "-i", videoPath,
                    "-c:v", "libx265",
                    "-preset", "ultrafast",
                    "-x265-params", "crf=28",
                    "-vf", "scale=1920:-2",
                    "-c:a", "aac",
                    "-b:a", "128k",
                    "-movflags", "+faststart",
                    outputPath
            };
        } else if (width * height > 1280 * 720) { // Between 720p and 1080p
            return new String[]{
                    "-y", "-i", videoPath,
                    "-c:v", "libx264",
                    "-crf", "20",
                    "-preset", "medium",
                    "-b:v", "4M",
                    "-maxrate", "5M",
                    "-bufsize", "6M",
                    "-c:a", "aac",
                    "-b:a", "128k",
                    "-movflags", "+faststart",
                    outputPath
            };
        } else { // 720p or lower
            return new String[]{
                    "-y", "-i", videoPath,
                    "-c:v", "libx264",
                    "-crf", "23",
                    "-preset", "fast",
                    "-b:v", "1.5M",
                    "-maxrate", "2M",
                    "-bufsize", "3M",
                    "-c:a", "aac",
                    "-b:a", "128k",
                    "-movflags", "+faststart",
                    outputPath
            };
        }
    }

}
