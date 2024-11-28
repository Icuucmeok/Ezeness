import 'package:flutter/material.dart';
import 'package:media_library/core/entity/media_file.dart';
import 'package:media_library/core/extension/extensions.dart';
import 'package:media_library/src/widgets/preview/video_item.dart';
import '../image_editor/image_crop.dart';

class MediaItem extends StatelessWidget {
  final MediaFile file;
  final int index;
  final PageController pageController;
  const MediaItem(
      {super.key,
      required this.file,
      required this.index,
      required this.pageController});

  @override
  Widget build(BuildContext context) {
    if (file.isVideo()) {
      return VideoItem(
          file: file,
          index: index,
          pageController:
              pageController); // Don't show anything while loading video
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.memory(
            file.unit!,
            fit: BoxFit.fitWidth,
          ),
          CropImageWidget(
            selectedMediaItem: file,
            pageController: pageController,
          ),
        ],
      );
    }
  }
}
