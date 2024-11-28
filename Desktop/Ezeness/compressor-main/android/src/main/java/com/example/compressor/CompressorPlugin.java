package com.example.compressor;

import com.example.compressor.VideoEditor;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import com.arthenica.mobileffmpeg.Config;
import com.arthenica.mobileffmpeg.FFmpeg;
import android.util.Log;
import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import com.example.compressor.EditorUtils;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import java.io.ByteArrayInputStream;

import java.io.File;


public class CompressorPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private ExecutorService executor;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "video_compression");
        channel.setMethodCallHandler(this);
        executor = Executors.newFixedThreadPool(1); // Create a single-thread executor
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "compressVideo":
                handleCompressVideo(call, result);
                break;
            case "trimVideo":
                handleTrimVideo(call, result);
                break;
            case "exportCover":
                handleExportCover(call, result);
                break;
            case "addOverlays":
                handleAddOverlays(call, result);
                break;
            case "addFilterVideo":
                handleAddFilterVideo(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleCompressVideo(@NonNull MethodCall call, @NonNull Result result) {
        String videoPath = call.argument("inputPath");
        String outputPath = call.argument("outputPath");

        executor.execute(() -> {
            String compressedFilePath = VideoCompressor.compressVideo(videoPath, outputPath);
            if (compressedFilePath != null) {
                result.success(compressedFilePath);
            } else {
                result.error("COMPRESSION_FAILED", "Video compression failed", null);
            }
        });
    }
    private void handleAddFilterVideo(@NonNull MethodCall call, @NonNull Result result) {
        String videoPath = call.argument("videoPath");
        String outputPath = call.argument("outputPath");
        double red = call.argument("red");
        double green = call.argument("green");
        double blue = call.argument("blue");

        executor.execute(() -> {
            String editedVideoPath = VideoEditor.addFilter(videoPath, outputPath, red, green, blue);
            if (editedVideoPath != null) {
                result.success(editedVideoPath);
            } else {
                result.error("ADD_FILTER", "Video Add filter failed", null);
            }
        });
    }

    private void handleAddOverlays(@NonNull MethodCall call, @NonNull Result result) {
        String videoPath = call.argument("videoPath");
        String outputPath = call.argument("outputPath");
        byte[] imageData = call.argument("imageData");
        Integer imgX = call.argument("imgX");
        Integer imgY = call.argument("imgY");
        Integer imgWidth = call.argument("imgWidth");
        Integer imgHeight = call.argument("imgHeight");
        String text = call.argument("text");
        Integer textX = call.argument("textX");
        Integer textY = call.argument("textY");
        String fontFilePath = call.argument("fontFilePath");
        Integer fontSize = call.argument("fontSize");
        String fontColor = call.argument("fontColor");
        Integer shapeX = call.argument("shapeX");
        Integer shapeY = call.argument("shapeY");
        Integer shapeWidth = call.argument("shapeWidth");
        Integer shapeHeight = call.argument("shapeHeight");
        String shapeColor = call.argument("shapeColor");


        executor.execute(() -> {
            Bitmap overlayBitmap = null;
            if (imageData != null) {
                overlayBitmap = BitmapFactory.decodeStream(new ByteArrayInputStream(imageData));
            }
    
            String editedVideoPath = VideoEditor.addOverlays(
                    videoPath,
                    outputPath,
                    overlayBitmap,
                    imgX != null ? imgX : 0,
                    imgY != null ? imgY : 0,
                    imgWidth != null ? imgWidth : 0,
                    imgHeight != null ? imgHeight : 0,
                    text,
                    textX != null ? textX : 0,
                    textY != null ? textY : 0,
                    fontFilePath,
                    fontSize != null ? fontSize : 0,
                    fontColor,
                    shapeX != null ? shapeX : 0,
                    shapeY != null ? shapeY : 0,
                    shapeWidth != null ? shapeWidth : 0,
                    shapeHeight != null ? shapeHeight : 0,
                    shapeColor
            );
    
            if (editedVideoPath != null) {
                result.success(editedVideoPath);
            } else {
                result.error("ADD_OVERLAYS_FAILED", "Failed to add overlays to video", null);
            }
        });
    }

    private void handleTrimVideo(@NonNull MethodCall call, @NonNull Result result) {
        String inputPath = call.argument("inputPath");
        String outputPath = call.argument("outputPath");
        double startTime = call.argument("startTime");
        double endTime = call.argument("endTime");

        executor.execute(() -> {
            String trimmedFilePath = VideoCompressor.trimVideo(inputPath, outputPath, startTime, endTime);
            if (trimmedFilePath != null) {
                result.success(trimmedFilePath);
            } else {
                result.error("TRIM_FAILED", "Video trimming failed", null);
            }
        });
    }

    private void handleExportCover(@NonNull MethodCall call, @NonNull Result result) {
        String coverInputPath = call.argument("inputPath");
        String coverOutputPath = call.argument("outputPath");
        double coverTime = call.argument("coverTime");

        executor.execute(() -> {
            String coverFilePath = VideoCompressor.exportCover(coverInputPath, coverOutputPath, coverTime);
            if (coverFilePath != null) {
                result.success(coverFilePath);
            } else {
                result.error("EXPORT_COVER_FAILED", "Export cover failed", null);
            }
        });
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        executor.shutdown();
    }
}

