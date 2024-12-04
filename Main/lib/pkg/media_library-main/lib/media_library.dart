library media_library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_library/camera_page.dart';
import 'package:media_library/core/entity/media_file.dart';
import 'package:media_library/src/controller/config_controller.dart';
import 'package:media_library/src/controller/video_editor_controller.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'src/controller/loading_controller.dart';
import 'src/controller/media_controller.dart';

class MediaLibrary extends StatefulWidget {
  final ValueChanged<List<MediaFile>?> onPicked;
  final VoidCallback nextButtonOnEdit;
  final List<File> sharedFiles;
  final Widget backWidget;
  final Widget nextWidget;
  final int maxAssets;
  final int? editedImagesLength;
  const MediaLibrary({
    Key? key,
    required this.onPicked,
    required this.backWidget,
    required this.nextWidget,
    required this.maxAssets,
    this.editedImagesLength,
    required this.nextButtonOnEdit,
    required this.sharedFiles,
  }) : super(key: key);

  @override
  State<MediaLibrary> createState() => _MediaLibraryState();
}

class _MediaLibraryState extends State<MediaLibrary>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OKToast(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MediaController(
              widget.maxAssets,
              widget.editedImagesLength ?? 0,
              widget.sharedFiles,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => LoadingController(),
          ),
          ChangeNotifierProvider(
            create: (_) => ConfigController(
              nextButtonOnEdit: widget.nextButtonOnEdit,
              backWidget: widget.backWidget,
              nextWidget: widget.nextWidget,
              onPicked: widget.onPicked,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => VideoEditingController(),
          ),
        ],
        child: const CameraPage(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
