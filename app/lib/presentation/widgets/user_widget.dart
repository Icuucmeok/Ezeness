import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user/user.dart';
import '../../logic/cubit/follow_user/follow_user_cubit.dart';
import '../router/app_router.dart';
import '../screens/profile/profile/profile_screen.dart';
import 'circle_avatar_icon_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserWidget extends StatelessWidget {
  final User user;
  final FollowUserCubit followUserCubit;
  const UserWidget(this.user, this.followUserCubit);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
      child: GestureDetector(
        onTap: () {
          Navigator.of(AppRouter.mainContext).pushNamed(ProfileScreen.routName,
              arguments: {"isOther": true, "user": user});
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: CircleAvatarIconWidget(
                userProfileImage: user.image.toString(),
                size: 40,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                "${user.name}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
              ),
            ),
            BlocConsumer<FollowUserCubit, FollowUserState>(
                bloc: followUserCubit,
                listener: (context, state) {
                  if (state is FollowUserDone) {
                    if (user.id.toString() == state.response)
                      user.isFollowing = !user.isFollowing;
                  }
                },
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      followUserCubit.followUnFollowUser(user.id!);
                    },
                    child: Container(
                      width: 90.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 2.0.h),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        border: Border.all(
                            color: user.getFollowingStatusColor() ??
                                Colors.grey.shade800,
                            width: 1.w),
                      ),
                      child: Text(
                        user.getFollowingStatus(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: user.getFollowingStatusColor(),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
