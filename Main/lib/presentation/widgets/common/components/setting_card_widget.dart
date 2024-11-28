import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

import 'common_text_widgets.dart';

class SettingCardWidget extends StatelessWidget {
  final IconData leadingIcon;
  final IconData? trailIcon;
  final String? count;
  final String title;
  final Color? titleColor;
  final Color? circleColor;
  final IconData? circleIcon;
  final Color? containerColor;
  final VoidCallback? onTap;
  const SettingCardWidget({
    Key? key,
    this.trailIcon,
    this.count,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.circleIcon,
    this.containerColor,
    this.circleColor,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: size.width * .45,
          height: size.height * (size.aspectRatio > .6 ? .15 : .115),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: size.height * (size.aspectRatio > .6 ? .12 : .09),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * .03, vertical: size.width * .05),
                decoration: BoxDecoration(
                  color: containerColor ?? AppColors.darkBlue,
                  boxShadow: [Helpers.boxShadow(context)],
                  borderRadius: BorderRadius.all(
                    Radius.circular(.04 * size.width),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RegularText14(
                      title,
                      color: titleColor ?? AppColors.shadowColor,
                    ),
                    if (trailIcon != null)
                      Icon(
                        trailIcon,
                        color: AppColors.shadowColor,
                        size: .06 * size.width,
                      ),
                    if (count != null)
                      Container(
                        width: .09 * size.width,
                        height: .09 * size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor ??
                                AppColors.shadowColor.withOpacity(.25)),
                        child: MediumText12(
                          count!,
                          color: Colors.white,
                        ),
                      ),
                    if (circleIcon != null)
                      Container(
                          width: size.width * .08,
                          height: size.height * .08,
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.secondary.withOpacity(.75),
                                  width: size.width * .015)),
                          child: Icon(
                            Icons.add,
                            color: AppColors.secondary,
                            size: size.width * .05,
                          )),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(size.width * .015),
                  decoration: BoxDecoration(
                    color: AppColors.shadowColor.withOpacity(.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    leadingIcon,
                    color: AppColors.darkBlue,
                    size: .07 * size.width,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
