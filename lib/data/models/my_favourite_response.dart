import 'dart:convert';

import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/user/user.dart';

class MyFavouriteResponse {
  final List<Post>? favouritePostList;
  final List<User>? favouriteUserList;
  final List<Post>? favouriteProductsList;

  MyFavouriteResponse({
    this.favouritePostList,
    this.favouriteUserList,
    this.favouriteProductsList,
  });

  static parsed(rawJson) {
    final postList = jsonDecode(rawJson)["data"]["posts"]
        .cast<Map<String, dynamic>>()
        .map<Post>((json) => Post.fromJson(json["post"]))
        .toList();
    final userList = jsonDecode(rawJson)["data"]["users"]
        .cast<Map<String, dynamic>>()
        .map<User>((json) => User.fromJson(json["user"]))
        .toList();
    final productsList = jsonDecode(rawJson)["data"]["products"]
        .cast<Map<String, dynamic>>()
        .map<Post>((json) => Post.fromJson(json["post"]))
        .toList();

    return MyFavouriteResponse(
      favouritePostList: postList,
      favouriteUserList: userList,
      favouriteProductsList: productsList,
    );
  }
}
