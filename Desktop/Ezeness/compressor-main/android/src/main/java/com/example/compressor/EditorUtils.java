package com.example.compressor;
import android.media.MediaMetadataRetriever;
import android.util.Log;

import com.arthenica.mobileffmpeg.Config;

public class EditorUtils {
    public static int[] getVideoDimensions(String videoPath) {
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        try {
            retriever.setDataSource(videoPath);
            int width = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH));
            int height = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT));
            retriever.release();
            return new int[]{width, height};
        } catch (Exception e) {
            Log.e("TAG", "Failed to retrieve video metadata: " + e.getMessage());
            return null;
        }
    }

    public static void handleFfmpegError(int rc) {
        if (rc == Config.RETURN_CODE_CANCEL) {
            Log.e("TAG", "Compression cancelled");
        } else {
            Log.e("TAG", "Compression failed with error code: " + rc);
            Log.e("TAG", "FFmpeg error output: " + Config.getLastCommandOutput());
        }
    }

}
