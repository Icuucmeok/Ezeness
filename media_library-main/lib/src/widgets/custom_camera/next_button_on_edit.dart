import 'package:flutter/material.dart';
import 'package:media_library/src/controller/config_controller.dart';
import 'package:provider/provider.dart';

import '../../controller/media_controller.dart';

class CameraNextButtonOnEdit extends StatelessWidget {
  const CameraNextButtonOnEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MediaController, bool>(
        selector: (context, mediaController) {
      return mediaController.editedImagesLength != null ||
          mediaController.editedImagesLength != 0;
    }, builder: (context, haveImages, child) {
      if (haveImages) {
        return GestureDetector(
          onTap: context.read<ConfigController>().nextButtonOnEdit,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[700], // Background color
            ),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 20, top: 20),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[300]!,
              size: 25,
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}
