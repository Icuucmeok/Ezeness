import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/widgets/common/components/lift_up_gold_coins_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoldCoinsDashboardScreen extends StatelessWidget {
  const GoldCoinsDashboardScreen({Key? key}) : super(key: key);
  static const String routName = 'gold_icons_dashboard';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(S.current.goldCoins)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Headers widget
          Container(
            width: double.infinity,
            height: size.height * .15,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.dg, vertical: 12.dg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.goldCoinsDashboard,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 2.dg),
                Text(
                  S.current.trackYourGoldCoinsHere,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * .02),

          // Gold coins widget
          LiftUpGoldCoinsWidget(
            withConvert: true,
          ),
          SizedBox(height: size.height * .02),

          // Details widget
          // LiftUpDetails(),
          // SizedBox(height: size.height * .05),
        ],
      ),
    );
  }
}
