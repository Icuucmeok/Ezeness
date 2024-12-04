package com.example.compressor;

// import android.media.MediaMetadataRetriever;
// import android.util.Log;
// import com.arthenica.mobileffmpeg.Config;
// import com.arthenica.mobileffmpeg.FFmpeg;
// import java.io.File;
// import java.util.Arrays;

// public class VideoCompressor {
//     private static final String TAG = "VideoCompressor";

//     public static String compressVideo(String videoPath, String outputPath) {
//         if (videoPath == null || videoPath.isEmpty()) {
//             return null;
//         }

        // File outputDir = new File(outputPath).getParentFile();
        // if (!outputDir.exists() && !outputDir.mkdirs()) {
        //     Log.e(TAG, "Failed to create output directory");
        //     return null;
        // }

//         int[] dimensions = getVideoDimensions(videoPath);
//         if (dimensions == null) {
//             return null;
//         }
//         int width = dimensions[0];
//         int height = dimensions[1];

//         String[] cmd = buildCompressionCommand(videoPath, outputPath, width, height);

//         Log.d(TAG, "Executing FFmpeg command: " + Arrays.toString(cmd));
//         int rc = FFmpeg.execute(cmd);

//         if (rc == Config.RETURN_CODE_SUCCESS) {
//             Log.d(TAG, "Compression successful: " + outputPath);
//             return outputPath;
//         } else {
//             handleFfmpegError(rc);
//             return null;
//         }
//     }

//     private static int[] getVideoDimensions(String videoPath) {
//         MediaMetadataRetriever retriever = new MediaMetadataRetriever();
//         try {
//             retriever.setDataSource(videoPath);
//             int width = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH));
//             int height = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT));
//             retriever.release();
//             return new int[]{width, height};
//         } catch (Exception e) {
//             Log.e(TAG, "Failed to retrieve video metadata: " + e.getMessage());
//             return null;
//         }
//     }

//     private static void handleFfmpegError(int rc) {
//         if (rc == Config.RETURN_CODE_CANCEL) {
//             Log.e(TAG, "Compression cancelled");
//         } else {
//             Log.e(TAG, "Compression failed with error code: " + rc);
//             Log.e(TAG, "FFmpeg error output: " + Config.getLastCommandOutput());
//         }
//     }

//     public static String trimVideo(String videoPath, String outputPath, double startTime, double endTime) {
//         if (videoPath == null || videoPath.isEmpty()) {
//             return null;
//         }

//         createOutputDirectory(outputPath);

//         String[] cmd = new String[]{
//                 "-y",
//                 "-ss", String.valueOf(startTime),
//                 "-i", videoPath,
//                 "-to", String.valueOf(endTime),
//                 "-c", "copy",
//                 "-c:a", "aac",
//                 "-copyts",
//                 outputPath
//         };

//         int rc = FFmpeg.execute(cmd);

//         if (rc == Config.RETURN_CODE_SUCCESS) {
//             return outputPath;
//         } else {
//             Log.e(TAG, "Trimming failed with error code: " + rc);
//             return null;
//         }
//     }

//     public static String exportCover(String videoPath, String outputPath, double coverTime) {
//         if (videoPath == null || videoPath.isEmpty()) {
//             return null;
//         }

//         createOutputDirectory(outputPath);

//         String[] cmd = new String[]{
//                 "-y",
//                 "-ss", String.valueOf(coverTime),
//                 "-i", videoPath,
//                 "-vframes", "1",
//                 "-q:v", "2",
//                 outputPath
//         };

//         int rc = FFmpeg.execute(cmd);

//         if (rc == Config.RETURN_CODE_SUCCESS) {
//             return outputPath;
//         } else {
//             Log.e(TAG, "Export cover failed with error code: " + rc);
//             return null;
//         }
//     }

//     private static void createOutputDirectory(String outputPath) {
//         File outputDir = new File(outputPath).getParentFile();
//         if (!outputDir.exists()) {
//             outputDir.mkdirs();
//         }
//     }
// }
