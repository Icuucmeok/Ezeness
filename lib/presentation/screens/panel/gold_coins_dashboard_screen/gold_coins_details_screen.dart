import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/widgets/common/column_builder.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoldCoinsDetailsScreen extends StatefulWidget {
  static const String routName = 'gold_coins_details';

  const GoldCoinsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<GoldCoinsDetailsScreen> createState() => _GoldCoinsDetailsScreenState();
}

class _GoldCoinsDetailsScreenState extends State<GoldCoinsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.details),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                S.current
                    .eachLiftUpCoinsIsEqualTo(AppData.liftUpCoinRate),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 13.sp,
                    ),
              ),
            ),

          SizedBox(height: size.height * .02),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              S.current.howToMakeLiftUpCoins,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 14.sp,
                  ),
            ),
          ),

          SizedBox(height: size.height * .035),

          if (AppData.liftUps != null)
            ColumnBuilder(
              itemBuilder: (context, index) => _buildItem(context,
                  title: AppData.liftUps?[index].content ??
                      AppData.liftUps?[index].name ??
                      "",
                  equalTo: AppData.liftUps?[index].value ?? ""),
              itemCount: AppData.liftUps?.length ?? 0,
            )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context,
      {required String title, required String equalTo}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16.sp),
        ),
        Text(
          "${equalTo} ${S.current.goldCoins}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.greyDark,
                fontSize: 15.sp,
              ),
        ),
        SizedBox(height: 5),
        Divider(),
      ],
    );
  }
}
