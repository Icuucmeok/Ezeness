import 'dart:io';
import 'dart:typed_data';

import 'package:media_library/core/entity/media_file.dart';

import '../enums.dart';

extension IsVideo on MediaFile {
  bool isVideo() {
    final videoExtensions = [
      'mp4',
      'mov',
      'avi',
      'mkv',
      'flv',
      'wmv',
      'webm',
      'MP4'
    ];
    final extension = path.split('.').last;
    return videoExtensions.contains(extension);
  }
}

extension IsFileVideo on File {
  bool isVideo() {
    final videoExtensions = [
      'mp4',
      'mov',
      'avi',
      'mkv',
      'flv',
      'wmv',
      'webm',
      'MP4'
    ];
    final extension = path.split('.').last;
    return videoExtensions.contains(extension);
  }
}

extension Uint8ListToFile on Uint8List {
  File toFile(String path) {
    final file = File(path);
    file.writeAsBytesSync(this);
    return file;
    // return File(path).writeAsBytesSync(this);
    // return File(path).writeAsBytes(this);
  }
}

extension ScreenViewExtension on ScreenView {
  bool get isEditor {
    return this == ScreenView.videoTrimmer || this == ScreenView.imageEditor;
  }
}
