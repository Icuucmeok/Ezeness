package com.example.compressor;

import com.arthenica.mobileffmpeg.Config;
import com.arthenica.mobileffmpeg.FFmpeg;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.Log;
import java.util.Arrays;
import java.io.File;
import java.io.FileOutputStream;


public class VideoEditor {

    public static String addFilter(String videoPath, String outputPath, double red, double green, double blue) {
        if (videoPath == null || videoPath.isEmpty()) {
            Log.e("VideoEditor", "addFilter: videoPath is null or empty");
            return null;
        }

        StringBuilder filterComplex = new StringBuilder();


        filterComplex.append("colorchannelmixer=rr="+String.valueOf(red)+":gg="+String.valueOf(green)+":bb="+String.valueOf(blue)); // Apply grayscale filter


        // Build FFmpeg Command
        String[] cmd;
        if (filterComplex.length() > 0) {
            Log.d("VideoEditor", "addFilter: filterComplex: " + filterComplex.toString());

            cmd = new String[]{
                    "-y", "-i", videoPath,
                    "-filter_complex", filterComplex.toString(),
                    "-preset", "ultrafast",
                    "-c:a", "copy",
                    outputPath
            };
        } else {
            cmd = new String[]{
                    "-y", "-i", videoPath,
                    "-preset", "ultrafast",
                    "-c:a", "copy",
                    outputPath
            };
        }

        // Logging the command for debugging
        Log.d("VideoEditor", "Executing FFmpeg command: " + Arrays.toString(cmd));

        // Execute FFmpeg command
        int rc = FFmpeg.execute(cmd);

        if (rc == Config.RETURN_CODE_SUCCESS) {
            Log.d("VideoEditor", "FFmpeg command executed successfully");
            return outputPath;
        } else {
            Log.e("VideoEditor", "FFmpeg command execution failed with return code " + rc);
            EditorUtils.handleFfmpegError(rc);
            return null;
        }
    }
    
    public static String addOverlays(String videoPath, String outputPath, Bitmap overlayBitmap, int imgX, int imgY, int imgWidth, int imgHeight, String text, int textX, int textY, String fontFilePath, int fontSize, String fontColor, int shapeX, int shapeY, int shapeWidth, int shapeHeight, String shapeColor) {
        
        if (videoPath == null || videoPath.isEmpty()) {
            Log.e("VideoEditor", "addOverlays: videoPath is null or empty");
            return null;
        }

        StringBuilder filterComplex = new StringBuilder();
        String tempImagePath = outputPath + ".temp.png";

        // Default font path if not provided
        if (fontFilePath == null || fontFilePath.isEmpty()) {
            fontFilePath = "/system/fonts/DroidSans.ttf"; // Replace with an appropriate font file path
        }

        // Image Overlay
        if (overlayBitmap != null) {
            if (!createImageOverlay(overlayBitmap, tempImagePath, imgWidth, imgHeight, imgX, imgY)) {
                Log.e("VideoEditor", "addOverlays: createImageOverlay failed");
                return null;
            }
            filterComplex.append("[0:v][1:v]overlay=x=").append(imgX).append(":y=").append(imgY).append(", ");
        }

        // Text Overlay
        if (text != null && !text.isEmpty()) {
            filterComplex.append("drawtext=text='").append(text).append("':x=").append(textX).append(":y=").append(textY);
            filterComplex.append(":fontfile='").append(fontFilePath).append("'");
            filterComplex.append(":fontsize=").append(fontSize).append(":fontcolor=").append(fontColor).append(", ");
        }

        // Shape Overlay
        if (shapeWidth > 0 && shapeHeight > 0 && shapeColor != null && !shapeColor.isEmpty()) {
            filterComplex.append("drawbox=x=").append(shapeX).append(":y=").append(shapeY).append(":w=").append(shapeWidth).append(":h=").append(shapeHeight).append(":color=").append(shapeColor).append(", ");
        }

        // Remove trailing comma and space if present
        if (filterComplex.length() > 0 && filterComplex.charAt(filterComplex.length() - 2) == ',') {
            filterComplex.setLength(filterComplex.length() - 2);
        }

        // Build FFmpeg Command
        String[] cmd;
        if (filterComplex.length() > 0) {
            Log.d("VideoEditor", "addOverlays: filterComplex: " + filterComplex.toString());

            if (overlayBitmap != null) {
                cmd = new String[]{
                        "-y", "-i", videoPath,
                        "-i", tempImagePath,
                        "-filter_complex", filterComplex.toString(),
                        "-preset", "ultrafast",
                        "-c:a", "copy",
                        outputPath
                };
            } else {
                cmd = new String[]{
                        "-y", "-i", videoPath,
                        "-filter_complex", filterComplex.toString(),
                        "-preset", "ultrafast",
                        "-c:a", "copy",
                        outputPath
                };
            }
        } else {
            cmd = new String[]{
                    "-y", "-i", videoPath,
                    "-preset", "ultrafast",
                    "-c:a", "copy",
                    outputPath
            };
        }

        // Logging the command for debugging
        Log.d("VideoEditor", "Executing FFmpeg command: " + Arrays.toString(cmd));

        // Execute FFmpeg command
        int rc = FFmpeg.execute(cmd);

        if (rc == Config.RETURN_CODE_SUCCESS) {
            Log.d("VideoEditor", "FFmpeg command executed successfully");
            return outputPath;
        } else {
            Log.e("VideoEditor", "FFmpeg command execution failed with return code " + rc);
            EditorUtils.handleFfmpegError(rc);
            return null;
        }
    }
    
    private static boolean createImageOverlay(Bitmap overlayBitmap, String tempImagePath, int width, int height, int x, int y) {
        try {
            overlayBitmap = Bitmap.createScaledBitmap(overlayBitmap, width, height, false);
    
            Bitmap tempBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(tempBitmap);
            Paint paint = new Paint(Paint.FILTER_BITMAP_FLAG);
    
            int posX = x < 0 ? width + x : x;
            int posY = y < 0 ? height + y : y;
    
            canvas.drawBitmap(overlayBitmap, posX, posY, paint);
    
            File file = new File(tempImagePath);
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }
    
            FileOutputStream out = new FileOutputStream(tempImagePath);
            tempBitmap.compress(Bitmap.CompressFormat.PNG, 100, out);
            out.flush();
            out.close();
    
            Log.d("VideoEditor", "createImageOverlay: tempImagePath created at " + tempImagePath);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("VideoEditor", "createImageOverlay: exception occurred", e);
            return false;
        }
    }
    private static float[] hexToRgbFloat(String hexColor) {
        int color = (int) Long.parseLong(hexColor.replace("#", ""), 16);
        float red = ((color >> 16) & 0xFF) / 255f;
        float green = ((color >> 8) & 0xFF) / 255f;
        float blue = (color & 0xFF) / 255f;
        return new float[]{red, green, blue};
    }
}