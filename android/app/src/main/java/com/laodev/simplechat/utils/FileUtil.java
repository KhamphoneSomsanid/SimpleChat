package com.laodev.simplechat.utils;

import android.os.Environment;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;

public class FileUtil {

    private static final String APP_FOLDER_NAME = "Simple Chat";

    public static final int POST_ITEM_TYPE_IMAGE = 2;
    public static final int POST_ITEM_TYPE_VIDEO = 3;
    public static final int FILE_TYPE_AVATAR = 1;
    public static final int STORY_ITEM_TYPE_IMAGE = 4;
    public static final int STORY_ITEM_TYPE_VIDEO = 5;

    //Main App Folder: /sdcard/FireApp/
    public static String mainAppFolder() {
        File file = new File(Environment.getExternalStorageDirectory() + "/" + APP_FOLDER_NAME + "/");
        //if the directory is not exists create it
        if (!file.exists())
            file.mkdir();

        return file.getAbsolutePath();
    }

    public static String getAvatarFolder() {
        File file = new File(mainAppFolder() + "/Avatar");
        if (!file.exists()) {
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    public static String getPostImageFolder() {
        File file = new File(mainAppFolder() + "/Post/Images");
        if (!file.exists()) {
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    public static String getPostVideoFolder() {
        File file = new File(mainAppFolder() + "/Post/Videos");
        if (!file.exists()) {
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    public static String getStoryFolder() {
        File file = new File(mainAppFolder() + "/Story");
        if (!file.exists()) {
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    public static File generateFile(int type, int index) {
        File file;
        switch (type) {
            case FILE_TYPE_AVATAR:
                file = new File(getAvatarFolder() + "/avatar.png");
                break;
            case POST_ITEM_TYPE_IMAGE:
                file = new File(getPostImageFolder() + "/img_" + new Date().getTime() + "_" + index + ".png");
                break;
            case POST_ITEM_TYPE_VIDEO:
                file = new File(getPostVideoFolder() + "/vid_" + new Date().getTime() + "_" + index + ".mp4");
                break;
            case STORY_ITEM_TYPE_IMAGE:
                file = new File(getStoryFolder() + "/img_" + new Date().getTime() + "_" + index + ".mp4");
                break;
            case STORY_ITEM_TYPE_VIDEO:
                file = new File(getStoryFolder() + "/vid_" + new Date().getTime() + "_" + index + ".mp4");
                break;
            default:
                file = new File(getAvatarFolder() + "/avatar.png");
                break;
        }
        //create dirs if not exists
        if (!file.exists())
            file.getParentFile().mkdirs();

        return file;
    }

    public static String getFileExtensionFromPath(String string) {
        int index = string.lastIndexOf(".");
        return string.substring(index + 1);
    }

    public static boolean isFileExists(String path) {
        if (path == null)
            return false;
        return new File(path).exists();
    }

    public static boolean isPickedVideo(String path) {
        String extension;
        int i = path.lastIndexOf('.');
        if (i > 0) {
            extension = path.substring(i + 1);
            return extension.equalsIgnoreCase("MP4") || extension.equalsIgnoreCase("3GP");
        }
        return false;
    }

    public static void copyFile(File src, File dst) throws IOException {
        try (InputStream in = new FileInputStream(src)) {
            try (OutputStream out = new FileOutputStream(dst)) {
                // Transfer bytes from in to out
                byte[] buf = new byte[1024];
                int len;
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
            }
        }
    }

    public static void deleteFile(String path) {
        try {
            if (path == null) return;
            new File(path).delete();
        } catch (Exception ignored) { }
    }

    public static String getFileName(File file) {
        String filePath = file.getPath();
        String[] values = filePath.split("/");
        return values[values.length - 1];
    }

    public static String getFileName(String path) {
        String[] values = path.split("/");
        return values[values.length - 1];
    }

}
