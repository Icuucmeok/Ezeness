import 'dart:convert';

import 'package:ezeness/data/models/post/post.dart';



class BannerModel {
  final int? id;
  final Post? post;
  final String? image;


  BannerModel({
    this.id,
    this.image,
    this.post,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      BannerModel(
        id: json['id'] as int?,
        image: json['image'] as String?,
        post: json["post"]==null?null:Post.fromJson(json["post"]),
      );

  Map<String, dynamic> toMap() {
    return {
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return BannerModel.fromJson(jsonDecode(rawJson));
  }
}
