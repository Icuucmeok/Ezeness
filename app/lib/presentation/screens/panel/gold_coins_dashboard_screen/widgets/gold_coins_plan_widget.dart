import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoldCoinsPlanWidget extends StatelessWidget {
  const GoldCoinsPlanWidget({
    Key? key,
    required this.title,
    required this.totalCount,
    required this.goldCoinCount,
  }) : super(key: key);
  final String title;
  final num totalCount;
  final num goldCoinCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 15.sp)),
            ),
            Expanded(
              child: _buildBorderLabel(
                context,
                label: S.current.total,
                count: totalCount,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildBorderLabel(
                context,
                label: S.current.goldCoins,
                count: totalCount,
                color: AppColors.gold,
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        Divider(),
      ],
    );
  }

  Widget _buildBorderLabel(BuildContext context,
      {required String label, required num count, Color? color}) {
    return Column(
      children: [
        Text(label,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(color: color)),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: color ?? AppColors.darkGrey),
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Center(
            child: Text(count.toString(),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: color)),
          ),
        )
      ],
    );
  }
}
