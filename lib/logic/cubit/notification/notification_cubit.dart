import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/notification/all_notifications_list.dart';
import 'package:ezeness/data/models/notification/notification.dart';
import 'package:ezeness/data/repositories/Notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository;
  int totalUnSeenNumber = 0;
  AllNotificationList? notificationResponse;

  bool isFoundInLists(int id) {
    NotificationModel? n1 = notificationResponse?.activityNotifications
        ?.firstWhereOrNull((element) => element.id == id);
    if (n1 != null) return true;

    NotificationModel? n2 = notificationResponse?.paymentNotifications
        ?.firstWhereOrNull((element) => element.id == id);
    if (n2 != null) return true;

    NotificationModel? n3 = notificationResponse?.requestNotifications
        ?.firstWhereOrNull((element) => element.id == id);
    if (n3 != null) return true;

    return false;
  }

  NotificationCubit(this._notificationRepository)
      : super(NotificationInitial());

  void getNotificationsLists() async {
    emit(NotificationLoading());
    try {
      notificationResponse =
          await _notificationRepository.getNotificationsLists();
      totalUnSeenNumber = notificationResponse!.totalUnSeenNumber;
      emit(NotificationLoaded(notificationResponse!));
    } catch (e) {
      emit(NotificationFailure(e));
    }
  }

  void decreaseTotalUnSeenNumber() async {
    totalUnSeenNumber--;
    if(totalUnSeenNumber<0)totalUnSeenNumber=0;
    emit(NotificationLoaded(AllNotificationList(
      activityNotifications: notificationResponse?.activityNotifications ?? [],
      paymentNotifications: notificationResponse?.paymentNotifications ?? [],
      requestNotifications: notificationResponse?.requestNotifications ?? [],
      totalUnSeenNumber: totalUnSeenNumber,
    )));
  }

  void zeroTotalUnSeenNumber() async {
    totalUnSeenNumber = 0;
    emit(NotificationLoaded(AllNotificationList(
      activityNotifications: notificationResponse?.activityNotifications ?? [],
      paymentNotifications: notificationResponse?.paymentNotifications ?? [],
      requestNotifications: notificationResponse?.requestNotifications ?? [],
      totalUnSeenNumber: totalUnSeenNumber,
    )));
  }
}
