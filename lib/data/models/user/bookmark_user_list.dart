
import 'dart:convert';

import 'user.dart';



class BookmarkUserList {
  final List<User>? bookmarkUserList;


  BookmarkUserList({
    this.bookmarkUserList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"].cast<Map<String, dynamic>>();
    final list= parsed.map<User>((json) => User.fromJson(json["user"])).toList();
    return BookmarkUserList(bookmarkUserList: list);
  }
}
