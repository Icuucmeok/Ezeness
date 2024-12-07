import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/presentation/screens/profile/profile/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/cubit/follow_user/follow_user_cubit.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({
    Key? key,
    required this.user,
    this.isSelected = false,
    this.onTapRemove,
    this.withFollowButton = false,
  }) : super(key: key);

  final User user;
  final bool isSelected;
  final VoidCallback? onTapRemove;
  final bool withFollowButton;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late FollowUserCubit _followUserCubit;

  @override
  void initState() {
    _followUserCubit = context.read<FollowUserCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(ProfileScreen.routName,
              arguments: {"isOther": true, "user": widget.user}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: widget.isSelected
                          ? AppColors.primaryColor
                          : AppColors.darkGrey,
                      // : Theme.of(context).primaryColor.withOpacity(0.2),
                      width: 1.w),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.user.image.toString()),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                  width: 160,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.user.name ?? "",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    letterSpacing: 0.2,
                                    height: 1.2,
                                    fontSize: 13.0,
                                  ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          if (widget.user.proUsername != null)
                            Icon(Icons.verified,
                                size: 15.dg, color: Colors.lightBlue),
                        ],
                      ),
                      Text(
                        "@" + widget.user.getUserName()!,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              letterSpacing: 0.2,
                              height: 1.2,
                              fontSize: 13.0,
                              color: AppColors.greyDark,
                            ),
                      ),
                      if (widget.user.store != null) ...{
                        Text(
                          S.current.businessAccount,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    letterSpacing: 0.2,
                                    height: 1.2,
                                    fontSize: 12.0,
                                    color: AppColors.greyDark,
                                  ),
                        ),
                      },
                      if (widget.user.distance != null) ...{
                        Text(
                          "${widget.user.distance?.ceil()} ${S.current.km.toUpperCase()}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    letterSpacing: 0.2,
                                    height: 1.2,
                                    fontSize: 12.0,
                                    color: AppColors.greyDark,
                                  ),
                        ),
                      },
                      if (widget.withFollowButton) ...{
                        const SizedBox(height: 6),
                        BlocConsumer<FollowUserCubit, FollowUserState>(
                            bloc: _followUserCubit,
                            listener: (context, state) {
                              if (state is FollowUserDone) {
                                if (widget.user.id.toString() == state.response)
                                  widget.user.isFollowing =
                                      !widget.user.isFollowing;
                              }
                            },
                            builder: (context, state) {
                              return InkWell(
                                onTap: () {
                                  _followUserCubit
                                      .followUnFollowUser(widget.user.id!);
                                },
                                child: Container(
                                  width: 120.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.0, vertical: 1.5.h),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    border: Border.all(
                                        color: Colors.blue, width: 1.w),
                                  ),
                                  child: Text(
                                    widget.user.getFollowingStatus(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: widget.user
                                              .getFollowingStatusColor(),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                        ),
                                  ),
                                ),
                              );
                            }),
                      },
                    ],
                  )),
            ],
          ),
        ),
        if (widget.onTapRemove != null)
          IconButton(
            onPressed: widget.onTapRemove,
            icon: Icon(Icons.delete, color: Colors.red),
          ),
      ],
    );
  }
}
