import 'dart:convert';

import 'notification.dart';

class NotificationList {
  final List<NotificationModel>? notificationList;

  NotificationList({
    this.notificationList,
  });

  static parsed(rawJson) {
    final parsed = jsonDecode(rawJson)["data"]["notifications"]
        .cast<Map<String, dynamic>>();
    final list = parsed
        .map<NotificationModel>((json) => NotificationModel.fromJson(json))
        .toList();
    return NotificationList(notificationList: list);
  }
}
