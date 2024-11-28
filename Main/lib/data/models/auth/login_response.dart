import 'dart:convert';

import '../user/user.dart';

class LoginResponse {
  String? accessToken;
  User? user;



  LoginResponse({
    this.accessToken,
    this.user,

  });


  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse(
        accessToken: json["data"]['token'] as String?,
        user: User.fromJson(json["data"]),
      );

  factory LoginResponse.loadFromJson(Map<String, dynamic> json) =>
      LoginResponse(
        accessToken: json['token'] as String?,
      );

  Map<String, dynamic> toMap() =>
      {
        'token': accessToken,
      };

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return LoginResponse.fromJson(jsonDecode(rawJson));
  }

}