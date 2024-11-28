import 'dart:convert';

import 'package:ezeness/data/models/store/store_licence.dart';
import 'package:ezeness/data/models/upgrade_store_plan/upgrade_store_plan.dart';

import '../day_time.dart';



class Store {
  final int? id;
  final String? name;
  final int? deliveryRange;
  final UpgradeStorePlan? storePlan;
  List<DayTime>? shift;
  final StoreLicence? storeLicence;
  final String? subscriptionStartDate;
  final String? subscriptionEndDate;
  final int? status;
  final String? createdAt;
  Store({
    this.id,
    this.name,
    this.deliveryRange,
    this.storePlan,
    this.shift,
    this.storeLicence,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.createdAt,
    this.status,
  });

  factory Store.fromJson(Map<String, dynamic> json) =>
      Store(
        id: json['id'] as int?,
        name: json['name'] as String?,
        deliveryRange: json['delivery_range'] as int?,
        subscriptionStartDate:json['subscription']==null?null:json['subscription']['start_date'] as String?,
        subscriptionEndDate: json['subscription']==null?null:json['subscription']['end_date'] as String?,
        storePlan: json['type']==null?null:UpgradeStorePlan.fromJson(json['type']),
        shift: json['shift']==null?null:DayTime.parsedToList(json['shift']),
        storeLicence: json['licence']==null?null:StoreLicence.fromJson(json['licence']),
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subscription':{
        'start_date': subscriptionStartDate,
        'end_date': subscriptionEndDate,
      },
      'delivery_range': deliveryRange,
      'type':storePlan?.toMap(),
      'shift':shift?.map((e) =>e.toMap()).toList(),
      'licence':storeLicence?.toMap(),
      'status': status,
      'created_at': createdAt,
    };
  }


  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return Store.fromJson(jsonDecode(rawJson));
  }
}
