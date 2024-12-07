import 'package:ezeness/data/models/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../res/app_res.dart';

class VideoWidget extends StatefulWidget {
  final PostMedia media;
  const VideoWidget({Key? key, required this.media}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

double volume = 1;

class _VideoWidgetState extends State<VideoWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late VideoPlayerController videoPlayerController;
  bool isPlaying = true;
  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.media.path!))
          ..initialize().then((_) {
            setState(() {});
          });
    videoPlayerController.setLooping(true);
    videoPlayerController.setVolume(volume);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        if (videoPlayerController.value.isPlaying) {
          videoPlayerController.pause();
          isPlaying = false;
        } else {
          videoPlayerController.play();
          isPlaying = true;
        }
        setState(() {});
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: VisibilityDetector(
          key: ObjectKey(videoPlayerController),
          onVisibilityChanged: (visibility) {
            if (visibility.visibleFraction == 0 && mounted) {
              videoPlayerController.pause();
              KeepScreenOn.turnOff();
            }
            if (visibility.visibleFraction == 1 && mounted) {
              videoPlayerController.play();
              KeepScreenOn.turnOn();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              videoPlayerController.value.isInitialized
                  ? VisibilityDetector(
                      key: ObjectKey(videoPlayerController),
                      onVisibilityChanged: (visibility) {
                        if (visibility.visibleFraction == 0 && mounted) {
                          videoPlayerController.pause();
                          isPlaying = false;
                          KeepScreenOn.turnOff();
                        }
                        if (visibility.visibleFraction == 1 && mounted) {
                          videoPlayerController.play();
                          isPlaying = true;
                          KeepScreenOn.turnOn();
                        }
                        if (mounted) setState(() {});
                      },
                      child: AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                          widget.media.thumbnail ??
                              Constants.defaultVideoThumbnail,
                          fit: BoxFit.contain),
                    ),
              if (!isPlaying)
                Icon(IconlyBold.play,
                    color: AppColors.whiteColor.withOpacity(0.5), size: 35.dg),
              Positioned(
                right: 20.dg,
                bottom: 5,
                child: GestureDetector(
                    onTap: () {
                      if (videoPlayerController.value.volume == 0) {
                        videoPlayerController.setVolume(1);
                        volume = 1;
                      } else {
                        videoPlayerController.setVolume(0);
                        volume = 0;
                      }
                      setState(() {});
                    },
                    child: Icon(
                      videoPlayerController.value.volume == 0
                          ? IconlyBold.volume_off
                          : IconlyBold.volume_up,
                      size: 25,
                      color: Colors.white70,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
