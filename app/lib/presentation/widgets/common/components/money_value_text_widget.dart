import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

import '../../../utils/helpers.dart';

class MoneyTextWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  const MoneyTextWidget(this.text, {Key? key, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      text: TextSpan(
        children: [
          TextSpan(
              text: 'AED ',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textColor ?? AppColors.blackText,
                    fontSize: size.width * .025,
                  )),
          TextSpan(
              text: Helpers.numberFormatter(double.tryParse(text) ?? 0),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: textColor ?? AppColors.blackText,
                    fontSize: size.width * .045,
                  )),
        ],
      ),
    );
  }
}
