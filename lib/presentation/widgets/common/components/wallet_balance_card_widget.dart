import 'package:ezeness/presentation/widgets/common/components/money_value_text_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

import '../../../utils/helpers.dart';
import 'common_text_widgets.dart';

class SettingCard extends StatelessWidget {
  final IconData leadingIcon;
  final String? count;
  final String title;
  final String subTitle;
  final bool showMoneyValue;
  final VoidCallback? onTap;
  const SettingCard({
    Key? key,
    this.count,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    required this.subTitle,
    this.showMoneyValue = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: size.width * .45,
          height: size.aspectRatio > .6 ? size.height * .2 : size.height * .17,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height:
                    size.aspectRatio > .6 ? size.height * .16 : size.height * .14,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * .03, vertical: size.width * .05),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  boxShadow: [Helpers.boxShadow(context)],
                  borderRadius: BorderRadius.all(
                    Radius.circular(.04 * size.width),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RegularText14(
                          title,
                          color: AppColors.whiteColor,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.whiteColor,
                          size: .06 * size.width,
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .03,
                          vertical:
                              size.width * (size.aspectRatio > .6 ? .01 : .02)),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(.02 * size.width),
                        ),
                      ),
                      child: showMoneyValue
                          ? MoneyTextWidget(
                              subTitle,
                              textColor: Colors.white,
                            )
                          : MediumText14(
                              subTitle,
                              color: AppColors.whiteColor,
                            ),
                    )
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
