import 'package:ezeness/presentation/widgets/circle_avatar_icon_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleAvatarStoryWidget extends StatelessWidget {
  final String userProfileImage;
  final String username;

  const CircleAvatarStoryWidget(
      {Key? key, required this.userProfileImage, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125.w,
      child: Column(
        children: [
          CircleAvatarIconWidget(
            userProfileImage: "https://picsum.photos/id/48/200/300",
            size: 100,
          ),
          10.verticalSpace,
          Container(
            child: Row(
              children: [
                Text(
                  username,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis),
                ),
                2.horizontalSpace,
                Icon(
                  CupertinoIcons.checkmark_seal_fill,
                  color: Colors.blue,
                  size: 14.r,
                ),
              ],
            ),
          ),
          20.horizontalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text('3.5 KM',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w100, fontSize: 12)),
          ),
          Divider(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.whiteColor
                : AppColors.blackColor,
            thickness: 0.5.r,
          )
        ],
      ),
    );
  }
}
