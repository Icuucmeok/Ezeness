import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.12),
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(8).r,
                    bottomStart: Radius.circular(8).r),
              ),
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.02),
              height: 45.h,
              child: Icon(
                IconlyLight.arrow_right,
                color: AppColors.darkGrey,
                size: 30.r,
              ),
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }
}
