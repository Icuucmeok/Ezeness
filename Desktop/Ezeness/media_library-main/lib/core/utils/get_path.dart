// get path

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathProvider {
  static Future<String?> outPutFile({bool isVideo = true}) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    if (isVideo) {
      final String dirPath = '${extDir.path}/compressed_videos';
      await Directory(dirPath).create(recursive: true);
      return '$dirPath/${DateTime.now().millisecondsSinceEpoch}.mp4';
    } else {
      final String dirPath = '${extDir.path}/cover_images';
      await Directory(dirPath).create(recursive: true);
      return '$dirPath/${DateTime.now().millisecondsSinceEpoch}.JPEG';
    }
  }
}
