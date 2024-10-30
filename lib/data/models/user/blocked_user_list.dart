
import 'dart:convert';

import 'user.dart';



class BlockedUserList {
  final List<User>? blockedUserList;


  BlockedUserList({
    this.blockedUserList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"]["blocks"].cast<Map<String, dynamic>>();
    final list= parsed.map<User>((json) => User.fromJson(json["block_user"])).toList();
    return BlockedUserList(blockedUserList: list);
  }
}
