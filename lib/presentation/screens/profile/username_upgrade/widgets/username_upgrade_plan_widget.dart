import 'package:ezeness/data/models/upgrade_username_plan/upgrade_username_plan.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/utils/date_handler.dart';
import 'package:ezeness/presentation/widgets/common/components/elevated_option_with_price.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsernameUpgradePlanWidget extends StatefulWidget {
  const UsernameUpgradePlanWidget({
    super.key,
    required this.plan,
    required this.index,
    required this.selectedPlanIndex,
    required this.onSelect,
  });

  final UpgradeUsernamePlan plan;

  final void Function(UpgradeUsernamePlan plan) onSelect;
  final int index;
  final int selectedPlanIndex;

  @override
  State<UsernameUpgradePlanWidget> createState() =>
      _UsernameUpgradePlanWidgetState();
}

class _UsernameUpgradePlanWidgetState extends State<UsernameUpgradePlanWidget> {
  late User user;
  late String currency;

  @override
  void initState() {
    user = context.read<AppConfigCubit>().getUser();
    currency = context.read<SessionControllerCubit>().getCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * .04),
      child: ElevatedOptionWithPriceWidget(
        title: widget.plan.name.toString(),
        subTitle:
            "${widget.plan.period?.toString() ?? ""} ${S.current.monthLive}",
        titleChild: Text((user.usernamePlan != null &&
                widget.plan.id == user.usernamePlan!.planId)
            ? S.current.validUntil +
                ": " +
                DateHandler(user.usernamePlan!.endDate.toString()).getDate()
            : ""),
        trailTitle:
            " $currency ${widget.plan.cost == 0 ? S.current.free : widget.plan.cost.toString()}",
        index: widget.index,
        selectedPlan: widget.selectedPlanIndex,
        onChanged: (value) => widget.onSelect(widget.plan),
        icon: Icon(
          Icons.verified,
          size: 35,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
