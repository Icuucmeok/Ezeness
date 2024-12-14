import 'package:ezeness/data/models/notification/notification.dart';
import 'package:ezeness/logic/cubit/seen_notification/seen_notification_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/profile/profile/profile_screen.dart';
import 'package:ezeness/presentation/services/fcm_service.dart';
import 'package:ezeness/presentation/widgets/circle_avatar_icon_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationWidget extends StatefulWidget {
  const NotificationWidget(
      {super.key,
      required this.notification,
      this.onSeenTap,
      this.onSeenSuccess,
      required this.withSeenListener});

  final NotificationModel notification;
  final void Function(int id)? onSeenSuccess;
  final void Function(int id)? onSeenTap;
  final bool withSeenListener;

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late SeenNotificationCubit _seenNotificationCubit;
  @override
  void initState() {
    _seenNotificationCubit = context.read<SeenNotificationCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final component = GestureDetector(
      onTap: () {
        if (!widget.notification.isSeen)
          widget.onSeenTap?.call(widget.notification.id ?? -1);
        if (widget.notification.dataId != null)
          FcmService.notificationNavigator(
              id: widget.notification.dataId,
              typeCode: widget.notification.dataType,
              isFromNotificationScreen: true);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.notification.notificationUser != null
                    ? GestureDetector(
                        child: CircleAvatarIconWidget(
                          userProfileImage: widget
                              .notification.notificationUser!.image
                              .toString(),
                          size: 50,
                        ),
                        onTap: () {
                          Navigator.of(AppRouter.mainContext)
                              .pushNamed(ProfileScreen.routName, arguments: {
                            "isOther": true,
                            "user": widget.notification.notificationUser
                          });
                        },
                      )
                    : CircleAvatarIconWidget(
                        userProfileImage: '',
                        size: 50,
                        widget: Icon(Icons.notifications_active,
                            color: AppColors.whiteColor),
                      ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.notification.title.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: AppColors.darkGrey,
                                      fontSize: 14.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          // Icon(CupertinoIcons.checkmark_seal_fill,
                          //     color: Colors.blue, size: 16.w),
                          Padding(
                            padding: EdgeInsetsDirectional.only(end: 2.w),
                            child: Text(
                              "${timeago.format(DateTime.parse(widget.notification.createdAt!))}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.darkGrey,
                                    fontSize: 11,
                                  ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.notification.body.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300),
                            ),
                          ),
                          if (!widget.notification.isSeen)
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: AppColors.primaryColor,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                7.horizontalSpace,
                if (widget.notification.postImage != null)
                  Container(
                    width: 42.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.greyDark.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3).r,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.notification.postImage.toString(),
                        ),
                      ),
                    ),
                  )
              ],
            ),
            10.verticalSpace,
          ],
        ),
      ),
    );

    return widget.withSeenListener
        ? BlocConsumer<SeenNotificationCubit, SeenNotificationState>(
            bloc: _seenNotificationCubit,
            listener: (context, state) {
              if (state is SeenNotificationDone) {
                if ((int.tryParse(state.response) ?? -1) !=
                    widget.notification.id) {
                  return;
                }
                widget.onSeenSuccess?.call(int.tryParse(state.response) ?? -1);
              }
            },
            builder: (context, state) {
              return component;
            },
          )
        : component;
  }
}
