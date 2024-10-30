import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ButtonErrorWidget extends StatelessWidget {
  final String? message;
  final String? iconPath;
  final TextStyle? textStyle;
  final TextStyle? buttonTextStyle;
  final VoidCallback? onPressed;
  final bool? enableButton;

  const ButtonErrorWidget({
    Key? key,
    this.message,
    this.iconPath,
    this.textStyle,
    required this.onPressed,
    this.buttonTextStyle,
    this.enableButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // SvgPicture.asset(
          //   iconPath ?? Assets.assetsIconsError,
          //   fit: BoxFit.cover,
          //   width: 150.w,
          //   // color:  AppColors.primaryColor,
          // ),
          // SizedBox(
          //   height: 15.h,
          // ),
          Text(
            message ??
                (Helpers.isRTL(context)
                    ? 'حدث خطأ ما ، يرجى إعادة المحاولة لاحقاً'
                    : 'An error occurred, please try again later'),
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          if (enableButton!)
            TextButton(
              onPressed: onPressed ?? () {},
              child: Text(
                Helpers.isRTL(context) ? 'إعادة المحاولة' : "Try Again",
              ),
            ),
        ],
      ),
    );
  }
}

class LabelErrorWidget extends StatelessWidget {
  final String? message;
  final String? iconPath;
  final TextStyle? textStyle;

  const LabelErrorWidget(
      {this.message, this.iconPath, this.textStyle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            iconPath ?? Assets.assetsIconsError,
            fit: BoxFit.cover,
            width: 150.w,
          ),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              message ??
                  (Helpers.isRTL(context)
                      ? 'حدث خطأ ما ، يرجى إعادة المحاولة لاحقاً'
                      : 'An error occurred, please try again later'),
              style: textStyle ??
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryColor,
                      ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
