import 'package:flutter/material.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editing_mode.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/widgets/graphical_layer_component.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../../controller/video_editor_controller.dart';
import '../constants.dart';
import '../views/paint_view.dart';

class VideoAfterEditWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  const VideoAfterEditWidget({
    super.key,
    required this.videoPlayerController,
  });

  @override
  State<VideoAfterEditWidget> createState() => _VideoAfterEditWidgetState();
}

class _VideoAfterEditWidgetState extends State<VideoAfterEditWidget> {
  @override
  Widget build(BuildContext context) {
    final videoControllerProvider =
        Provider.of<VideoEditingController>(context);
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(
          Constants.filters[videoControllerProvider.selectedFilter]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
              aspectRatio: widget.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(widget.videoPlayerController)),
          //Paint Layer
          //To Avoid Duplication of Painting Lines
          Visibility(
              visible: !(videoControllerProvider.editingModeSelected ==
                  EditorMode.DRAWING),
              child: const PaintView(shouldShowControls: false)),

          const GraphicalLayerComponent(),
          IconButton(
            icon: Icon(
              widget.videoPlayerController.value.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              color: Colors.white,
              size: 50,
            ),
            onPressed: () {
              setState(() {
                if (widget.videoPlayerController.value.isPlaying) {
                  widget.videoPlayerController.pause();
                } else {
                  widget.videoPlayerController.play();
                }
              });
            },
          )
        ],
      ),
    );
  }
}
