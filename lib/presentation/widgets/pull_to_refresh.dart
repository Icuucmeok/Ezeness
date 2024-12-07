import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class PullToRefresh extends StatelessWidget {
  final Widget child;
  final VoidCallback onRefresh;
  const PullToRefresh({required this.child,required this.onRefresh,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller:RefreshController(initialRefresh: false),
      enablePullDown: true,
      header: MaterialClassicHeader(backgroundColor: AppColors.darkColor,color: AppColors.grey),
      onRefresh:()async=>onRefresh(),
      child:child,
    );
  }
}
