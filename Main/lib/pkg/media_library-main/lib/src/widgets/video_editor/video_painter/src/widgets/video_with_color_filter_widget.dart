import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../../controller/video_editor_controller.dart';
import '../constants.dart';

class VideoWithColorFilterWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool showPlayButton;
  const VideoWithColorFilterWidget({
    super.key,
    required this.videoPlayerController,
    this.showPlayButton = true,
  });

  @override
  State<VideoWithColorFilterWidget> createState() =>
      _VideoWithColorFilterWidgetState();
}

class _VideoWithColorFilterWidgetState
    extends State<VideoWithColorFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(Constants.filters[
          Provider.of<VideoEditingController>(context).selectedFilter]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
              aspectRatio: widget.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(widget.videoPlayerController)),
          if (widget.showPlayButton)
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
