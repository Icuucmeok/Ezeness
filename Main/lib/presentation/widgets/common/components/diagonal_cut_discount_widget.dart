import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

class DiagonalCutDiscount extends StatelessWidget {
  final double percentage;

  const DiagonalCutDiscount({Key? key, required this.percentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          painter: DiagonalCutPainter(),
          child: Container(
            alignment: Alignment.topCenter,
            height: 12,
            width: 40,
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.darkPrimary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 8),
          child: Text('${percentage.toStringAsFixed(0)} %',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.whiteColor, fontSize: 13)),
        ),
      ],
    );
  }
}

class DiagonalCutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkPrimary
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 12)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height + 10)
      ..lineTo(0, size.height + 10)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
