import 'dart:convert';

import '../user/user.dart';

class CommentModel {
  final int? id;
  final int? postId;
  final int? parentCommentId;
  int likes;
  List<CommentModel> replies;
  bool showReplies;
  bool isLike;
  final String? comment;
  User? user;
  final String? createAt;

  CommentModel({
    this.id,
    this.postId,
    this.parentCommentId,
    this.comment,
    this.createAt,
    this.user,
    this.likes = 0,
    this.isLike = false,
    this.replies = const [],
    this.showReplies = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'] as int?,
        postId: json['post_id'] as int?,
        parentCommentId: json['comment_id'] as int?,
        likes: json['likes'] ?? 0,
        comment: json['comment'] as String?,
        isLike: json['is_like'] ?? false,
        createAt: json['created_at'],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        replies: json["children"] == null
            ? []
            : json["children"]
                .map<CommentModel>((json) => CommentModel.fromJson(json))
                .toList(),
      );

  static parsed(rawJson) {
    return CommentModel.fromJson(jsonDecode(rawJson)["data"]);
  }
}
