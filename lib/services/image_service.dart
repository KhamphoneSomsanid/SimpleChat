import 'dart:io';

import 'package:flutter/services.dart';

class ImageService {

  final methodThumbnail = const MethodChannel('com.laodev.simplechat/thumbnail');

  Future<String> getThumbnailBase64FromImage(File file, {
    int width = 160,
    int height = 160,
  }) async {
    print('[MethodChannel] get thumbnail : ${file.path}');
    String result;
    if (Platform.isAndroid) {
      result = await methodThumbnail.invokeMethod('image', [file.path, '$width', '$height']);
    } else {
      result = await methodThumbnail.invokeMethod('image', [file.readAsBytesSync(), '$width', '$height']);
    }

    return result;
  }

  Future<String> getThumbnailBase64FromVideo(File file, {
    int width = 160,
    int height = 160,
  }) async {
    print('[MethodChannel] get thumbnail : ${file.path}');
    String result;
    if (Platform.isAndroid) {
      result = await methodThumbnail.invokeMethod('video', [file.path, '$width', '$height']);
    } else {
      result = await methodThumbnail.invokeMethod('video', [file.readAsBytesSync(), '$width', '$height']);
    }
    return result;
  }

}