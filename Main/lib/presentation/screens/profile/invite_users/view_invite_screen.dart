import 'package:ezeness/data/models/invite_user/invite_user.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/utils/app_toast.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import '../../../widgets/common/common.dart';

class ViewInviteScreen extends StatelessWidget {
  static const String routName = 'view_invite';

  const ViewInviteScreen({Key? key, required this.inviteUser})
      : super(key: key);

  final InviteUser inviteUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          children: [
            // Back Button
            Align(
              alignment: AlignmentDirectional.topStart,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),

            // date
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                "${S.current.codeGeneratedOn} ${inviteUser.createdAt}",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),

            // Card

            Container(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S.current.acceptInvitation,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    S.current.yourCodeIs,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    inviteUser.code?.toUpperCase() ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 20),
                  // Text(
                  //   S.current.clickLinkToJoinApp,
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .displayLarge
                  //       ?.copyWith(fontSize: 15),
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: 8),
                  Text(
                    Constants.appLinkUrl+inviteUser.code.toString(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 17, color: AppColors.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                        context,
                        S.current.share,
                        CupertinoIcons.paperplane,
                        ()async {
                          await Share.share(Constants.appLinkUrl+inviteUser.code.toString());
                        },
                      ),
                      SizedBox(width: 20),
                      _buildButton(
                        context,
                        S.current.copy,
                        Icons.copy,
                        () {
                          Clipboard.setData(ClipboardData(
                              text: inviteUser.code?.toUpperCase() ?? ""));
                          AppToast(message: S.current.copiedToClipboard).show();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),

            // Button

            CustomElevatedButton(
              borderRadius: 100.r,
              withBorderRadius: true,
              margin: EdgeInsets.only(top: 30, bottom: 30),
              backgroundColor: AppColors.primaryColor,
              child: Text(S.current.done,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 15.sp, color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String title,
    IconData? icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.darkGrey),
                shape: BoxShape.circle),
            padding: EdgeInsets.all(10),
            child: Icon(icon),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
