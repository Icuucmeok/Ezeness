import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../data/models/user/user.dart';
import '../../generated/l10n.dart';

class ProfileGridView extends StatelessWidget {
  final List<User> profileList;
  final bool isMine;
  final bool isScroll;
  final bool withFollowButton;
  const ProfileGridView(this.profileList,
      {this.isMine = false,
      this.isScroll = false,
      this.withFollowButton = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return profileList.isEmpty
        ? EmptyCard(withIcon: false, massage: S.current.no_items_to_display)
        : ResponsiveGridList(
            scroll: isScroll,
            shrinkWrap: true,
            desiredItemWidth: 110.w,
            minSpacing: 1,
            children: profileList
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ProfileWidget(
                          user: e, withFollowButton: withFollowButton),
                    ))
                .toList());
  }
}
