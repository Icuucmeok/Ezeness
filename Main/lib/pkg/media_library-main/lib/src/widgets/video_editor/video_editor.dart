import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:media_library/core/entity/media_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:compressor/compressor.dart';
// import 'package:video_editor/video_editor.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';

import '../../../core/entity/media_file.dart';
import '../../../core/enums.dart';
import '../../../pkg/compressor-main/lib/compressor.dart';
import '../../controller/media_controller.dart';
import 'video_crop_image.dart';

class VideoEditor extends StatefulWidget {
  const VideoEditor(
      {super.key, required this.file, required this.videoPlayerController});
  final VideoPlayerController videoPlayerController;

  final File file;

  @override
  State<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  final double height = 60;

  late final VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds: 1),
    maxDuration: Duration(
        seconds: widget.videoPlayerController.value.duration.inSeconds >= 180
            ? 180
            : widget.videoPlayerController.value.duration.inSeconds),
    coverThumbnailsQuality: 30,
    trimThumbnailsQuality: 5,
  );

  @override
  void initState() {
    super.initState();
    _controller
        .initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
      // handle minumum duration bigger than video duration error
      Navigator.pop(context);
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() async {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[700],
          duration: const Duration(seconds: 1),
        ),
      );

  void _exportVideo() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/compressed_videos';
    await Directory(dirPath).create(recursive: true);
    final String compressedPath =
        '$dirPath/compressed_video_${DateTime.now().microsecondsSinceEpoch}.mp4';
    final start = (_controller.startTrim.inMilliseconds / 1000).floor();
    final end = (_controller.endTrim.inMilliseconds / 1000).floor();

    Compressor.trimVideo(
            widget.file.path, compressedPath, start.toDouble(), end.toDouble())
        .then((value) {
      if (value == null) {
        _showErrorSnackBar("Error on video trim exportation.");
        return;
      }
      final provider = Provider.of<MediaController>(context, listen: false);

      provider.replaceEditedVideo(MediaFile.fromFile(File(value)));
    });

    if (!mounted) return;
  }

  void _exportCover() async {
    if (_controller.selectedCoverVal == null ||
        _controller.selectedCoverVal!.thumbData == null) {
      _showErrorSnackBar("No cover selected.");
      return;
    }
    final provider = Provider.of<MediaController>(context, listen: false);
    provider.replaceCoverImage(_controller.selectedCoverVal!.thumbData!);

    _showErrorSnackBar("Cover exported successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.initialized
            ? SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _topNavBar(),
                        Expanded(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Expanded(
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CropGridViewer.preview(
                                              controller: _controller),
                                          AnimatedBuilder(
                                            animation: _controller.video,
                                            builder: (_, __) => AnimatedOpacity(
                                              opacity:
                                                  _controller.isPlaying ? 0 : 1,
                                              duration: kThemeAnimationDuration,
                                              child: GestureDetector(
                                                onTap: _controller.video.play,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CoverViewer(controller: _controller)
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      const TabBar(
                                        tabs: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                        Icons.content_cut)),
                                                Text('Trim')
                                              ]),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child:
                                                      Icon(Icons.video_label)),
                                              Text('Cover')
                                            ],
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: _trimSlider(),
                                            ),
                                            _coverSelection(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ValueListenableBuilder(
                                //   valueListenable: _isExporting,
                                //   builder: (_, bool export, Widget? child) =>
                                //       AnimatedSize(
                                //     duration: kThemeAnimationDuration,
                                //     child: export ? child : null,
                                //   ),
                                //   child: AlertDialog(
                                //     title: ValueListenableBuilder(
                                //       valueListenable: _exportingProgress,
                                //       builder: (_, double value, __) => Text(
                                //         "Exporting video ${(value * 100).ceil()}%",
                                //         style: const TextStyle(fontSize: 12),
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  context
                      .read<MediaController>()
                      .setScreenView(view: ScreenView.preview);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                tooltip: 'Leave editor',
              ),
            ),
            const VerticalDivider(endIndent: 22, indent: 22),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.left),
                icon: const Icon(Icons.rotate_left),
                tooltip: 'Rotate unclockwise',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.right),
                icon: const Icon(Icons.rotate_right),
                tooltip: 'Rotate clockwise',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => CropPage(controller: _controller),
                  ),
                ),
                icon: const Icon(Icons.crop),
                tooltip: 'Open crop screen',
              ),
            ),
            const VerticalDivider(endIndent: 22, indent: 22),
            IconButton(
                onPressed: _exportVideo,
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                )),
            TextButton(
              onPressed: _exportCover,
              child: const Text(
                "Save Cover",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            // Expanded(
            //   child: PopupMenuButton(
            //     tooltip: 'Open export menu',
            //     icon: const Icon(
            //       Icons.save,
            //       color: Colors.white,
            //     ),
            //     color: Colors.white,
            //     itemBuilder: (context) => [
            //       PopupMenuItem(
            //         onTap: _exportCover,
            //         child: const Text('Export cover'),
            //       ),
            //       PopupMenuItem(
            //         onTap: _exportVideo,
            //         textStyle: const TextStyle(color: Colors.black),
            //         child: const Text('Export video'),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _controller.video,
        ]),
        builder: (_, __) {
          final int duration = _controller.videoDuration.inSeconds;
          final double pos = _controller.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(seconds: pos.toInt()))),
              const Expanded(child: SizedBox()),
              AnimatedOpacity(
                opacity: _controller.isTrimming ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(formatter(_controller.startTrim)),
                  const SizedBox(width: 10),
                  Text(formatter(_controller.endTrim)),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      )
    ];
  }

  Widget _coverSelection() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: CoverSelection(
            controller: _controller,
            size: height + 10,
            quantity: 8,
            selectedCoverBuilder: (cover, size) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  cover,
                  Icon(
                    Icons.check_circle,
                    color: const CoverSelectionStyle().selectedBorderColor,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
