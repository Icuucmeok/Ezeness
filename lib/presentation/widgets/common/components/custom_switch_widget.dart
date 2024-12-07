import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';


class CustomAnimatedSwitchWidget extends StatelessWidget {
  final bool isActive;
  final List<Widget> children;
  final Color colorSwitched;
  const CustomAnimatedSwitchWidget(
      {Key? key,
      required this.isActive,
      required this.children,
      required this.colorSwitched})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
      width: size.width * (isActive ? .95 : .8),
      padding: Helpers.paddingInContainer(context),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: isActive ? colorSwitched : AppColors.secondary,
          borderRadius: BorderRadius.circular(.04 * size.width)),
      child: Row(
        children: children,
      ),
    );
  }
}
