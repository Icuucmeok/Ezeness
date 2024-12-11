import 'package:media_library/core/widgets/loading_widget.dart';
import 'package:media_library/src/controller/config_controller.dart';
import 'package:media_library/src/controller/loading_controller.dart';
import 'package:media_library/src/controller/media_controller.dart';

import 'package:flutter/material.dart';
import 'package:media_library/src/widgets/video_editor/video_editor.dart';
import 'package:media_library/src/widgets/custom_appbar.dart';
import 'package:media_library/src/widgets/custom_camera/custom_camera.dart';
import 'package:provider/provider.dart';

import 'core/enums.dart';
import 'src/controller/video_editor_controller.dart';
import 'src/widgets/preview/preview_screen.dart.dart';
import 'src/widgets/video_editor/video_painter/src/views/main_view.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        onPressed: () {
          final mediaFiles =
              Provider.of<MediaController>(context, listen: false).pickedFiles;
          Provider.of<ConfigController>(context, listen: false)
              .exportFiles(mediaFiles);
        },
      ),
      body: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Selector<MediaController, ScreenView>(
                  selector: (context, mediaController) {
                return mediaController.screenView;
              }, builder: (context, screenView, child) {
                switch (screenView) {
                  case ScreenView.camera:
                    return const CustomCamera();
                  case ScreenView.preview:
                    return const PreviewScreen();
                  case ScreenView.videoTrimmer:
                    return VideoEditor(
                      file: context
                          .read<MediaController>()
                          .selectedMediaItem!
                          .getFile()!,
                      videoPlayerController: context
                          .read<MediaController>()
                          .selectedVideoController!,
                    )as Widget;
                  default:
                    return const SizedBox();
                }
              }),
              Selector<LoadingController, bool>(
                  selector: (context, loadingController) {
                return loadingController.isAddingGalleryPicsLoading;
              }, builder: (context, isLoading, child) {
                if (isLoading) {
                  return const LoadingWidget();
                }
                return const SizedBox();
              })
            ],
          )),
    );
  }
}
