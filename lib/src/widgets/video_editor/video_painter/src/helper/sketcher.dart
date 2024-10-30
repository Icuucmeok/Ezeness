import 'package:flutter/material.dart';

import 'package:media_library/src/controller/video_editor_controller.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:provider/provider.dart';

import "../enums/editing_mode.dart";
import "../models/graphic_info.dart";
import "../models/paint_info.dart";

class Sketcher extends CustomPainter {
  final EditorMode editingmode;
  final PaintInfo? paintInfo;
  BuildContext context;
  Sketcher({
    required this.editingmode,
    required this.context,
    this.paintInfo,
  }) {
    assert(
        (paintInfo != null && editingmode == EditorMode.DRAWING) ||
            (paintInfo == null && editingmode == EditorMode.TEXT),
        "PaintInfo can't be null with Drawing as Drawing Mode, OR PaintInfo not valid with Text as Editing Mode");
  }

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    if (editingmode == EditorMode.DRAWING) {
      Paint paint = Paint()..color = paintInfo!.options.color;
      for (int i = 0; i < paintInfo!.lines.length; ++i) {
        final outlinePoints = getStroke(
          paintInfo!.lines[i].points,
          // size: paintInfo!.lines[i].options.size,
          // thinning: paintInfo!.lines[i].options.thinning,
          // smoothing: paintInfo!.lines[i].options.smoothing,
          // streamline: paintInfo!.lines[i].options.streamline,
          // taperStart: paintInfo!.lines[i].options.taperStart,
          // capStart: paintInfo!.lines[i].options.capStart,
          // taperEnd: paintInfo!.lines[i].options.taperEnd,
          // capEnd: paintInfo!.lines[i].options.capEnd,
          // simulatePressure: paintInfo!.lines[i].options.simulatePressure,
          // isComplete: paintInfo!.lines[i].options.isComplete,
        );
        paint.color = paintInfo!.lines[i].color;
        paint
          ..strokeWidth = 5
          // ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5)
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..strokeMiterLimit = 5
          ..filterQuality = FilterQuality.high
          ..style = PaintingStyle.fill;

        final path = Path();
        if (outlinePoints.isEmpty) {
          return;
        } else if (outlinePoints.length < 2) {
          // If the path only has one line, draw a dot.
          path.addOval(Rect.fromCircle(
              center: Offset(outlinePoints[0].dx, outlinePoints[0].dy),
              radius: 1));
        } else {
          // Otherwise, draw a line that connects each point with a curve.
          path.moveTo(outlinePoints[0].dx, outlinePoints[0].dy);
          for (int i = 1; i < outlinePoints.length - 1; ++i) {
            final p0 = outlinePoints[i];
            final p1 = outlinePoints[i + 1];
            path.quadraticBezierTo(
                p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
          }
        }
        canvas.drawPath(path, paint);
      }
    } else if (editingmode == EditorMode.TEXT) {
      // List<TextInfo> textOnImageList =
      //     Get.find<EditingController>().textOnImage;
      List<VideoEditableItem> textOnImageList =
          Provider.of<VideoEditingController>(context).getEditableTextType();
      for (int i = 0; i < textOnImageList.length; i++) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: textOnImageList.elementAt(i).text!.text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: textOnImageList.elementAt(i).text!.color,
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          maxLines: 10,
        )..layout(minWidth: 0.0, maxWidth: size.width);
        double y = size.height / 2; //+ (i * 50);
        double x = 0;
        textPainter.paint(
            canvas, textOnImageList.elementAt(i).text!.offset ?? Offset(x, y));
      }
    } else {
      return;
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}
