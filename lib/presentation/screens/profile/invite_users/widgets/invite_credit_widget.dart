import 'package:ezeness/data/models/invite_credit/invite_credit.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum InviteType { stander, pro, special }

extension InviteTypeExtension on InviteType {
  bool get isStander => this == InviteType.stander;
  bool get isPro => this == InviteType.pro;
  bool get isSpecial => this == InviteType.special;
}

class InviteCreditWidget extends StatelessWidget {
  const InviteCreditWidget({
    Key? key,
    required this.inviteCredit,
    required this.type,
    required this.onTap,
  }) : super(key: key);

  final InviteCredit? inviteCredit;
  final InviteType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: type.isSpecial ? AppColors.gold : AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [Helpers.boxShadow(context)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type.isSpecial
                        ? S.current.specialInvite
                        : type.isPro
                            ? S.current.proInvite
                            : S.current.standardInvite,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                  ),
                  Text(
                    "${inviteCredit?.count != null ? inviteCredit?.count : ''}/${inviteCredit?.total != null ? inviteCredit?.total : ''}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        type.isPro ? S.current.totalJoined : S.current.accepted,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.blackColor,
                              fontSize: 15.sp,
                            ),
                      ),
                      Text(
                        inviteCredit?.activeInvitedUser?.toString() ?? "",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.blackColor,
                              fontSize: 15.sp,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        type.isPro
                            ? S.current.codesGenerated
                            : S.current.pending,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.blackColor,
                              fontSize: 15.sp,
                            ),
                      ),
                      Text(
                        type.isPro
                            ? inviteCredit?.count?.toString() ?? ""
                            : inviteCredit?.pending?.toString() ?? "",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.blackColor,
                              fontSize: 15.sp,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
