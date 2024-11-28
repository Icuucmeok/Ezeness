
import 'dart:convert';

import 'upgrade_username_plan.dart';



class UpgradeUsernamePlanList {
  final List<UpgradeUsernamePlan>? upgradeUsernamePlanList;


  UpgradeUsernamePlanList({
    this.upgradeUsernamePlanList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"].cast<Map<String, dynamic>>();
    final list= parsed.map<UpgradeUsernamePlan>((json) => UpgradeUsernamePlan.fromJson(json)).toList();
    return UpgradeUsernamePlanList(upgradeUsernamePlanList: list);
  }


}
