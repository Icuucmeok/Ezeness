import 'package:flutter/material.dart';
import 'package:hsv_color_pickers/hsv_color_pickers.dart';
import 'package:provider/provider.dart';
import '../../../../../controller/video_editor_controller.dart';

class ColorPickerSlider extends StatefulWidget {
  const ColorPickerSlider({Key? key}) : super(key: key);

  @override
  State<ColorPickerSlider> createState() => _ColorPickerSliderState();
}

class _ColorPickerSliderState extends State<ColorPickerSlider> {
  @override
  Widget build(BuildContext context) {
    return Selector<VideoEditingController, HSVColor>(
        selector: (context, videoController) {
      return videoController.hueController;
    }, builder: (context, hueController, child) {
      return RotatedBox(
        quarterTurns: 1,
        child: HuePicker(
          trackHeight: 10,
          controller: HueController(hueController),
          onChanged: (HSVColor color) {
            setState(() {
              hueController = color;
            });
          },
        ),
      );
    });
  }
}
