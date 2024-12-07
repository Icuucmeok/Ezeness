
import 'dart:convert';

import 'comment.dart';



class CommentList {
  final List<CommentModel>? commentList;


  CommentList({
    this.commentList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"]["comments"].cast<Map<String, dynamic>>();
    final list= parsed.map<CommentModel>((json) => CommentModel.fromJson(json)).toList();
    return CommentList(commentList: list);
  }


}
