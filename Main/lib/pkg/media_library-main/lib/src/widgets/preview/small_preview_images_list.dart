import 'dart:io';
import 'dart:typed_data';
import 'package:media_library/core/extension/extensions.dart';
import 'package:flutter/material.dart';
import 'package:media_library/core/entity/media_file.dart';
import 'package:media_library/src/controller/loading_controller.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../controller/media_controller.dart';

class SmallPreviewImagesListWidget extends StatelessWidget {
  final PageController pageController;
  const SmallPreviewImagesListWidget({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaProvider = context.watch<MediaController>();

    return Row(
      children: List.generate(
        mediaProvider.pickedFiles.length,
        (index) {
          return GestureDetector(
              onTap: () {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              child: Selector<MediaController, bool>(
                  selector: (context, mediaController) {
                return mediaController.currentPreviewIndex == index;
              }, builder: (context, isCurrentIndex, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: isCurrentIndex ? 60 : 50,
                      height: isCurrentIndex ? 60 : 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust radius for a circle
                        border: Border.all(
                          color: isCurrentIndex
                              ? Colors.white
                              : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: ThumbItem(index: index)),
                );
              }));
        },
      ),
    );
  }
}

class ThumbItem extends StatelessWidget {
  final int index;
  const ThumbItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Selector<MediaController, List<MediaFile?>>(
      selector: (context, mediaController) {
        return mediaController.pickedFiles;
      },
      shouldRebuild: (previous, next) {
        return previous[index] != next[index];
      },
      builder: (context, thumbnails, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: thumbnails[index]!.isVideo()
              ? Image.file(
                  File(thumbnails[index]!.thumbnailUrl!),
                  fit: BoxFit.cover,
                )
              : Image.memory(
                  thumbnails[index]!.unit!,
                  fit: BoxFit.cover,
                ),
        );
      },
    );
  }
}
