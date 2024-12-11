import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums.dart';
import '../../controller/media_controller.dart';

class CameraNextButton extends StatelessWidget {
  const CameraNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MediaController, bool>(
        selector: (context, mediaController) {
      return mediaController.pickedFiles.isNotEmpty;
    }, builder: (context, haveImages, child) {
      if (haveImages) {
        return GestureDetector(
          onTap: () {
            context
                .read<MediaController>()
                .setScreenView(view: ScreenView.preview);
          },
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
              size: 30,
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}
