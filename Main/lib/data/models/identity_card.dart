import 'dart:convert';



class IdentityCard {
  final int? id;
  final String? number;
  final String? issueDate;
  final String? expireDate;
  final String? frontImage;
  final String? backImage;

  IdentityCard({
    this.id,
    this.number,
    this.issueDate,
    this.expireDate,
    this.frontImage,
    this.backImage,
  });

  factory IdentityCard.fromJson(Map<String, dynamic> json) =>
      IdentityCard(
        id: json['id'] as int?,
        number: json['number'] as String?,
        issueDate: json['issue_date'] as String?,
        expireDate: json['expire_date'] as String?,
        frontImage: json['front_image'] as String?,
        backImage: json['back_image'] as String?,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'issue_date': issueDate,
      'expire_date': expireDate,
      'front_image': frontImage,
      'back_image': backImage,
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return IdentityCard.fromJson(jsonDecode(rawJson));
  }
}
