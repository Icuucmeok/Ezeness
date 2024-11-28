import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../generated/l10n.dart';
import '../widgets/common/common.dart';

class AppSnackBar {
  final String message;
  final BuildContext context;
  final VoidCallback? onTap;
  final Duration duration;
  AppSnackBar({
    this.message = '',
    required this.context,
    this.onTap,
    this.duration = const Duration(seconds: 3),
  });

  void showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.green,
        duration: duration,
        content: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  void showItemAddToCartSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        dismissDirection: DismissDirection.horizontal,
        duration: duration,
        content: Row(
          children: [
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
            ),
            SizedBox(width: 6.w),
            InkWell(
              onTap: onTap,
              child: Text(
                S.current.viewCart,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLocationServiceDisabledSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.pleaseEnableLocationService,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.whiteColor
                          : Colors.black,
                    ),
              ),
              SizedBox(height: 4.h),
              Text(
                S.current.locationServiceText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color:
                          Theme.of(context).primaryColorDark.withOpacity(0.7),
                      fontSize: 18.sp,
                    ),
              ),
              SizedBox(height: 18.h),
              CustomElevatedButton(
                onPressed: () => Geolocator.openLocationSettings(),
                withBorderRadius: true,
                backgroundColor: AppColors.primaryColor,
                child: Text(
                  S.current.enable,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLocationPermanentlyDeniedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          height: 200.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.locationPermanentlyDenied,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.whiteColor
                          : Colors.black,
                    ),
              ),
              Spacer(),
              Text(
                S.current.locationPermanentlyDeniedText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color:
                          Theme.of(context).primaryColorDark.withOpacity(0.7),
                      fontSize: 18.sp,
                    ),
              ),
              SizedBox(height: 8.h),
              CustomElevatedButton(
                onPressed: () => Geolocator.openAppSettings(),
                withBorderRadius: true,
                backgroundColor: AppColors.primaryColor,
                child: Text(
                  S.current.enable,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
