import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../controller/video_editor_controller.dart';
import '../constants.dart';
import '../widgets/bars/deletion_bar.dart';
import '../widgets/bars/editing_bar.dart';

/// the basic skeleton of all editing bars
class BasicView extends StatelessWidget {
  final File file;
  const BasicView({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Selector<VideoEditingController, bool>(
              selector: (context, videoController) {
            return videoController.isDeletionEligible;
          }, builder: (context, isDeletionEligible, child) {
            if (isDeletionEligible) {
              return deletionBar(context: context);
            } else {
              return editingBar(file: file, context: context);
            }
          }),
          const Spacer(),
          Consumer<VideoEditingController>(
              builder: (context, videoController, child) {
            return videoController.editableItemInfo.isNotEmpty
                ? ElevatedButton(
                    onPressed: () {},
                    child: Text("Done"),
                  )
                : const SizedBox();
          }),
        ]),
      ],
    );
  }
}
