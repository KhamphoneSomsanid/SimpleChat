import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

enum FILETYPE {
  IMAGE,
  VIDEO,
  DOCUMENT,
  OTHER
}

class FileService {
  final videoTypes = [
    'mp4', 'webm', 'mpg', 'mpeg', 'mp2', 'mpe', 'mpv',
    'oog', 'm4p', 'm4v', 'avi', 'wmv', 'mov', 'qt', 'flv'
        'swf', 'avchd'
  ];
  final imageType = [
    'jpg', 'jpeg', 'png', 'gif', 'webp', 'tiff', 'psd', 'raw',
    'bmp', 'heif', 'indd', 'jpeg2000', 'svg', 'ai', 'eps'
  ];

  String fileName(File file) {
    return file.path.split('/').last;
  }

  String extension(File file) {
    return fileName(file).split('.').last;
  }

  FILETYPE getType(File file) {
    String ext = extension(file);
    if (videoTypes.contains(ext.toLowerCase())) {
      return FILETYPE.VIDEO;
    }
    if (imageType.contains(ext.toLowerCase())) {
      return FILETYPE.IMAGE;
    }
    return FILETYPE.OTHER;
  }

}