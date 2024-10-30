import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_library/core/entity/media_file.dart';

class ConfigController with ChangeNotifier {
  late final Widget backWidget;
  late final Widget nextWidget;
  late final ValueChanged<List<MediaFile>?> onPicked;
  late final VoidCallback nextButtonOnEdit;

  ConfigController({
    required this.backWidget,
    required this.nextWidget,
    required this.onPicked,
    required this.nextButtonOnEdit,
  });

  void exportFiles(List<MediaFile> pickedFiles) {
    onPicked(pickedFiles);
  }
}
