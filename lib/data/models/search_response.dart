import 'dart:convert';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/post/post_list.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/user/user_list.dart';

class SearchResponse {
  final List<Post> postList;
  final List<User> userList;
  final List<Post> productsList;

  SearchResponse({
    this.postList = const [],
    this.userList = const [],
    this.productsList = const [],
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        postList: PostList.parsedToList(json['posts']),
        userList: UserList.parsedToList(json['users']),
        productsList: PostList.parsedToList(json['products']),
      );

  Map<String, dynamic> toMap() {
    return {};
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return SearchResponse.fromJson(jsonDecode(rawJson)["data"]);
  }
}
