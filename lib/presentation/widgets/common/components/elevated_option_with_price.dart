import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

import 'common_text_widgets.dart';
import 'elevated_container.dart';

class ElevatedOptionWithPriceWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String trailTitle;
  final int index;
  final int selectedPlan;
  final void Function(int?)? onChanged;
  final Widget icon;
  final Widget? titleChild;
  const ElevatedOptionWithPriceWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.trailTitle,
    required this.index,
    required this.onChanged,
    required this.selectedPlan,
    required this.icon,
    this.titleChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * .15,
      child: Stack(
        children: [
          Row(
            // mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  // height: 117,
                  // width: size.width * .4,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: AppColors.shadowColor,
                        offset: Offset(
                          -4,
                          4,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(size.width * .08),
                  ),
                  child: Align(
                      alignment: AlignmentDirectional(0, .7),
                      child: MediumText14(
                        subTitle,
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  // color: Colors.white,
                  child: Align(
                    alignment: AlignmentDirectional(.75, .75),
                    child: MediumText14(trailTitle),
                  ),
                ),
              ),
            ],
          ),
          SimpleElevatedContainer(
            color: AppColors.grey,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RadioMenuButton(
                  value: index,
                  groupValue: selectedPlan,
                  style: ButtonStyle(
                    iconColor: WidgetStateProperty.all(AppColors.blackColor),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  onChanged: onChanged,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LightText14(
                          title,
                          color: AppColors.blackColor,
                        ),
                        if (titleChild != null) titleChild!,
                      ],
                    ),
                  ),
                ),
                icon,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
