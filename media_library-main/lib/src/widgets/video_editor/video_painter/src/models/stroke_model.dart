import 'package:flutter/material.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/models/stroke_options_model.dart'
    as model;
import 'package:perfect_freehand/perfect_freehand.dart';

class Stroke {
  final List<Point> points;
  final Color color;
  final model.StrokeOptions options;
  const Stroke(this.points, this.color, this.options);
}
