
import 'dart:convert';

import 'banner.dart';



class BannerList {
  final List<BannerModel>? bannerList;


  BannerList({
    this.bannerList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson).cast<Map<String, dynamic>>();
    final list= parsed.map<BannerModel>((json) => BannerModel.fromJson(json)).toList();
    return BannerList(bannerList: list);
  }

  static parsedToList(rawJson){
    final parsed =rawJson.cast<Map<String, dynamic>>();
    final List<BannerModel> list= parsed.map<BannerModel>((json) => BannerModel.fromJson(json)).toList();
    return list.isEmpty?[BannerModel(image: "https://shop.messe-berlin.de/media/2b/84/f6/1698832486/Bazaar%20final.PNG")]:list;
  }

}
