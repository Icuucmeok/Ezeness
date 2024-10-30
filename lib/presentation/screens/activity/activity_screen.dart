import 'package:ezeness/data/models/notification/notification.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/notification/notification_cubit.dart';
import 'package:ezeness/logic/cubit/seen_notification/seen_notification_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/screens/panel/notification_by_type_screen.dart';
import 'package:ezeness/presentation/screens/activity/widget/notification_widget.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/pull_to_refresh.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collection/collection.dart';
import 'package:iconly/iconly.dart';

class ActivityScreen extends StatefulWidget {
  static const String routName = 'activity_screen';

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late NotificationCubit _notificationCubit;
  late SeenNotificationCubit _seenNotificationCubit;

  late bool isLoggedIn;

  @override
  void initState() {
    isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    _notificationCubit = context.read<NotificationCubit>();
    _seenNotificationCubit = context.read<SeenNotificationCubit>();
    _notificationCubit.getNotificationsLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return isLoggedIn
        ? Scaffold(
            appBar: AppBar(
              leadingWidth: 250.w,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(IconlyLight.notification, size: 30.r),
                  ),
                  IconButton(
                    onPressed: () {
                      AppModalBottomSheet.showCallNumberBottomSheet(
                          context: context, number: Constants.callPhoneNumber);
                    },
                    icon: Icon(Icons.support_agent_rounded, size: 30.r),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.support_agent_rounded,
                      size: 30.r,
                      color: AppColors.transparent,
                    ),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.support_agent_rounded,
                      size: 30.r,
                      color: AppColors.transparent,
                    ),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.support_agent_rounded,
                      size: 30.r,
                      color: AppColors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            body: BlocBuilder<NotificationCubit, NotificationState>(
                bloc: _notificationCubit,
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const CenteredCircularProgressIndicator();
                  }
                  if (state is NotificationFailure) {
                    return ErrorHandler(exception: state.exception)
                        .buildErrorWidget(
                      context: context,
                      retryCallback: () =>
                          _notificationCubit.getNotificationsLists(),
                    );
                  }
                  if (state is NotificationLoaded) {
                    return PullToRefresh(
                      onRefresh: () {
                        _notificationCubit.getNotificationsLists();
                      },
                      child: ListView(
                        padding: EdgeInsets.all(16.w),
                        children: [
                          // Payment
                          if (state
                              .response.paymentNotifications!.isNotEmpty) ...{
                            ViewAllIconHeader(
                              leadingText: S.current.payments,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              onNavigate: () => Navigator.of(context).pushNamed(
                                  NotificationByTypeScreen.routName,
                                  arguments: {
                                    'withBack': true,
                                    'type': Constants.notificationPaymentKey,
                                  }),
                            ),
                            ...state.response.paymentNotifications!
                                .map((e) => NotificationWidget(
                                      withSeenListener: true,
                                      notification: e,
                                      onSeenTap: (id) {
                                        _seenNotificationCubit
                                            .setNotificationSeen(e.id!);
                                      },
                                      onSeenSuccess: (id) {
                                        NotificationModel? n = state
                                            .response.paymentNotifications!
                                            .firstWhereOrNull(
                                                (element) => element.id == id);
                                        if (n == null) return;
                                        n.isSeen = true;
                                        _notificationCubit
                                            .decreaseTotalUnSeenNumber();
                                      },
                                    ))
                                .toList(),
                          },

                          // Requests
                          if (state
                              .response.requestNotifications!.isNotEmpty) ...{
                            ViewAllIconHeader(
                              leadingText: S.current.requests,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              onNavigate: () => Navigator.of(context).pushNamed(
                                  NotificationByTypeScreen.routName,
                                  arguments: {
                                    'withBack': true,
                                    'type': Constants.notificationRequestsKey
                                  }),
                            ),
                            ...state.response.requestNotifications!
                                .map((e) => NotificationWidget(
                                      withSeenListener: true,
                                      notification: e,
                                      onSeenTap: (id) {
                                        _seenNotificationCubit
                                            .setNotificationSeen(e.id!);
                                      },
                                      onSeenSuccess: (id) {
                                        NotificationModel? n = state
                                            .response.requestNotifications!
                                            .firstWhereOrNull(
                                                (element) => element.id == id);
                                        if (n == null) return;
                                        n.isSeen = true;
                                        _notificationCubit
                                            .decreaseTotalUnSeenNumber();
                                      },
                                    ))
                                .toList()
                          },

                          // Activities
                          if (state
                              .response.activityNotifications!.isNotEmpty) ...{
                            ViewAllIconHeader(
                              leadingText: S.current.activities,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              onNavigate: () => Navigator.of(context).pushNamed(
                                  NotificationByTypeScreen.routName,
                                  arguments: {
                                    'withBack': true,
                                    'type': Constants.notificationActivityKey
                                  }),
                            ),
                            ...state.response.activityNotifications!
                                .map((e) => NotificationWidget(
                                      withSeenListener: true,
                                      onSeenTap: (id) {
                                        _seenNotificationCubit
                                            .setNotificationSeen(e.id!);
                                      },
                                      notification: e,
                                      onSeenSuccess: (id) {
                                        NotificationModel? n = state
                                            .response.activityNotifications!
                                            .firstWhereOrNull(
                                                (element) => element.id == id);
                                        if (n == null) return;
                                        n.isSeen = true;
                                        _notificationCubit
                                            .decreaseTotalUnSeenNumber();
                                      },
                                    ))
                                .toList(),
                          },
                        ],
                      ),
                    );
                  }
                  return Container();
                }))
        : Scaffold(body: GuestCard());
  }
}
