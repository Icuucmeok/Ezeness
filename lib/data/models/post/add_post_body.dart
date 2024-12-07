import 'dart:convert';

import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/category/category.dart';
import 'package:ezeness/data/models/post/post.dart';

import '../day_time.dart';

class AddPostBody {
  final String? description;
  final String? additionalInfo;
  final String? type;
  final String? categoryId;
  final String? price;
  final String? priceCurrency;
  final String? discount;
  final String? stockType;
  final String? stockCount;
  final String? vipStockCount;
  final List<Post>? postTaggedPosts;
  final List<User>? postTaggedProfiles;
  final List<DayTime>? postStockTime;
  final String? isVip;
  final String? isKids;
  final String? deliveryRange;
  final String? deliveryCharge;
  final String? deliveryChargeCurrency;
  final String? contactNumber;
  final String? contactNumberCode;
  final List<CategoryOption>? categoryOptionList;
  final String? lat;
  final String? lng;
  final String? address;

  static const String imageKey = "file";
  final String? isIslamic;

  AddPostBody({
    this.description,
    this.additionalInfo,
    this.type,
    this.categoryId,
    this.price,
    this.priceCurrency,
    this.discount,
    this.stockType,
    this.stockCount,
    this.vipStockCount,
    this.postTaggedPosts,
    this.postTaggedProfiles,
    this.postStockTime,
    this.deliveryCharge,
    this.deliveryChargeCurrency,
    this.deliveryRange,
    this.contactNumber,
    this.contactNumberCode,
    this.isVip,
    this.isKids,
    this.categoryOptionList,
    this.lat,
    this.lng,
    this.address,
    this.isIslamic,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'post[description]': description,
      'post[additional_info]': additionalInfo,
      'post[is_vip]': isVip,
      'post[type]': type,
      'post[category_id]': categoryId,
      'post_details[price]': price,
      'post_details[price_currency]': priceCurrency,
      'post[is_kids]': isKids,
      'post[is_islam]': isIslamic,
      'post_details[discount]': discount,
      'post_details[stock_type]': stockType,
      'post_details[stock_count]': stockCount,
      'post_details[delivery_range]': deliveryRange,
      'post_details[delivery_charge]': deliveryCharge,
      'post_details[delivery_charge_currency]': deliveryChargeCurrency,
      'post[lng]': lng,
      'post[lat]': lat,
      'post[address]': address,
      if (contactNumber != null) ...{
        "post_contacts[0][code_number]": contactNumberCode,
        'post_contacts[0][phone_number]': contactNumber,
      },
      if (vipStockCount != null) 'post_details[vip_stock_count]': vipStockCount,
    };
    if (postStockTime != null) {
      for (var element in postStockTime!) {
        if (element.fromTime != null && element.toTime != null) {
          map['shifts[${postStockTime!.indexOf(element)}][day]'] = element.id;
          map['shifts[${postStockTime!.indexOf(element)}][start]'] =
              element.fromTime;
          map['shifts[${postStockTime!.indexOf(element)}][end]'] =
              element.toTime;
        }
      }
    }
    if (categoryOptionList != null) {
      for (var element in categoryOptionList!) {
        map['post_category_options[${categoryOptionList!.indexOf(element)}][category_option_id]'] =
            element.id;
        map['post_category_options[${categoryOptionList!.indexOf(element)}][value]'] =
            element.value;
      }
    }
    if (postTaggedPosts != null) {
      for (var element in postTaggedPosts!) {
        map['post_tagged_posts[${postTaggedPosts!.indexOf(element)}]'] =
            element.id;
      }
    }
    if (postTaggedProfiles != null) {
      for (var element in postTaggedProfiles!) {
        map['post_tagged_profiles[${postTaggedProfiles!.indexOf(element)}]'] =
            element.id;
      }
    }

    return map;
  }

  String toJson() => json.encode(toMap());
}
