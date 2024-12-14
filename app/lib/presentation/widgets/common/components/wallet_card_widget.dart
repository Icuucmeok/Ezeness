import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../../data/models/user/user.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import 'common_text_widgets.dart';
import 'money_value_text_widget.dart';

class WalletCardWidget extends StatelessWidget {
  final Color? iconColor;
  const WalletCardWidget({Key? key, this.iconColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    User user = context.read<AppConfigCubit>().getUser();
    final size = MediaQuery.sizeOf(context);
    return Container(
      height: size.aspectRatio < .6 ? size.height * .08 : size.height * .11,
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            IconlyBold.wallet,
            color: iconColor ?? AppColors.secondary,
            size: size.width * .07,
          ),
          SizedBox(
            height: size.height * .01,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText14(
                S.current.wallet + " " + S.current.balance,
                color: iconColor,
              ),
              MoneyTextWidget(
                "${user.wallet ?? ''}",
                textColor: iconColor,
              )
            ],
          ),
        ],
      ),
    );
  }
}
