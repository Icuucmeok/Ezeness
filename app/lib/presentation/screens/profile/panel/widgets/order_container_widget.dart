import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderContainerWidget extends StatelessWidget {
  final String title;
  final String amount;

  final Color? textColor;

  OrderContainerWidget({
    required this.title,
    required this.amount,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: textColor,
                fontSize: 12.sp)),
        10.verticalSpace,
        Container(
          width: 71.w,
          height: 24.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border:
                Border.all(color: textColor ?? Color(0xffC6C6C6), width: 1.2.r),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Text(amount,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    fontSize: 12.sp)),
          ),
        ),
      ],
    );
  }
}
