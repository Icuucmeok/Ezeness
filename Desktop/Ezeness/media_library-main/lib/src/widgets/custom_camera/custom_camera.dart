import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:media_library/src/controller/media_controller.dart';
import 'package:media_library/src/widgets/custom_camera/camer_next_button.dart';
import 'package:media_library/src/widgets/custom_camera/gallery_picker_button.dart';
import 'package:media_library/src/widgets/custom_camera/next_button_on_edit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/entity/media_file.dart';
import '../../../core/enums.dart';

class CustomCamera extends StatelessWidget {
  const CustomCamera({super.key});

  Future<CaptureRequest> _buildPhotoPath(List<Sensor> sensors) async {
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/camerawesome').create(recursive: true);

    if (sensors.length == 1) {
      final String filePath =
          '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      return SingleCaptureRequest(filePath, sensors.first);
    }

    // Separate pictures taken with front and back camera
    final paths = {
      for (final sensor in sensors)
        sensor:
            '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : 'back_'}${DateTime.now().millisecondsSinceEpoch}.jpg',
    };
    return MultipleCaptureRequest(paths);
  }

  Future<CaptureRequest> _buildVideoPath(List<Sensor> sensors) async {
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/camerawesome').create(recursive: true);
    final String filePath =
        '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
    return SingleCaptureRequest(filePath, sensors.first);
  }

  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.awesome(
      theme: AwesomeTheme(
        bottomActionsBackgroundColor: Colors.transparent,
        buttonTheme: AwesomeButtonTheme(
          iconSize: 25,
          backgroundColor: Colors.grey[800]!,
          foregroundColor: Colors.grey[300]!,
        ),
      ),
      saveConfig: SaveConfig.photoAndVideo(
        initialCaptureMode: CaptureMode.photo,
        photoPathBuilder: (sensors) => _buildPhotoPath(sensors),
        videoPathBuilder: (sensors) => _buildVideoPath(sensors),
        videoOptions: VideoOptions(
          quality: VideoRecordingQuality.highest,
          enableAudio: true,
          ios: CupertinoVideoOptions(fps: 10),
          android: AndroidVideoOptions(
            bitrate: 6000000,
            fallbackStrategy: QualityFallbackStrategy.lower,
          ),
        ),
        exifPreferences: ExifPreferences(saveGPSLocation: false),
      ),
      sensorConfig: SensorConfig.single(
        sensor: Sensor.position(SensorPosition.back),
        flashMode: FlashMode.auto,
        aspectRatio: CameraAspectRatios.ratio_16_9,
        zoom: 0.0,
      ),
      enablePhysicalButton: true,
      previewAlignment: Alignment.center,
      previewFit: CameraPreviewFit.contain,
      onMediaTap: (MediaCapture mediaCapture) {
        mediaCapture.captureRequest.when(
          single: (single) async {
            final file = File(single.file!.path);
            final bytes = await single.file!.readAsBytes();
            context.read<MediaController>().addPickedFile(
                  MediaFile.fromFile(
                    file,
                    unit: bytes,
                  ),
                );

            context
                .read<MediaController>()
                .setScreenView(view: ScreenView.preview);
          },
          multiple: (multiple) {
            multiple.fileBySensor.forEach((key, value) {});
          },
        );
      },
      bottomActionsBuilder: (state) {
        state.when(
          onPhotoMode: (p0) async {
            await Provider.of<MediaController>(context, listen: false)
                .fetchFirstImage();
            state.captureState$.listen((event) async {
              if (event?.status == MediaCaptureStatus.success) {
                final file = File(event!.captureRequest.path!);
                final bytes = await file.readAsBytes();
                context.read<MediaController>().addPickedFile(
                      MediaFile.fromFile(file, unit: bytes),
                    );
                context
                    .read<MediaController>()
                    .setScreenView(view: ScreenView.preview);
              }
            });
          },
        );

        return AwesomeBottomActions(
          left: const GalleryPickerButton(),
          state: state,
          captureButton: SizedBox(
            width: 75,
            height: 90,
            child: AwesomeCaptureButton(state: state),
          ),
          right: AwesomeCameraSwitchButton(
            state: state,
            onSwitchTap: (p0) async {
              final sensorConfig = await p0.sensorConfig$.first;
              state.switchCameraSensor();
              sensorConfig.setAspectRatio(CameraAspectRatios.ratio_16_9);
            },
          ),
        );
      },
      topActionsBuilder: (state) => AwesomeTopActions(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        state: state,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[800])),
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: Colors.grey[300], size: 30),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Selector<MediaController, bool>(
                selector: (context, mediaController) =>
                    mediaController.editedImagesLength != 0 &&
                    mediaController.pickedFiles.isEmpty,
                builder: (context, haveImages, child) {
                  return haveImages
                      ? const CameraNextButtonOnEdit()
                      : const CameraNextButton();
                },
              ),
              AwesomeFlashButton(state: state),
            ],
          ),
        ],
      ),
    );
  }
}

Future<String> path(CaptureMode captureMode) async {
  final Directory extDir = await getTemporaryDirectory();
  final testDir =
      await Directory('${extDir.path}/test').create(recursive: true);
  final String fileExtension = captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
  final String filePath =
      '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
  return filePath;
}
