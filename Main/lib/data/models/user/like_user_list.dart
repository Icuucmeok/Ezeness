
import 'dart:convert';

import 'user.dart';



class LikeUserList {
  final List<User>? likeUserList;


  LikeUserList({
    this.likeUserList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"].cast<Map<String, dynamic>>();
    final list= parsed.map<User>((json) => User.fromJson(json["user"])).toList();
    return LikeUserList(likeUserList: list);
  }
}
