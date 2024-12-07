// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:ezeness/generated/l10n.dart';

class BoostPlansModel {
  final int id;
  final String name;
  final num cost;
  final num period;
  final int? status;
  final BannerPlanLocation? location;
  final String? availableDate;
  final List<String?>? allowedType;

  const BoostPlansModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.period,
    this.status,
    this.availableDate,
    this.location,
    this.allowedType,
  });

  factory BoostPlansModel.fromJson(Map<String, dynamic> json) {
    return BoostPlansModel(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      period: json['period'],
      status: json['status'],
      availableDate: json['avalible_date'],
      location: json['location'] != null
          ? BannerPlanLocation.values
              .firstWhereOrNull((element) => element.value == json['location'])
          : null,
      allowedType: json['allowed_type'] != null
          ? (json['allowed_type'] as List).map((e) => e?.toString()).toList()
          : null,
    );
  }
}

enum BannerPlanLocation {
  home,
  socialPage,
  shopPage,
}

extension BannerPlanLocationExtension on BannerPlanLocation {
  String get value {
    switch (this) {
      case BannerPlanLocation.home:
        return "HOME";
      case BannerPlanLocation.socialPage:
        return "SOCIAL_PAGE";
      case BannerPlanLocation.shopPage:
        return "SHOP_PAGE";
    }
  }
}

extension BannerPlanExtension on BannerPlanLocation {
  String get name {
    switch (this) {
      case BannerPlanLocation.home:
        return S.current.home;

      case BannerPlanLocation.shopPage:
        return S.current.shopPage;

      case BannerPlanLocation.socialPage:
        return S.current.shopPage;
    }
  }
}
