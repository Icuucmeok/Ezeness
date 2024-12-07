import 'package:flutter/material.dart';

class CircleAvatarIconWidget extends StatelessWidget {
  final Color? userStatusTagColor;
  final Color? userGenderColor;
  final Color? userOnlineStatusColor;
  final Color? userStoryStatus;
  final String userProfileImage;
  final double? size;
  final Widget? widget;

  const CircleAvatarIconWidget(
      {Key? key,
      this.userStatusTagColor,
      this.userGenderColor,
      this.userOnlineStatusColor,
      this.userStoryStatus,
      required this.userProfileImage,
      this.widget,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      width: size ?? 50,
      height: size ?? 50,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            userStatusTagColor ?? Colors.grey,
            userGenderColor ?? Colors.blue,
            userOnlineStatusColor ?? Colors.lightGreen,
          ],
        ),
      ),
      child: widget ??
          Container(
            padding: EdgeInsets.all(1.0),
            // width: 60.w,
            // height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: userStoryStatus ?? Colors.purple.shade200,
              // borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              // width: 45,
              // height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(userProfileImage),
                ),
              ),
            ),
          ),
    );
  }
}
