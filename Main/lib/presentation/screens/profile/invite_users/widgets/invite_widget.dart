// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ezeness/data/models/invite_user/invite_user.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../view_invite_screen.dart';

class InviteWidget extends StatelessWidget {
  const InviteWidget({
    Key? key,
    required this.inviteUser,
    required this.onDelete,
    required this.isSpecial,
  }) : super(key: key);

  final InviteUser inviteUser;
  final void Function(int id) onDelete;
  final bool isSpecial;

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
              onTap: () {
                if (inviteUser.isUsed == true) return;
                onDelete(inviteUser.id!);
              },
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  color: inviteUser.isUsed == true
                      ? !isSpecial
                          ? AppColors.primaryColor
                          : AppColors.gold
                      : AppColors.greyCard,
                  borderRadius: BorderRadiusDirectional.horizontal(
                    start: Radius.circular(10.r),
                  ),
                ),
                child: Center(
                  child: inviteUser.isUsed == true
                      ? null
                      : Icon(
                          IconlyLight.delete,
                          color: AppColors.darkGrey,
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
                  Text(
                    "${S.current.invitedName} ${inviteUser.name}",
                    style: Theme.of(context).textTheme.displayLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (inviteUser.email != null &&
                      inviteUser.email.toString() != "null")
                    Text(inviteUser.email ?? "",
                        style: Theme.of(context).textTheme.bodyLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(inviteUser.phoneNumber ?? "",
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(inviteUser.createdAt?.toString() ?? "",
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
