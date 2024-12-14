import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

import 'common_text_widgets.dart';
import 'elevated_container.dart';

class ElevatedCardWithArrowWidget extends StatelessWidget {
  final Widget icon;
  final String title;
  final bool withArrow;
  final VoidCallback? onTap;
  const ElevatedCardWithArrowWidget({
    Key? key,
    this.onTap,
    required this.icon,
    required this.title,
    this.withArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: onTap,
      child: SimpleElevatedContainer(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkColor
            : null,
        // padding: EdgeInsets.symmetric(horizontal: 8),
        // height: size.height * .1,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(38),
        //   boxShadow: [Helpers.boxShadow(context)],
        // ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: size.width * .14,
                  height: size.height * .14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondary,
                      width: size.width * .006,
                    ),
                  ),
                ),
                icon,
              ],
            ),
            SizedBox(
              width: size.width * .05,
            ),
            MediumText14(title),
            Spacer(),
            if (withArrow)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.darkGrey,
                  size: size.width * .06,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
