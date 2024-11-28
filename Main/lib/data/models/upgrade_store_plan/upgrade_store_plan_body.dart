import 'dart:convert';

import '../day_time.dart';

class UpgradeStorePlanBody {
  final String? ownerName;
  final String? ownerGender;
  final String? ownerBirthDate;


  final String? storeTypeId;
  final String? storeName;
  final String? storeLat;
  final String? storeLng;
  final String? storeAddress;
  final String? storeDeliveryRange;

  final String? identityCardNumber;
  final String? identityCardIssueDate;
  final String? identityCardExpireDate;
  static const String identityCardFrontImageKey = "identity_card[front_image]";
  static const String identityCardBackImageKey = "identity_card[back_image]";

  final String? licenceName;
  final String? licenceRegisterDate;
  final String? licenceCommercialNumber;
  final String? licenceCommercialIssueDate;
  final String? licenceCommercialExpiryDate;
  static const String licenceImageKey = "licence[file]";

  final String? bankHolderName;
  final String? bankName;
  final String? bankIbn;
  static const String bankImageKey = "bank[file]";

  List<DayTime> shifts;
  UpgradeStorePlanBody({
    this.ownerName,
    this.ownerGender,
    this.ownerBirthDate,

    this.storeTypeId,
    this.storeName,
    this.storeLat,
    this.storeLng,
    this.storeAddress,
    this.storeDeliveryRange,


    this.identityCardNumber,
    this.identityCardIssueDate,
    this.identityCardExpireDate,

    this.licenceName,
    this.licenceRegisterDate,
    this.licenceCommercialNumber,
    this.licenceCommercialIssueDate,
    this.licenceCommercialExpiryDate,

    this.bankHolderName,
    this.bankName,
    this.bankIbn,

    required this.shifts,
  });


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map={
      'owner[name]': ownerName,
      'owner[gender]': ownerGender,
      'owner[date_of_birth]': ownerBirthDate,
      'owner[lat]': storeLat,
      'owner[lng]': storeLng,
      'owner[address]': storeAddress,

      'identity_card[number]': identityCardNumber,
      'identity_card[issue_date]': identityCardIssueDate,
      'identity_card[expire_date]': identityCardExpireDate,


      'licence[name]': licenceName,
      'licence[register_date]': licenceRegisterDate,
      'licence[commercial_number]': licenceCommercialNumber,
      'licence[commercial_issue_date]': licenceCommercialIssueDate,
      'licence[commercial_expiry_date]': licenceCommercialExpiryDate,

      'store[type_id]': storeTypeId,
      'store[name]': storeName,
      'store[delivery_range]': storeDeliveryRange,
       if(bankHolderName!=null && bankHolderName!="null" && bankHolderName!="")...{
         'bank[name]': bankHolderName,
         'bank[bank_name]': bankName,
         'bank[ibn]': bankIbn,
       }
    };
    for (var element in shifts) {
      if(element.fromTime!=null && element.toTime!=null) {
        map['shifts[${shifts.indexOf(element)}][day]'] = element.id;
        map['shifts[${shifts.indexOf(element)}][start]'] = element.fromTime;
        map['shifts[${shifts.indexOf(element)}][end]'] = element.toTime;
      }
    }
    return map;
  }

  String toJson() => json.encode(toMap());
}
