import 'dart:convert';

import 'user/user.dart';



class Followers {
  final List<User>? followers;
  final List<User>? following;
  final List<User>? mutual;
  final int? followersCount;
  final int? followingCount;
  final int? mutualCount;


  Followers({
    this.followers,
    this.following,
    this.mutual,
    this.followersCount,
    this.followingCount,
    this.mutualCount,
  });

  factory Followers.fromJson(Map<String, dynamic> json) =>
      Followers(
        followers: json["followers"] == null ? [] : List<User>.from(json["followers"]!.map((x) => User.fromJson(x["user"]))),
        following: json["following"] == null ? [] : List<User>.from(json["following"]!.map((x) => User.fromJson(x["follow_user"]))),
        mutual: json["mutual"] == null ? [] : List<User>.from(json["mutual"]!.map((x) => User.fromJson(x["user"]))),
        followersCount: json["counts"]["followers"] as int?,
        followingCount: json["counts"]["following"] as int?,
        mutualCount: json["counts"]["mutual"] as int?,
      );

  Map<String, dynamic> toMap() {
    return {

    };
  }


  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return Followers.fromJson(jsonDecode(rawJson)["data"]);
  }
}
