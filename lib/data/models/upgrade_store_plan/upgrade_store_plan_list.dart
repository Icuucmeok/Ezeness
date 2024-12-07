
import 'dart:convert';

import 'upgrade_store_plan.dart';



class UpgradeStorePlanList {
  final List<UpgradeStorePlan>? upgradeStorePlanList;


  UpgradeStorePlanList({
    this.upgradeStorePlanList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"].cast<Map<String, dynamic>>();
    final list= parsed.map<UpgradeStorePlan>((json) => UpgradeStorePlan.fromJson(json)).toList();
    return UpgradeStorePlanList(upgradeStorePlanList: list);
  }


}
