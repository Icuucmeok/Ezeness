import 'package:ezeness/res/app_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitleButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  SectionTitleButton({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 20.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey.withOpacity(0.02),
                height: 45.h,
                margin: EdgeInsets.only(right: 5.w),
                child: Container(
                  height: 30.h,
                  width: 30.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400, width: 6.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentShadowColor,
                        offset: Offset(0, 3),
                        blurRadius: 6.r,
                      ),
                    ],
                  ),
                  child: Container(
                    height: 25.h,
                    width: 25.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Icon(
                      CupertinoIcons.add,
                      size: 15.r,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
