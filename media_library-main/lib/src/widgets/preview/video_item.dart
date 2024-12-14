import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_library/core/entity/media_file.dart';
import 'package:media_library/core/extension/extensions.dart';
import 'package:media_library/core/widgets/loading_widget.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editable_item_type.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../controller/loading_controller.dart';
import '../../controller/media_controller.dart';
import '../image_editor/custom_editor_button.dart';

class VideoItem extends StatefulWidget {
  final MediaFile file;
  final int index;
  final PageController pageController;
  const VideoItem(
      {super.key,
      required this.file,
      required this.index,
      required this.pageController});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController controller;
  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              // ColorFiltered(
              //   colorFilter: ColorFilter.mode(Colors.grey, BlendMode.color),

              // colorFilter: widget.file.videoEditableItems?.map((e) {
              //       if (e.editableItemType == EditableItemType.filter) {
              //         return e.colorFilter;
              //       }
              //     }).first ??
              //     const ColorFilter.mode(Colors.transparent, BlendMode.clear),
              // child:
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              // ),
              if (controller.value.position == Duration.zero &&
                  !controller.value.isPlaying)
                Image.file(
                  File(widget.file.thumbnailUrl!),
                  fit: BoxFit.fitWidth,
                ),
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    // CustomEditorButton(
                    //   icon: Icons.edit,
                    //   onPressed: () async {
                    //     context
                    //         .read<MediaController>()
                    //         .openVideoEditor(widget.index, controller);
                    //   },
                    // ),
                    CustomEditorButton(
                      icon: Icons.edit,
                      onPressed: () async {
                        context
                            .read<MediaController>()
                            .openVideoEditor(widget.index, controller);
                      },
                    ),
                    Selector<LoadingController, bool>(
                      selector: (context, loadingController) {
                        return loadingController.isDeleteAssetLoading;
                      },
                      builder: (context, isAssetLoading, child) {
                        if (!isAssetLoading) {
                          return CustomEditorButton(
                            icon: Icons.delete_outline,
                            onPressed: () async {
                              context
                                  .read<LoadingController>()
                                  .toggleDeleteAssetLoading();
                              context
                                  .read<MediaController>()
                                  .deletePickedFile(widget.pageController);
                              context
                                  .read<LoadingController>()
                                  .toggleDeleteAssetLoading();
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  controller.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white,
                  size: 50,
                ),
                onPressed: () {
                  setState(() {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  });
                },
              ),
            ],
          )
        : const LoadingWidget();
  }

  @override
  void initState() {
    super.initState();
    initializeVideoController();
  }

  void initializeVideoController() {
    controller = VideoPlayerController.file(File(widget.file.path))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      controller.dispose();
      initializeVideoController();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
