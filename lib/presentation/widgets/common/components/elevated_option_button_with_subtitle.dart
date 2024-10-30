import 'package:ezeness/presentation/widgets/common/components/elevated_option_icon.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

class ElevatedOptionWithSubtitleWidget extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget icon;

  const ElevatedOptionWithSubtitleWidget(
      {Key? key, required this.child, required this.title, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      margin: EdgeInsets.all(8),
      height: size.height * .15,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.shadowColor.withOpacity(.4),
              borderRadius: BorderRadius.circular(size.width * .08),
            ),
            child: Align(alignment: AlignmentDirectional(0, .7), child: child),
          ),
          ElevatedOptionIconWidget(
            title: title,
            icon: icon,
          )
        ],
      ),
    );
  }
}
