package com.laodev.simplechat;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ThumbnailUtils;
import android.provider.MediaStore;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    final String imageChannel = "com.laodev.simplechat/thumbnail";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), imageChannel).setMethodCallHandler((call, result) -> {
            if (call.method.equals("image")) {
                String params = call.arguments.toString();
                Log.d("[MethodChannel]", params);

                params = params.replace("[", "");
                params = params.replace("]", "");
                params = params.replace(" ", "");
                String[] paramData = params.split(",");
                Log.d("[MethodChannel]", Arrays.toString(paramData));

                Bitmap thumbImage = ThumbnailUtils.extractThumbnail(
                        BitmapFactory.decodeFile(paramData[0]),
                        Integer.parseInt(paramData[1]),
                        Integer.parseInt(paramData[2]));

                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                thumbImage.compress(Bitmap.CompressFormat.PNG,100, bos);
                byte[] bb = bos.toByteArray();
                String base64 = Base64.encodeToString(bb, 0);

                result.success(base64);
            } else if (call.method.equals("video")) {
                String params = call.arguments.toString();
                Log.d("[MethodChannel]", params);

                params = params.replace("[", "");
                params = params.replace("]", "");
                params = params.replace(" ", "");
                String[] paramData = params.split(",");
                Log.d("[MethodChannel]", Arrays.toString(paramData));

                try {

                    Bitmap thumbImage = ThumbnailUtils.createVideoThumbnail(paramData[0], MediaStore.Video.Thumbnails.MINI_KIND);

                    ByteArrayOutputStream bos = new ByteArrayOutputStream();
                    thumbImage.compress(Bitmap.CompressFormat.PNG,100, bos);
                    byte[] bb = bos.toByteArray();
                    String base64 = Base64.encodeToString(bb, 0);

                    result.success(base64);
                } catch (Throwable throwable) {
                    result.notImplemented();
                }
            } else {
                result.notImplemented();
            }
        });
    }
}
