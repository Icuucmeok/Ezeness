import 'dart:convert';

import 'package:ezeness/data/models/notification/notification.dart';

class AllNotificationList {
  final List<NotificationModel>? activityNotifications;
  final List<NotificationModel>? paymentNotifications;
  final List<NotificationModel>? requestNotifications;
  final int totalUnSeenNumber;

  AllNotificationList({
    this.activityNotifications,
    this.paymentNotifications,
    this.requestNotifications,
    this.totalUnSeenNumber = 0,
  });

  static parsed(rawJson) {
    final activityListParsed = jsonDecode(rawJson)["data"]
            ["activity_notifications"]
        .cast<Map<String, dynamic>>();
    final activityList = activityListParsed
        .map<NotificationModel>((json) => NotificationModel.fromJson(json))
        .toList();

    final paymentListParsed = jsonDecode(rawJson)["data"]
            ["payment_notifications"]
        .cast<Map<String, dynamic>>();
    final paymentList = paymentListParsed
        .map<NotificationModel>((json) => NotificationModel.fromJson(json))
        .toList();

    final requestListParsed = jsonDecode(rawJson)["data"]
            ["request_notifications"]
        .cast<Map<String, dynamic>>();
    final requestList = requestListParsed
        .map<NotificationModel>((json) => NotificationModel.fromJson(json))
        .toList();

    return AllNotificationList(
      activityNotifications: activityList,
      paymentNotifications: paymentList,
      requestNotifications: requestList,
      totalUnSeenNumber: (jsonDecode(rawJson)["data"]["total_un_seen"]) ?? 0,
    );
  }
}
