import 'package:ezeness/presentation/widgets/common/components/elevated_option_with_price.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StoreUpgradePlanWidget extends StatefulWidget {
  const StoreUpgradePlanWidget({
    super.key,
    required this.title,
    required this.onSelect,
    required this.titleChild,
    required this.subTitle,
    required this.trailTitle,
    required this.index,
    required this.selectedIndex,
  });

  final String title;
  final VoidCallback onSelect;

  final String titleChild;
  final String subTitle;
  final String trailTitle;
  final int index;
  final int selectedIndex;

  @override
  State<StoreUpgradePlanWidget> createState() => _StoreUpgradePlanWidgetState();
}

class _StoreUpgradePlanWidgetState extends State<StoreUpgradePlanWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * .04),
      child: ElevatedOptionWithPriceWidget(
        title: widget.title,
        subTitle: widget.subTitle,
        titleChild: Text(widget.titleChild),
        trailTitle: widget.trailTitle,
        index: widget.index,
        selectedPlan: widget.selectedIndex,
        onChanged: (value) => widget.onSelect(),
        icon: SvgPicture.asset(
          Assets.assetsIconsStoreSolid,
          colorFilter:
              ColorFilter.mode(AppColors.greyTextColor, BlendMode.srcIn),
          width: size.width * .07,
          height: size.height * .035,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
