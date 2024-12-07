import 'dart:convert';



class StoreLicence {
  final int? id;
  final String? name;
  final String? registerDate;
  final String? commercialNumber;
  final String? commercialIssueDate;
  final String? commercialExpiryDate;
  final String? file;

  StoreLicence({
    this.id,
    this.name,
    this.registerDate,
    this.commercialNumber,
    this.commercialIssueDate,
    this.commercialExpiryDate,
    this.file,
  });

  factory StoreLicence.fromJson(Map<String, dynamic> json) =>
      StoreLicence(
        id: json['id'] as int?,
        name: json['name'] as String?,
        registerDate: json['register_date'] as String?,
        commercialNumber: json['commercial_number'] as String?,
        commercialIssueDate: json['commercial_issue_date'] as String?,
        commercialExpiryDate: json['commercial_expiry_date'] as String?,
        file: json['file'] as String?,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'register_date': registerDate,
      'commercial_number': commercialNumber,
      'commercial_issue_date': commercialIssueDate,
      'commercial_expiry_date': commercialExpiryDate,
      'file': file,
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return StoreLicence.fromJson(jsonDecode(rawJson));
  }
}
