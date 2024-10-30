import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PanelSettingContainerWidget extends StatelessWidget {
  final IconData headerIcon;
  final Color? iconColor;
  final String headerTitle;
  final Widget widget;
  final Widget? headerWidget;

  const PanelSettingContainerWidget({
    Key? key,
    required this.headerIcon,
    this.iconColor,
    required this.headerTitle,
    required this.headerWidget,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///HEADER ICON CONTAINER
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0.h),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(0.0),
                bottom: Radius.circular(15.0),
              ),
              border: Border.all(
                color: Colors.transparent,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  blurRadius: 3.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 5.0.h),
                  child: Row(
                    children: [
                      Icon(
                        headerIcon,
                        size: 26.sp,
                        color: iconColor ??
                            Theme.of(context).primaryColorDark.withOpacity(0.8),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0.w.w),
                        child: Text(
                          headerTitle,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.8),
                                  ),
                        ),
                      ),
                      Container(
                        child: headerWidget,
                      ),
                    ],
                  ),
                ),

                /// MAIN BODY CONTAINER
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w.w, vertical: 5.0.h),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(0.0),
                        bottom: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                    ),
                    child: widget),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
