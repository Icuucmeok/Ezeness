import 'package:ezeness/data/models/user/user.dart';

class LiftUpResponse {
  final int? id;
  final String? description;
  final String? createdAt;
  final User? user;


  LiftUpResponse({
    this.id,
    this.description,
    this.createdAt,
    this.user,
  });

  factory LiftUpResponse.fromJson(Map<String, dynamic> json) =>
      LiftUpResponse(
        id:json['id'] as int?,
        description:json['description'] as String?,
        createdAt:json['created_at'] as String?,
        user:json['user']==null?null:User.fromJson(json['user']),

      );
}



