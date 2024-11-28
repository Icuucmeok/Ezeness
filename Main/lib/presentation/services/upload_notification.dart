import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class UploadNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showUploadNotification(
      int id, String title, String body,bool ongoing) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'upload_notification',
      'Upload Notification',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      silent: true,
      ongoing: ongoing,
    );
    DarwinNotificationDetails iosNotification=DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,

    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iosNotification);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // static Future<void> updateUploadNotification(
  //     int id, String title, String body, int progressPercentage) async {
  //   await flutterLocalNotificationsPlugin.show(
  //     id,
  //     title,
  //     body,
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'upload_notification',
  //         'Upload Notification',
  //         importance: Importance.high,
  //         priority: Priority.high,
  //         onlyAlertOnce: true,
  //         showProgress: true,
  //         maxProgress: 100,
  //         progress: progressPercentage,
  //       ),
  //     ),
  //   );
  // }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

