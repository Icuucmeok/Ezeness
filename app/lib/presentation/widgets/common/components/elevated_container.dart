import 'package:flutter/material.dart';

import '../../../utils/helpers.dart';

class SimpleElevatedContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  const SimpleElevatedContainer({Key? key, this.color, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: size.height * .085,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        boxShadow: [Helpers.boxShadow(context)],
        borderRadius: BorderRadius.circular(size.width * .08),
      ),
      child: child,
    );
  }
}
