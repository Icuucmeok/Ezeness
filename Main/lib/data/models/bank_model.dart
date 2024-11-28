import 'dart:convert';



class BankModel {
  final int? id;
  final String? name;
  final String? bankName;
  final String? ibn;
  final String? file;

  BankModel({
    this.id,
    this.name,
    this.bankName,
    this.ibn,
    this.file,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) =>
      BankModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        bankName: json['bank_name'] as String?,
        ibn: json['ibn'] as String?,
        file: json['file'] as String?,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bank_name': bankName,
      'ibn': ibn,
      'file': file,
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return BankModel.fromJson(jsonDecode(rawJson));
  }
}
