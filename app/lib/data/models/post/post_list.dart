
import 'dart:convert';
import 'post.dart';



class PostList {
  final List<Post>? postList;


  PostList({
    this.postList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"]["posts"].cast<Map<String, dynamic>>();
    final list= parsed.map<Post>((json) => Post.fromJson(json)).toList();
    return PostList(postList: list);
  }

  static parsedToList(rawJson){
    final parsed = rawJson.cast<Map<String, dynamic>>();
    final list= parsed.map<Post>((json) => Post.fromJson(json)).toList();
    return list;
  }
}

