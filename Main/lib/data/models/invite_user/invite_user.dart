import 'dart:convert';

class InviteUser {
  final int? id;
  final int? type;
  final String? name;
  final String? codeNumber;
  final String? phoneNumber;
  final String? email;
  final String? code;
  final bool? isUsed;
  final String? createdAt;
  final int? status;
  final int? totalJoined;
  final String? title;

  final String? extraCount;

  InviteUser({
    this.id,
    this.type,
    this.name,
    this.codeNumber,
    this.phoneNumber,
    this.email,
    this.code,
    this.isUsed,
    this.createdAt,
    this.extraCount,
    this.totalJoined,
    this.status,
    this.title,
  });

  factory InviteUser.fromJson(Map<String, dynamic> json) => InviteUser(
        id: json['id'] as int?,
        type: json['type'] as int?,
        codeNumber: json['code_number'] as String?,
        name: json['name'] as String?,
        phoneNumber: json['phone_number'] as String?,
        email: json['email'].toString(),
        code: json['code'].toString(),
        isUsed: json['is_used'] == 1,
        createdAt: json['created_at'] as String?,
        status: json['status'] as int?,
        totalJoined: json['total_joined'] as int?,
        title: json['title'] as String?,
      );

  Map<String, dynamic> toMap() {
    return {
      "code_number": codeNumber,
      "phone_number": phoneNumber,
      "type": type,
      "email": email,
      "name": name,
      if (extraCount != null)
        "extra": [
          {"type": type, "count": extraCount}
        ]
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return InviteUser.fromJson(jsonDecode(rawJson)["data"]);
  }
}
