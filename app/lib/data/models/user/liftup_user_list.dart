
import 'dart:convert';

import 'user.dart';



class LiftUpUserList {
  final List<User>? liftUpUserList;


  LiftUpUserList({
    this.liftUpUserList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"]["liftups"].cast<Map<String, dynamic>>();
    final list= parsed.map<User>((json) => User.fromJson(json["user"])).toList();
    return LiftUpUserList(liftUpUserList: list);
  }
}
