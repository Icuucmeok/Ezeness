import 'dart:io';
import 'package:iconly/iconly.dart';
import 'package:media_library/src/controller/media_controller.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editable_item_type.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editing_mode.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/models/graphic_info.dart';
import 'package:provider/provider.dart';

import '../../../../../../controller/video_editor_controller.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../widgets/icon_widget.dart';
import '../../widgets/undo.dart';

/// The top editing bar containing crop, graphics (Stickers/Emojie), text and Painting
editingBar({required BuildContext context, required File file}) {
  final videoController = Provider.of<VideoEditingController>(context);
  final provider = Provider.of<VideoEditingController>(context, listen: false);
  return Container(
    height:
        MediaQuery.of(context).size.height * Constants.editingBarHeightRatio,
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      children: [
        Selector<VideoEditingController, int>(
            selector: (context, videoEditController) {
          return videoEditController.selectedFilter;
        }, builder: (context, selectedFilter, child) {
          return buildIcon(
              onTap: () async {
                // Provider.of<MediaController>(context, listen: false)
                //     .replaceEditedVideo(
                //         Provider.of<MediaController>(context, listen: false)
                //             .selectedMediaItem!
                //             .copyWith(
                //                 videoEditableItem: VideoEditableItem(
                //                     editableItemType: EditableItemType.filter,
                //                     matrixInfo: Matrix4.identity(),
                //                     colorFilter: ColorFilter.matrix(
                //                         Constants.filters[selectedFilter]))));
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: Icons.close);
        }),
        const Spacer(),
        videoController.editableItemInfo.isNotEmpty
            ? undo(onTap: () {
                provider.editableItemInfo.removeLast();
              })
            : const SizedBox(),
        const SizedBox(width: 16.0),
        buildIcon(
            icon: Icons.crop_free,
            onTap: () {
              // takeScreenshotAndReturnMemoryImage(getScreenshotKey)
              //     .then((MemoryImage imageData) {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => CropView(image: file)
              //           // builder: (context) => CropView2(image:file,title: "Hello",)
              //           ));
              // });
            }),
        const SizedBox(width: 16.0),
        buildIcon(
            icon: IconlyBold.star,
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const GraphicView()));

              // Provider.of<MediaController>(context, listen: false)
              //     .setScreenView(view: ScreenView.videoEDitorGraphicalView);
            }),
        const SizedBox(width: 16.0),
        buildIcon(
            icon: Icons.title,
            onTap: () => provider.editingModeSelected = EditorMode.TEXT),
        const SizedBox(width: 16.0),
        buildIcon(
            icon: IconlyBold.edit,
            onTap: () {
              provider.editingModeSelected = EditorMode.DRAWING;
            }),
        const SizedBox(width: 16.0),
        // provider selector
        Selector<VideoEditingController, int>(
            selector: (context, videoEditController) {
          return videoEditController.selectedFilter;
        }, builder: (context, selectedFilter, child) {
          return buildIcon(
              icon: IconlyBold.video,
              onTap: () {
                provider.toggleFilter();
                provider.addToEditableItemList(VideoEditableItem(
                    editableItemType: EditableItemType.filter,
                    matrixInfo: Matrix4.identity(),
                    colorFilter:
                        ColorFilter.matrix(Constants.filters[selectedFilter])));
                Provider.of<MediaController>(context, listen: false)
                    .replaceEditedVideo(
                        Provider.of<MediaController>(context, listen: false)
                            .selectedMediaItem!
                            .copyWith(
                                videoEditableItem: VideoEditableItem(
                                    editableItemType: EditableItemType.filter,
                                    matrixInfo: Matrix4.identity(),
                                    colorFilter: ColorFilter.matrix(
                                        Constants.filters[selectedFilter]))));
                // .editingModeSelected = EditorMode.FILTERS;
              });
        })
      ],
    ),
  );
}
