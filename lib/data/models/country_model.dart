import 'dart:convert';

class CountryModel {
  final int id;
  final String title;
  final String value;

  CountryModel({this.id=0,this.title='', required this.value});

  factory CountryModel.fromJson(Map<String, dynamic> json) =>CountryModel(
    id: json['id'] as int,
    title: json['title'] as String,
    value:json['value'] as String,
  );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "value": value,
    };
  }

  String toJson() => json.encode(toMap());
}