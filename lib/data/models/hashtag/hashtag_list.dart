
import 'dart:convert';

import 'hashtag.dart';



class HashtagList {
  final List<HashtagModel>? hashtagList;


  HashtagList({
    this.hashtagList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"]["hashtags"].cast<Map<String, dynamic>>();
    final list= parsed.map<HashtagModel>((json) => HashtagModel.fromJson(json)).toList();
    return HashtagList(hashtagList: list);
  }

}
