import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WalletBalanceWidget extends StatelessWidget {
  const WalletBalanceWidget({Key? key, required this.walletBalance})
      : super(key: key);

  final String walletBalance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkColor
                : AppColors.grey,
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 22.5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  S.current.walletBalance,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 16,
                      ),
                ),
              ),
              Text(
                Helpers.numberFormatter(double.tryParse(walletBalance) ?? 0),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 15,
                    ),
              ),
              SizedBox(width: 5),
              Text(
                S.current.aed,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 15,
                    ),
              ),
            ],
          ),
        ),
        Positioned.directional(
          top: -15,
          start: 10,
          textDirection: Directionality.of(context),
          child: SizedBox(
            width: 40,
            height: 40,
            child: SvgPicture.asset(
              Assets.cardIcon,
              colorFilter:
                  ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
            ),
          ),
        )
      ],
    );
  }
}
