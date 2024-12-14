package com.ezeness.utagup;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragmentActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import android.os.Environment;

// import com.arthenica.mobileffmpeg.Config;
// import com.arthenica.mobileffmpeg.FFmpeg;

public class MainActivity extends FlutterFragmentActivity {
    private static final String CHANNEL = "video_compression";

    // @Override
    // public void configureFlutterEngine(FlutterEngine flutterEngine) {
    //     GeneratedPluginRegistrant.registerWith(flutterEngine);
    //     new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
    //             .setMethodCallHandler(
    //                     (call, result) -> {
    //                         if (call.method.equals("compressVideo")) {
    //                             String videoPath = call.argument("videoPath");
    //                             String outputPath = call.argument("outputPath");
    //                             String compressedFilePath = VideoCompressor.compressVideo(videoPath,outputPath);
    //                             result.success(compressedFilePath); // Return compressed video file path
    //                         } else {
    //                             result.notImplemented();
    //                         }
    //                     }
    //             );
    // }
}
// class VideoCompressor {
//     public static String compressVideo(String videoPath, String outputPath) {
//         if (videoPath == null || videoPath.isEmpty()) {
//             return null; // Handle null or empty video path
//         }

//         // Construct the FFmpeg command to compress the video
//         // You can adjust the compression settings as needed
//         String[] cmd = new String[]{"-y", "-i", videoPath, "-c:v", "mpeg4", "-b:v", "1M", "-c:a", "aac", outputPath};

//         // Execute the FFmpeg command
//         int rc = FFmpeg.execute(cmd);

//         if (rc == Config.RETURN_CODE_SUCCESS) {
//             return outputPath;
//         } else {
//             // Handle compression failure
         
//             return null;
//         }
//     }
// }