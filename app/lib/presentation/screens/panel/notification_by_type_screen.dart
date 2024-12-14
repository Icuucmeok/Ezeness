import 'package:ezeness/logic/cubit/notification/notification_cubit.dart';
import 'package:ezeness/logic/cubit/notification_by_type/notification_by_type_cubit.dart';
import 'package:ezeness/logic/cubit/seen_notification/seen_notification_cubit.dart';
import 'package:ezeness/presentation/screens/activity/widget/notification_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/notification/notification.dart';
import '../../../data/models/notification/notification_list.dart';
import '../../../data/models/pagination_page.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../widgets/common/common.dart';
import '../../widgets/pull_to_refresh.dart';

class NotificationByTypeScreen extends StatefulWidget {
  static const String routName = 'notification_by_type_screen';
  final bool? withBack;
  final int? type;
  const NotificationByTypeScreen({this.withBack, this.type, Key? key})
      : super(key: key);

  @override
  State<NotificationByTypeScreen> createState() =>
      _NotificationByTypeScreenState();
}

class _NotificationByTypeScreenState extends State<NotificationByTypeScreen> {
  late NotificationByTypeCubit _notificationByTypeCubit;
  late SeenNotificationCubit _seenNotificationCubit;
  late NotificationCubit _notificationCubit;
  bool withBack = false;
  late LoadMoreCubit _loadMoreCubit;
  List<NotificationModel> list = [];
  PaginationPage page = PaginationPage(currentPage: 2);
  ScrollController scrollController = ScrollController();
  late bool isLoggedIn;
  @override
  void initState() {
    isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();

    withBack = widget.withBack ?? false;

    _loadMoreCubit = context.read<LoadMoreCubit>();
    _notificationByTypeCubit = context.read<NotificationByTypeCubit>();
    _seenNotificationCubit = context.read<SeenNotificationCubit>();
    _notificationCubit = context.read<NotificationCubit>();
    if (isLoggedIn)
      _notificationByTypeCubit.getNotificationByType(type: widget.type);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        _loadMoreCubit.loadMoreNotificationListByType(page, type: widget.type);
      }
    });
    super.initState();
  }

  String get title {
    if (widget.type == Constants.notificationActivityKey) {
      return S.current.activities;
    }
    if (widget.type == Constants.notificationPaymentKey) {
      return S.current.payments;
    }
    if (widget.type == Constants.notificationRequestsKey) {
      return S.current.requests;
    }
    return S.current.notifications;
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return Scaffold(
      appBar: withBack ? AppBar(title: Text(title)) : null,
      body: isLoggedIn
          ? BlocConsumer<NotificationByTypeCubit, NotificationByTypeState>(
              bloc: _notificationByTypeCubit,
              listener: (context, state) {
                if (state is NotificationByTypeLoaded) {
                  page = PaginationPage(currentPage: 2);
                  list = state.response.notificationList!;
                }
              },
              builder: (context, state) {
                if (state is NotificationByTypeLoading) {
                  return const CenteredCircularProgressIndicator();
                }
                if (state is NotificationByTypeFailure) {
                  return ErrorHandler(exception: state.exception)
                      .buildErrorWidget(
                    context: context,
                    retryCallback: () => _notificationByTypeCubit
                        .getNotificationByType(type: widget.type),
                  );
                }
                if (state is NotificationByTypeLoaded) {
                  return list.isEmpty
                      ? const EmptyCard(withIcon: false)
                      : PullToRefresh(
                          onRefresh: () {
                            _notificationByTypeCubit.getNotificationByType(
                                type: widget.type);
                          },
                          child: BlocConsumer<SeenNotificationCubit,
                                  SeenNotificationState>(
                              bloc: _seenNotificationCubit,
                              listener: (context, state) {
                                if (state is SeenNotificationDone) {
                                  NotificationModel n = list.firstWhere(
                                      (element) =>
                                          element.id.toString() ==
                                          state.response);
                                  n.isSeen = true;

                                  bool isFound = context
                                      .read<NotificationCubit>()
                                      .isFoundInLists(
                                          int.tryParse(state.response) ?? -1);

                                  if (isFound) return;

                                  _notificationCubit
                                      .decreaseTotalUnSeenNumber();
                                }
                              },
                              builder: (context, state) {
                                return ListView(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    controller: scrollController,
                                    children: [
                                      ...list
                                          .map((e) => NotificationWidget(
                                                notification: e,
                                                withSeenListener: false,
                                                onSeenTap: (id) {
                                                  _seenNotificationCubit
                                                      .setNotificationSeen(id);
                                                },
                                              ))
                                          .toList(),
                                      BlocConsumer<LoadMoreCubit,
                                              LoadMoreState>(
                                          bloc: _loadMoreCubit,
                                          listener: (context, state) {
                                            if (state is LoadMoreFailure) {
                                              ErrorHandler(
                                                      exception:
                                                          state.exception)
                                                  .handleError(context);
                                            }
                                            if (state
                                                is LoadMoreNotificationListLoaded) {
                                              NotificationList temp =
                                                  state.response;
                                              if (temp.notificationList!
                                                  .isNotEmpty) {
                                                page.currentPage++;
                                                setState(() {
                                                  list.addAll(
                                                      temp.notificationList!);
                                                });
                                              }
                                            }
                                          },
                                          builder: (context, state) {
                                            if (state is LoadMoreLoading) {
                                              return const CenteredCircularProgressIndicator();
                                            }
                                            return Container();
                                          }),
                                    ]);
                              }),
                        );
                }
                return Container();
              })
          : const GuestCard(),
    );
  }
}
