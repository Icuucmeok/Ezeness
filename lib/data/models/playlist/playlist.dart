import 'dart:convert';



class Playlist {
  final int? id;
  final String? name;
  final String? createdAt;

  Playlist({
    this.id,
    this.name,
    this.createdAt,

  });
  factory Playlist.fromJson(Map<String, dynamic> json) =>
      Playlist(
        id: json['id'] as int?,
        name: json['name'] as String?,
        createdAt: json['created_at'] as String?,
      );

  Map<String, dynamic> toMap() {
    return {
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return Playlist.fromJson(jsonDecode(rawJson)["data"]);
  }
}



