import 'package:flutter/material.dart';

class ResponsiveTextWidget extends StatelessWidget {
  final String text;
  final double baseFontSize;
  final double reducedFontSize;
  final int threshold;
  const ResponsiveTextWidget(
      {Key? key,
      required this.text,
      required this.baseFontSize,
      required this.reducedFontSize,
      required this.threshold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Choose font size based on text length
    double fontSize = text.length > threshold ? reducedFontSize : baseFontSize;

    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.blue,
            fontSize: fontSize,
          ),
    );
  }
}
