import 'dart:convert';

import '../user/user.dart';

class ReviewModel {
  final int? id;
  final String? review;
  final num? rate;
  User? user;

  ReviewModel({
    this.id,
    this.review,
    this.user,
    this.rate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'] as int?,
        review: json['review'] as String?,
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        rate: json['rate'] as num?,
      );

  static parsed(rawJson) {
    return ReviewModel.fromJson(jsonDecode(rawJson)["data"]);
  }
}
