import 'package:flutter/material.dart';

import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editing_mode.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/video_editor_controller.dart';

GestureDetector verticalGestureBehavior(
    {required Widget child, required BuildContext context}) {
  late DragStartDetails? startVerticalDragDetails;
  late DragUpdateDetails? updateVerticalDragDetails;
  return GestureDetector(
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dy = updateVerticalDragDetails!.globalPosition.dy -
            startVerticalDragDetails!.globalPosition.dy;

        if (dy < 0) {
          Provider.of<VideoEditingController>(context, listen: false)
              .editingModeSelected = EditorMode.FILTERS;
        } else {
          Provider.of<VideoEditingController>(context, listen: false)
              .editingModeSelected = EditorMode.NONE;
        }
      },
      child: child);
}
