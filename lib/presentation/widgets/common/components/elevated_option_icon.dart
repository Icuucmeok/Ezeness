import 'package:ezeness/presentation/widgets/common/components/elevated_container.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

class ElevatedOptionIconWidget extends StatelessWidget {
  final String title;
  final Widget icon;
  const ElevatedOptionIconWidget({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SimpleElevatedContainer(
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
          const SizedBox(width: 8),
          Icon(Icons.radio_button_checked, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.whiteColor
                      : AppColors.darkGrey,
                  fontSize: 15,
                ),
          ),
          SizedBox(
            width: size.width * .05,
          ),
          Spacer(),
          icon
        ],
      ),
    );
  }
}
