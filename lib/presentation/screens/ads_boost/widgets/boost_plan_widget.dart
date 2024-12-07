import 'package:ezeness/data/models/boost/plans/boost_plans_model.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/widgets/common/components/elevated_option_with_price.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BoostPlanWidget extends StatelessWidget {
  const BoostPlanWidget({
    required this.plan,
    required this.selectedPlanIndex,
    required this.onSelect,
    required this.index,
    required this.currency,
  });

  final BoostPlansModel plan;
  final int selectedPlanIndex;
  final void Function(BoostPlansModel plan) onSelect;
  final int index;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * .04),
      child: ElevatedOptionWithPriceWidget(
        title: "${plan.name} ${plan.location?.name ?? ""}",
        subTitle: "${plan.period} ${S.current.daysLive}",
        titleChild: plan.availableDate != null
            ? Text(
                "${S.current.bannerAvailableOn} ${plan.availableDate}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.green),
              )
            : null,
        trailTitle: "${currency} ${plan.cost}",
        index: index,
        selectedPlan: selectedPlanIndex,
        onChanged: (value) => onSelect(plan),
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
