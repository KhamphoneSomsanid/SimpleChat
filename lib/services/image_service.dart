import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageService {

  final methodThumbnail = const MethodChannel('com.laodev.simplechat/thumbnail');

  Future<String> getThumbnailBase64FromImage(File file, {
    int width = 160,
    int height = 160,
  }) async {
    var image = decodeImage(file.readAsBytesSync());
    double ratioX = image.width / width;
    double ratioY = image.height / height;
    if (ratioX > ratioY) {
      var thumbnail = copyResize(image, width: width);
      return base64.encode(encodePng(thumbnail).toList());
    } else {
      var thumbnail = copyResize(image, height: height);
      return base64.encode(encodePng(thumbnail).toList());
    }
  }

  Future<String> getThumbnailBase64FromVideo(File file, {
    int width = 160,
    int height = 160,
  }) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.PNG,
      maxWidth: width,
      maxHeight: height,
      quality: 25,
    );

    return base64.encode(uint8list);
  }

}