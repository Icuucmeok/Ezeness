import 'package:ezeness/presentation/utils/app_dialog.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/models/user/user.dart';
import '../../../generated/l10n.dart';
import '../../../res/app_res.dart';
import 'common.dart';

class ShareUserButton extends StatelessWidget {
  final User user;
  final bool isOtherUser;
  final double? size;
  final Color? color;
  final bool withBorder;
  const ShareUserButton({
    Key? key,
    required this.user,
    this.isOtherUser = true,
    this.size,
    this.color,
    required this.withBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoreIconButton(
      withBorder: withBorder,
      icon: CupertinoIcons.qrcode,
      color: color ?? AppColors.whiteColor,
      value: isOtherUser ? S.current.share : null,
      size: size,
      canGustTap: true,
      onTapIcon: () {
        if (isOtherUser) Navigator.of(context).pop();
        String userLink = Constants.appLinkUrl + "user?${user.id}";
        AppDialog.showShareProfileDialog(
          context: context,
          userLink: userLink,
          user: user,
        );
      },
    );
  }
}
