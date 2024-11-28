import 'dart:convert';



class UpgradeStorePlan {
  final int? id;
  final String? name;
  final int? cost;
  final int? type;

  UpgradeStorePlan({
    this.id,
    this.name,
    this.cost,
    this.type,
  });

  factory UpgradeStorePlan.fromJson(Map<String, dynamic> json) =>
      UpgradeStorePlan(
        id: json['id'] as int?,
        name: json['name'] as String?,
        cost: json['cost'] as int?,
        type: json['type'] as int?,



      );

  Map<String, dynamic> toMap() {
    return {
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return UpgradeStorePlan.fromJson(jsonDecode(rawJson));
  }
}
