
import 'dart:convert';

import 'user.dart';



class UserList {
  final List<User>? userList;


  UserList({
    this.userList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"]["users"].cast<Map<String, dynamic>>();
    final list= parsed.map<User>((json) => User.fromJson(json)).toList();
    return UserList(userList: list);
  }
  static parsedToList(rawJson){
    final parsed = rawJson.cast<Map<String, dynamic>>();
    final list= parsed.map<User>((json) => User.fromJson(json)).toList();
    return list;
  }
}
