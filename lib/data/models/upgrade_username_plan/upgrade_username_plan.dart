import 'dart:convert';



class UpgradeUsernamePlan {
  final int? id;
  final int? planId;
  final String? name;
  final int? cost;
  final int? period;
  final String? startDate;
  final String? endDate;

  UpgradeUsernamePlan({
    this.id,
    this.name,
    this.cost,
    this.period,
    this.startDate,
    this.endDate,
    this.planId,
  });

  factory UpgradeUsernamePlan.fromJson(Map<String, dynamic> json) =>
      UpgradeUsernamePlan(
        id: json['id'] as int?,
        name: json['name'] as String?,
        planId: json['plane_id'] as int?,
        cost: json['cost'] as int?,
        period: json['period'] as int?,
        startDate: json['start_date'] as String?,
        endDate: json['end_date'] as String?,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
      'plane_id': planId,
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return UpgradeUsernamePlan.fromJson(jsonDecode(rawJson));
  }
}