class VideoCompressor {
    private static final String TAG = "VideoCompressor";

    public static String compressVideo(String videoPath, String outputPath) {
        if (videoPath == null || videoPath.isEmpty()) {
            return null;
        }

        File outputDir = new File(outputPath).getParentFile();
        if (!outputDir.exists() && !outputDir.mkdirs()) {
            Log.e(TAG, "Failed to create output directory");
            return null;
        }

        int[] dimensions = EditorUtils.getVideoDimensions(videoPath);
        if (dimensions == null) {
            return null;
        }
        int width = dimensions[0];
        int height = dimensions[1];

        String[] cmd = CompressCommandBuilder.buildCompressionCommand(videoPath, outputPath, width, height);

        Log.d(TAG, "Executing FFmpeg command: " + Arrays.toString(cmd));
        int rc = FFmpeg.execute(cmd);

        if (rc == Config.RETURN_CODE_SUCCESS) {
            Log.d(TAG, "Compression successful: " + outputPath);
            return outputPath;
        } else {
            EditorUtils.handleFfmpegError(rc);
            return null;
        }
    }

    public static String trimVideo(String videoPath, String outputPath, double startTime, double endTime) {
        if (videoPath == null || videoPath.isEmpty()) {
            return null;
        }

        createOutputDirectory(outputPath);

        String[] cmd = new String[]{
                "-y",
                "-ss", String.valueOf(startTime),
                "-i", videoPath,
                "-to", String.valueOf(endTime),
                "-c", "copy",
                "-c:a", "aac",
                "-copyts",
                outputPath
        };

        int rc = FFmpeg.execute(cmd);

        if (rc == Config.RETURN_CODE_SUCCESS) {
            return outputPath;
        } else {
            Log.e(TAG, "Trimming failed with error code: " + rc);
            return null;
        }
    }

    public static String exportCover(String videoPath, String outputPath, double coverTime) {
        if (videoPath == null || videoPath.isEmpty()) {
            return null;
        }

        createOutputDirectory(outputPath);

        String[] cmd = new String[]{
                "-y",
                "-ss", String.valueOf(coverTime),
                "-i", videoPath,
                "-vframes", "1",
                "-q:v", "2",
                outputPath
        };

        int rc = FFmpeg.execute(cmd);

        if (rc == Config.RETURN_CODE_SUCCESS) {
            return outputPath;
        } else {
            Log.e(TAG, "Export cover failed with error code: " + rc);
            return null;
        }
    }

    private static void createOutputDirectory(String outputPath) {
        File outputDir = new File(outputPath).getParentFile();
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }
    }
}
