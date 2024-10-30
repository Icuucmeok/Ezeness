import 'package:ezeness/data/models/invite_user/invite_user.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view_invite_screen.dart';

class ProInviteWidget extends StatelessWidget {
  const ProInviteWidget({
    Key? key,
    required this.inviteUser,
    required this.onToggle,
  }) : super(key: key);

  final InviteUser inviteUser;
  final void Function(InviteUser invite) onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        ViewInviteScreen.routName,
        arguments: {"invite": inviteUser},
      ),
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkColor
              : AppColors.greyCard,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => onToggle(inviteUser),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  color: inviteUser.status == 1
                      ? AppColors.primaryColor
                      : AppColors.greyCard,
                  borderRadius: BorderRadiusDirectional.horizontal(
                    start: Radius.circular(10.r),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.not_interested_rounded,
                    color: inviteUser.status == 1
                        ? AppColors.whiteColor
                        : AppColors.darkGrey,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        inviteUser.code?.toUpperCase() ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Icon(Icons.adaptive.arrow_forward)
                    ],
                  ),
                  Divider(color: AppColors.darkGrey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.current.totalJoined,
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(inviteUser.totalJoined?.toString() ?? "", // TODO:
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  Text(inviteUser.title ?? "",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14.5.sp)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.current.generatedDate,
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(inviteUser.createdAt?.toString() ?? "", // TODO:
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
