import 'dart:convert';
import 'package:ezeness/data/models/app_config/single_liftup_model.dart';

class AppConfigModel {
  final List<ReportReasons>? reasonsList;
  final String? privacyPolicy;
  final String? termOfUse;
  final bool isUserProfileLocationRequired;
  final bool isUserProfileBirthDateRequired;
  final bool isUserProfileGenderRequired;
  final bool isUserProfileNationalityRequired;
  final bool isShowBoostButton;
  final bool isShowGoogleButton;
  final String liftUpCoinRate;
  final List<SingleLiftupModel>? liftUps;

  AppConfigModel({
    this.reasonsList,
    this.termOfUse,
    this.privacyPolicy,
    this.isUserProfileLocationRequired = true,
    this.isUserProfileBirthDateRequired = true,
    this.isUserProfileGenderRequired = true,
    this.isUserProfileNationalityRequired = true,
    this.isShowBoostButton = true,
    this.isShowGoogleButton = true,
    this.liftUpCoinRate="0",
    this.liftUps,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
        reasonsList: json["reasons"] == null
            ? []
            : List<ReportReasons>.from(
                json["reasons"]!.map((x) => ReportReasons.fromJson(x))),
        privacyPolicy: json["privacy_policy"],
        termOfUse: json["term_of_use"],
        isUserProfileLocationRequired: (json["required_location"]?? "1") == "1",
        isUserProfileBirthDateRequired: (json["required_birthDate"]?? "1") == "1",
        isUserProfileGenderRequired: (json["required_gender"]?? "1") == "1",
        isUserProfileNationalityRequired: (json["required_country"] ?? "1") == "1",
        isShowBoostButton: (json["is_show_boost_button"] ?? "1") == "1",
        isShowGoogleButton: (json["is_show_google_button"] ?? "1") == "1",
        liftUpCoinRate: json['LIFT_UP_COIN_RATE'] ?? "0",
        liftUps: json["liftups"] == null
            ? []
            : List<SingleLiftupModel>.from(
                json["liftups"]!.map((x) => SingleLiftupModel.fromJson(x))),
      );

  Map<String, dynamic> toMap() {
    return {};
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return AppConfigModel.fromJson(jsonDecode(rawJson)["data"]);
  }
}

class ReportReasons {
  final int? id;
  final String? reason;

  ReportReasons({this.id, this.reason});
  factory ReportReasons.fromJson(Map<String, dynamic> json) => ReportReasons(
        id: json['id'] as int?,
        reason: json['reason'] as String?,
      );
}
