import 'dart:convert';



class HashtagModel {
  final int? id;
  final String? name;
  final int? count;


  HashtagModel({
    this.id,
    this.name,
    this.count,
  });

  factory HashtagModel.fromJson(Map<String, dynamic> json) =>
      HashtagModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        count: json['count'] as int?,
      );

  Map<String, dynamic> toMap() {
    return {
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return HashtagModel.fromJson(jsonDecode(rawJson));
  }
}
