import 'dart:convert';
import 'dart:developer';

import 'package:ezeness/logic/cubit/notification/notification_cubit.dart';
import 'package:ezeness/presentation/screens/panel/notification_by_type_screen.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data_providers/api_client.dart';
import '../../data/models/post/post.dart';
import '../router/app_router.dart';
import '../screens/post/post_view_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("onBackgroundMessage notification body: ${message.notification?.body}");
  log("onBackgroundMessage notification title: ${message.notification?.title}");
  log("onBackgroundMessage data: ${message.data}");
}

class FcmService {
  ApiClient apiClient;
  FcmService(this.apiClient) {
    fcmInitialize();
  }

  static String? firebaseToken;
  static late BuildContext context;
  static late FirebaseMessaging messaging;
  fcmInitialize() async {
    try {
      messaging = FirebaseMessaging.instance;
      messaging.getToken().then((token) {
        log(token.toString());
        firebaseToken = token!;
      });
      messaging.onTokenRefresh.listen((token) async {
        firebaseToken = token;
        if (apiClient.isLoggedIn()) {
          // apiClient.updateFcmToken(firebaseToken);
        }
      });
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  static fcmRequestPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static notificationNavigator(
      {int? id, int? typeCode, bool isFromNotificationScreen = false}) {
    if (typeCode == Constants.notificationTypePostKey) {
      Navigator.of(AppRouter.mainContext).pushNamed(PostViewScreen.routName,
          arguments: {"post": Post(id: id)});
    } else if (typeCode == Constants.notificationTypeCommentKey) {
      Navigator.of(AppRouter.mainContext).pushNamed(PostViewScreen.routName,
          arguments: {"post": Post(id: id)});
    } else {
      if (isFromNotificationScreen) return;
      Navigator.of(AppRouter.mainContext)
          .pushNamed(NotificationByTypeScreen.routName, arguments: {
        "withBack": true,
      });
    }
  }

  static fcmSetup(ctx) async {
    context = ctx;
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      var temp = jsonEncode(initialMessage.data);
      int? id = int.tryParse(jsonDecode(temp)["id"]);
      int? type = int.tryParse(jsonDecode(temp)["type"]);

      notificationNavigator(id: id, typeCode: type);

      log("initialMessage data: ${initialMessage.data}");
      log('initialMessage body: ${initialMessage.notification?.body}');
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      context.read<NotificationCubit>().getNotificationsLists();
      log('onMessage notification body: ${message.notification?.body}');
      log('onMessage notification title: ${message.notification?.title}');
      log("onMessage data: ${message.data}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var temp = jsonEncode(message.data);
      int? id = int.tryParse(jsonDecode(temp)["id"]);
      int? type = int.tryParse(jsonDecode(temp)["type"]);

      notificationNavigator(id: id, typeCode: type);

      log("onMessageOpenedApp data: ${message.data}");
      log('onMessageOpenedApp body: ${message.notification?.body}');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
