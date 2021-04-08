import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

enum FILETYPE { IMAGE, VIDEO, DOCUMENT, OTHER }

class FileService {
  static final videoTypes = [
    'mp4',
    'webm',
    'mpg',
    'mpeg',
    'mp2',
    'mpe',
    'mpv',
    'oog',
    'm4p',
    'm4v',
    'avi',
    'wmv',
    'mov',
    'qt',
    'flv'
        'swf',
    'avchd'
  ];
  static final imageTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'tiff',
    'psd',
    'raw',
    'bmp',
    'heif',
    'indd',
    'jpeg2000',
    'svg',
    'ai',
    'eps'
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
    if (imageTypes.contains(ext.toLowerCase())) {
      return FILETYPE.IMAGE;
    }
    return FILETYPE.OTHER;
  }

  static Future<void> downloadFile(String url, {String filename}) async {
    var httpClient = http.Client();
    var request = new http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);
    String dir = (await getApplicationDocumentsDirectory()).path;

    List<List<int>> chunks = [];
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        print('downloadPercentage: ${downloaded / r.contentLength * 100}');

        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        print('downloadPercentage: ${downloaded / r.contentLength * 100}');
        File file = new File('$dir/$filename');
        final Uint8List bytes = Uint8List(r.contentLength);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);
        return;
      });
    });
  }

  static Future<String> getRootPath() async {
    Directory rootPath;
    if (Platform.isAndroid) {
      rootPath = await getExternalStorageDirectory();
    } else {
      rootPath = await getApplicationDocumentsDirectory();
    }
    return rootPath.path;
  }

  static Future<String> copy(File file) async {
    String filePath = file.path;
    String fullName = filePath.split('/').last;
    String fileName = fullName.split('.').first;
    String ext = fullName.split('.').last;

    String rootPath = await getRootPath();
    String targetPath = '';
    if (imageTypes.contains(ext.toLowerCase())) {
      targetPath = rootPath + '/images/';
    } else if (videoTypes.contains(ext.toLowerCase())) {
      targetPath = rootPath + '/videos/';
    } else {
      targetPath = rootPath + '/files/';
    }

    final newFile = await file.copy('$targetPath$fileName.$ext');

    return newFile.path;
  }
}
