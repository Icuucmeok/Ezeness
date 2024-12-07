import 'dart:convert';

import 'package:ezeness/data/models/notification/all_notifications_list.dart';

import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../models/notification/notification_list.dart';
import '../models/pagination_page.dart';
import '../utils/error_handler.dart';

class NotificationRepository {
  final ApiClient apiClient;

  NotificationRepository(this.apiClient);

  Future<AllNotificationList?> getNotificationsLists() async {
    AllNotificationList? response;
    try {
      response = await apiClient.invokeApi<AllNotificationList>(
        ApiConfig.notifications,
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<NotificationList?> getNotificationsByType(
      {PaginationPage? page, int? type}) async {
    NotificationList? response;
    try {
      response = await apiClient.invokeApi<NotificationList>(
        ApiConfig.notificationsByType +
            "${page == null ? "" : "?per_page=${page.pageSize}&page=${page.currentPage}"}" +
            "${type != null ? (page == null ? "?" : "&") + "type=$type" : ''}",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> setNotificationSeen(int? id) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.seenNotifications,
        body: json.encode({"notification_id": id}),
        requestType: HttpRequestType.post,
        headers: apiClient.head(withIsKids: false),
      );
      response = id.toString();
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }
}
