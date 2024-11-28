import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:media_library/core/entity/media_file.dart';
import 'package:media_library/src/controller/loading_controller.dart';
import 'package:media_library/src/widgets/image_editor/custom_editor_button.dart';
import 'package:provider/provider.dart';

import '../../controller/media_controller.dart';
import 'vs_story_designer/vs_story_designer.dart';

class CropImageWidget extends StatelessWidget {
  final MediaFile selectedMediaItem;
  final PageController pageController;
  const CropImageWidget(
      {super.key,
      required this.selectedMediaItem,
      required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        children: [
          CustomEditorButton(
            icon: Icons.edit,

            onPressed: () {
              // context
              //     .read<MediaController>()
              //     .setScreenView(view: ScreenView.imageEditor);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => VSStoryDesigner(
                    centerText: "Start Your Design",
                    middleBottomWidget: const SizedBox(),
                    fileName: "taher",
                    mediaPath: selectedMediaItem.path,
                    onDone: (uri) async {
                      final file = File(uri);

                      context.read<MediaController>().replaceCropImage(
                            MediaFile.fromFile(
                              file,
                              unit: await file.readAsBytes(),
                            ),
                          );
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              );
            },

            // replace with edited image
          ),
          CustomEditorButton(
            icon: Icons.delete_outline,
            onPressed: () async {
              context.read<LoadingController>().toggleDeleteAssetLoading();

              context.read<MediaController>().deletePickedFile(pageController);
              context.read<LoadingController>().toggleDeleteAssetLoading();
            },
            // replace with edited image
          ),
        ],
      ),
    );
  }
}
