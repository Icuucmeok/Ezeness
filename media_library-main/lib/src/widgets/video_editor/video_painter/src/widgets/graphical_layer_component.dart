import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editable_item_type.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editing_mode.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/helper/transformable.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/models/graphic_info.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/widgets/text_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/video_editor_controller.dart';
import '../constants.dart';

class GraphicalLayerComponent extends StatefulWidget {
  const GraphicalLayerComponent({super.key});

  @override
  State<GraphicalLayerComponent> createState() =>
      _GraphicalLayerComponentState();
}

class _GraphicalLayerComponentState extends State<GraphicalLayerComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  bool isAnimating = false;
  double scaleFactor = 1.0;
  int currentTransformingWidget = -1;

  void _runAnimation(VideoEditingController videoControllerProvider) {
    animationController.forward().whenComplete(() {
      videoControllerProvider.editableItemInfo
          .removeAt(currentTransformingWidget);
      videoControllerProvider.isDeletionEligible = false;
      currentTransformingWidget = -1;
      setState(() {});
    });
  }

  checkIfDeletionEligible(int j, ScaleUpdateDetails d,
      VideoEditingController videoControllerProvider, double width) {
    videoControllerProvider.isDeletionEligible = true;
    setState(() => currentTransformingWidget = j);
    if (d.focalPoint.dx <= width / 3.5 &&
        d.focalPoint.dy < width * Constants.editingBarHeightRatio + 50) {
      _runAnimation(videoControllerProvider);
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 02),
      vsync: this,
    );
    animation = Tween<double>(begin: 1.5, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoControllerProvider =
        Provider.of<VideoEditingController>(context);
    final videoControl =
        Provider.of<VideoEditingController>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        for (int j = 0;
            j < videoControllerProvider.editableItemInfo.length;
            j++)
          videoControllerProvider.editableItemInfo
                      .elementAt(j)!
                      .editableItemType ==
                  EditableItemType.text
              ? TransformableWidget(
                  onTapDown: () {
                    TextDialog.show(
                        context,
                        TextEditingController(
                            text: videoControllerProvider.editableItemInfo
                                .elementAt(j)!
                                .text!
                                .text),
                        36,
                        videoControllerProvider.editableItemInfo
                            .elementAt(j)!
                            .text!
                            .color,
                        onFinished: (context) => Navigator.of(context).pop(),
                        onSubmitted: (String text) {
                          videoControllerProvider.editableItemInfo[j] =
                              VideoEditableItem(
                                  editableItemType: videoControllerProvider
                                      .editableItemInfo
                                      .elementAt(j)!
                                      .editableItemType,
                                  text: videoControllerProvider.editableItemInfo
                                      .elementAt(j)!
                                      .text!
                                      .copyWith(text: text),
                                  matrixInfo: videoControllerProvider
                                      .editableItemInfo
                                      .elementAt(j)!
                                      .matrixInfo);
                          videoControllerProvider.editingModeSelected =
                              EditorMode.NONE;
                        });
                  },
                  onDetailsUpdate: (Matrix4 matrix4) {
                    videoControllerProvider.editableItemInfo[j] =
                        VideoEditableItem(
                            editableItemType:
                                videoControllerProvider
                                    .editableItemInfo
                                    .elementAt(j)!
                                    .editableItemType,
                            text: videoControllerProvider.editableItemInfo
                                .elementAt(j)!
                                .text,
                            matrixInfo: matrix4);
                  },
                  onScaleStart: (details) {
                    setState(() => scaleFactor = details.scale.toDouble());
                    checkIfDeletionEligible(j, details, videoControl, width);
                  },
                  onScaleEnd: (d) {
                    videoControllerProvider.isDeletionEligible = false;
                    setState(() {});
                  },
                  transform: videoControllerProvider.editableItemInfo
                      .elementAt(j)!
                      .matrixInfo,
                  child: ScaleTransition(
                    scale: currentTransformingWidget == j
                        ? animation
                        : Tween<double>(begin: 1.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Curves.easeInOut)),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 100, minHeight: 100),
                      child: Text(
                          videoControllerProvider.editableItemInfo
                              .elementAt(j)!
                              .text!
                              .text,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          textScaleFactor: scaleFactor,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  color: videoControllerProvider
                                      .editableItemInfo
                                      .elementAt(j)!
                                      .text!
                                      .color)),
                    ),
                  ))
              : videoControllerProvider.editableItemInfo
                          .elementAt(j)!
                          .editableItemType ==
                      EditableItemType.graphic
                  ? TransformableWidget(
                      onScaleStart: (details) {
                        checkIfDeletionEligible(
                            j, details, videoControl, width);
                      },
                      onScaleEnd: (d) {
                        videoControllerProvider.isDeletionEligible = false;
                        setState(() {});
                      },
                      transform: videoControllerProvider.editableItemInfo
                          .elementAt(j)!
                          .matrixInfo,
                      onDetailsUpdate: (Matrix4 matrix4) {
                        videoControllerProvider.editableItemInfo[j] =
                            VideoEditableItem(
                                editableItemType: videoControllerProvider
                                    .editableItemInfo
                                    .elementAt(j)!
                                    .editableItemType,
                                graphicItemPath: videoControllerProvider
                                    .editableItemInfo
                                    .elementAt(j)!
                                    .graphicItemPath,
                                matrixInfo: matrix4);
                      },
                      child: ScaleTransition(
                          scale: currentTransformingWidget == j
                              ? animation
                              : Tween<double>(begin: 1.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController,
                                      curve: Curves.easeInOut)),
                          child: Image.asset(
                            videoControllerProvider.editableItemInfo
                                .elementAt(j)!
                                .graphicItemPath!,
                            fit: BoxFit.contain,
                          )))
                  : videoControllerProvider.editableItemInfo
                              .elementAt(j)!
                              .editableItemType ==
                          EditableItemType.shape
                      ? TransformableWidget(
                          onScaleStart: (details) {
                            checkIfDeletionEligible(
                                j, details, videoControl, width);
                          },
                          onScaleEnd: (d) {
                            videoControllerProvider.isDeletionEligible = false;
                            setState(() {});
                          },
                          transform: videoControllerProvider.editableItemInfo
                              .elementAt(j)!
                              .matrixInfo,
                          onDetailsUpdate: (Matrix4 matrix4) {
                            videoControllerProvider.editableItemInfo[j] =
                                VideoEditableItem(
                                    editableItemType: videoControllerProvider
                                        .editableItemInfo
                                        .elementAt(j)!
                                        .editableItemType,
                                    shapeSvg: videoControllerProvider
                                        .editableItemInfo
                                        .elementAt(j)!
                                        .shapeSvg,
                                    matrixInfo: matrix4);
                          },
                          child: ScaleTransition(
                              scale: currentTransformingWidget == j
                                  ? animation
                                  : Tween<double>(begin: 1.0, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: animationController,
                                          curve: Curves.easeInOut)),
                              child: SvgPicture.string(
                                videoControllerProvider.editableItemInfo
                                    .elementAt(j)!
                                    .shapeSvg!,
                                height: 100,
                                fit: BoxFit.fitWidth,
                              )))
                      : const SizedBox(),
      ],
    );
  }
}
