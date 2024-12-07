// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ezeness/data/models/boost/plans/boost_plans_model.dart';

class BoostPlansList {
  final List<BoostPlansModel> boostPlans;
  final String? availableDate;

  const BoostPlansList({
    required this.boostPlans,
    required this.availableDate,
  });

  static parsed(rawJson) {
    final parsed = jsonDecode(rawJson)['data'];
    print(parsed);
    final list = (parsed['plans'] as List)
        .map<BoostPlansModel>((json) => BoostPlansModel.fromJson(json))
        .toList();
    return BoostPlansList(
      boostPlans: list,
      availableDate: parsed['available_date'],
    );
  }
}
