import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../../../../controller/video_editor_controller.dart';
import '../../constants.dart';

//Allows to add caption on the image
Container captionBar({required BuildContext context}) {
  final videoController = Provider.of<VideoEditingController>(context);
  return Container(
    height:
        MediaQuery.of(context).size.height * Constants.captionBarHeightRatio,
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
          color: Constants.mattBlack,
          borderRadius: const BorderRadius.all(Radius.circular(24.0))),
      child: Row(children: [
        const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        const SizedBox(width: 10.0),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: videoController.caption),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400),
            onSubmitted: (value) {
              videoController.caption = value;
            },
            decoration: const InputDecoration.collapsed(
              hintText: 'Add a caption...',
              hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ]),
    ),
  );
}
