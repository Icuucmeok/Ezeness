import 'dart:convert';

import 'package:ezeness/data/models/user/user.dart';



class NotificationModel {
  final int? id;
  final int? userId;
  final String? title;
  bool isSeen;
  final String? body;
  final String? postImage;
  final User? notificationUser;
  final int? dataId;
  final int? dataType;
  final String? createdAt;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.isSeen=true,
    this.body,
    this.dataId,
    this.postImage,
    this.notificationUser,
    this.dataType,
    this.createdAt,

  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        title: json['title'] as String?,
        isSeen: json['seen']==1,
        notificationUser: json['notification_user']==null?null:User.fromJson(json['notification_user']),
        createdAt: json['created_at'] as String?,
        body: json['body'] as String?,
        postImage: json['image'] as String?,
        dataId: json['data']==null?null:json['data']['id'] as int?,
        dataType: json['data']==null?null:json['data']['type'] as int?,
      );

  Map<String, dynamic> toMap() {
    return {
    };
  }

  String toJson() => json.encode(toMap());
}



