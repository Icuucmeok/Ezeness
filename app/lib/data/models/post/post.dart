import 'dart:convert';

import 'package:ezeness/data/models/liftup_response.dart';
import 'package:ezeness/data/models/playlist/playlist.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/day_time.dart';
import 'package:ezeness/res/app_res.dart';

import '../../../generated/l10n.dart';
import '../category/category.dart';

class Post {
  final int? id;
  String? description;
  String? additionalInfo;
  String? postTypeName;
  int? postType;
  Category? category;
  Category? subCategory;
  Category? childCategory;
  List<User>? postTaggedProfiles;
  List<Post>? postTaggedPosts;
  List<DayTime>? shifts;
  List<PostMedia>? postMediaList;
  List<CategoryOption>? postCategoryOption;
  double? price;
  String? priceCurrency;
  double? discount;
  double? sellPrice;
  int? stockType;
  int? stockCount;
  int? vipStockCount;
  int? deliveryRange;
  double? deliveryCharge;
  String? deliveryChargeCurrency;
  double? distance;
  int? isVip;
  int? isKids;
  int? isIslam;
  User? user;
  int likeNumber;
  int commentsNumber;
  int bookmarkNumber;
  bool isBookmark;
  bool isLike;
  double? time;
  String? createdAt;
  String? contactNumber;
  String? contactNumberCode;
  String? contactCallNumber;
  String? lat;
  String? lng;
  String? address;
  int views;
  bool isPostAvailable;
  List<Playlist>? postPlaylist;
  int liftUps;
  bool isLiftUp;
  LiftUpResponse? liftUpResponse;

  Post({
    this.id,
    this.description,
    this.additionalInfo,
    this.category,
    this.childCategory,
    this.subCategory,
    this.postTaggedProfiles,
    this.postTaggedPosts,
    this.shifts,
    this.postMediaList,
    this.postCategoryOption,
    this.postType,
    this.postTypeName,
    this.price,
    this.priceCurrency,
    this.discount,
    this.stockCount,
    this.vipStockCount,
    this.stockType,
    this.deliveryRange,
    this.deliveryCharge,
    this.deliveryChargeCurrency,
    this.distance,
    this.isVip,
    this.user,
    this.isBookmark = false,
    this.isLike = false,
    this.likeNumber = 0,
    this.commentsNumber = 0,
    this.bookmarkNumber = 0,
    this.sellPrice,
    this.createdAt,
    this.time,
    this.isKids,
    this.isIslam,
    this.contactNumber,
    this.contactNumberCode,
    this.contactCallNumber,
    this.lat,
    this.lng,
    this.address,
    this.isPostAvailable = true,
    this.views = 0,
    this.postPlaylist,
    this.isLiftUp = false,
    this.liftUps = 0,
    this.liftUpResponse,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String tempPostTypeName = "";
    if (json["type"] == Constants.postUpKey) {
      tempPostTypeName = S.current.postUp;
    }
    if (json["type"] == Constants.callUpKey) {
      tempPostTypeName = S.current.callUp;
    }
    if (json["type"] == Constants.shopUpKey) {
      tempPostTypeName = S.current.shopUp;
    }
    if (json["type"] == Constants.bookUpKey) {
      tempPostTypeName = S.current.bookUp;
    }
    double? price = json["post_details"] == null
        ? null
        : double.tryParse(json["post_details"]["price"].toString());
    double? discount = json["post_details"] == null
        ? null
        : double.tryParse(json["post_details"]["discount"].toString());
    double? sellPrice = (discount == null || discount == 0)
        ? price
        : price! - ((price * discount) / 100);
    return Post(
      id: json['id'] as int?,
      description: json["description"] as String?,
      additionalInfo: json["additional_info"] as String?,
      postType: json["type"] as int?,
      postTypeName: tempPostTypeName,
      childCategory:
          json["category"] == null ? null : Category.fromJson(json["category"]),
      subCategory: json["category"] == null ||
              json["category"]["parent_category"] == null
          ? null
          : Category.fromJson(json["category"]["parent_category"]),
      category: json["category"] == null ||
              json["category"]["parent_category"] == null
          ? null
          : Category.fromJson(
              json["category"]["parent_category"]["parent_category"]),
      postMediaList: json["post_medias"] == null
          ? []
          : List<PostMedia>.from(
              json["post_medias"]!.map((x) => PostMedia.fromJson(x))),
      postTaggedProfiles: json["post_tagged_profiles"] == null
          ? []
          : List<User>.from(
              json["post_tagged_profiles"]!.map((x) => User.fromJson(x))),
      postTaggedPosts: json["post_tagged_posts"] == null
          ? []
          : List<Post>.from(
              json["post_tagged_posts"]!.map((x) => Post.fromJson(x))),
      shifts: json["shifts"] == null
          ? []
          : List<DayTime>.from(json["shifts"]!.map((x) => DayTime.fromJson(x))),
      price: price,
      discount: discount,
      priceCurrency: json["post_details"] == null
          ? null
          : json["post_details"]["price_currency"] as String?,
      stockType: json["post_details"] == null
          ? null
          : json["post_details"]["stock_type"] as int?,
      stockCount: json["post_details"] == null
          ? null
          : json["post_details"]["stock_count"] as int?,
      vipStockCount: json["post_details"] == null
          ? null
          : json["post_details"]["vip_stock_count"] as int?,
      deliveryRange: json["post_details"] == null
          ? null
          : int.tryParse(json["post_details"]["delivery_range"].toString()),
      deliveryCharge: json["post_details"] == null
          ? null
          : double.tryParse(json["post_details"]["delivery_charge"].toString()),
      deliveryChargeCurrency: json["post_details"] == null
          ? null
          : json["post_details"]["delivery_charge_currency"] as String?,
      distance: json["distance"] == null
          ? null
          : double.parse(json["distance"].toString()),
      time: json["time"] == null ? null : double.parse(json["time"].toString()),
      isVip: json["is_vip"] as int?,
      isKids: json["is_kids"] as int?,
      isIslam: json["is_islam"] as int?,
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      isLike: json['is_like'] ?? false,
      isBookmark: json['is_favourite'] ?? false,
      likeNumber: json['likes'] ?? 0,
      commentsNumber: json['comments'] ?? 0,
      bookmarkNumber: json['favourites'] ?? 0,
      postCategoryOption: json["post_category_options"] == null
          ? null
          : CategoryOption.parsed(json["post_category_options"]),
      sellPrice: sellPrice,
      createdAt: json["created_at"] as String?,
      contactNumber:
          (json["post_contacts"] == null || json["post_contacts"].isEmpty)
              ? null
              : json["post_contacts"][0]["phone_number"],
      contactNumberCode:
          (json["post_contacts"] == null || json["post_contacts"].isEmpty)
              ? null
              : json["post_contacts"][0]["code_number"],
      contactCallNumber:
          (json["post_contacts"] == null || json["post_contacts"].isEmpty)
              ? null
              : json["post_contacts"][0]["phone"],
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
      address: json['address'] as String?,
      views: json['views'] as int,
      postPlaylist: json["play_lists"] == null
          ? []
          : List<Playlist>.from(
              json["play_lists"]!.map((x) => Playlist.fromJson(x))),
      isLiftUp: json['is_liftup'] ?? false,
      liftUps: json['liftups'] ?? 0,
      liftUpResponse: json["liftup"] == null ? null : LiftUpResponse.fromJson(json["liftup"]),
    );
  }

  void editWith(Post other) {
    description = other.description;
    additionalInfo = other.additionalInfo;
    postTypeName = other.postTypeName;
    postType = other.postType;
    category = other.category;
    subCategory = other.subCategory;
    childCategory = other.childCategory;
    postTaggedProfiles = other.postTaggedProfiles;
    postTaggedPosts = other.postTaggedPosts;
    shifts = other.shifts;
    postMediaList = other.postMediaList;
    postCategoryOption = other.postCategoryOption;
    price = other.price;
    discount = other.discount;
    sellPrice = other.sellPrice;
    priceCurrency = other.priceCurrency;
    stockType = other.stockType;
    stockCount = other.stockCount;
    vipStockCount = other.vipStockCount;
    deliveryRange = other.deliveryRange;
    deliveryCharge = other.deliveryCharge;
    distance = other.distance;
    isVip = other.isVip;
    isKids = other.isKids;
    isIslam = other.isIslam;
    user = other.user;
    likeNumber = other.likeNumber;
    commentsNumber = other.commentsNumber;
    bookmarkNumber = other.bookmarkNumber;
    isBookmark = other.isBookmark;
    isLike = other.isLike;
    time = other.time;
    createdAt = other.createdAt;
    contactNumber = other.contactNumber;
    contactNumberCode = other.contactNumberCode;
    contactCallNumber = other.contactCallNumber;
    isPostAvailable = other.isPostAvailable;
    lng = other.lng;
    lat = other.lat;
    address = other.address;
    postPlaylist = other.postPlaylist;
    isLiftUp = other.isLiftUp;
    liftUps = other.liftUps;
    liftUpResponse=other.liftUpResponse;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "additional_info": additionalInfo,
      "type": postType,
      "is_kids": isKids,
      "is_islam": isIslam,
      "user": user?.toMap(),
      "post_details": {
        "price": price,
        "discount": discount,
        "delivery_range": deliveryRange,
        "delivery_charge": deliveryCharge,
      },
      "distance": distance,
      "post_medias": postMediaList!.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return Post.fromJson(jsonDecode(rawJson)["data"]);
  }
}

class PostMedia {
  final int? id;
  final String? path;
  final String? thumbnail;
  final String? type;

  PostMedia({this.id, this.path, this.type, this.thumbnail});

  factory PostMedia.fromJson(Map<String, dynamic> json) => PostMedia(
        id: json["id"],
        path: json["file_name"],
        thumbnail: json["thumbnail"],
        type: json["file_name"].split(".").last == "webp" ? "image" : "video",
      );
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "file_name": path,
      "thumbnail": thumbnail,
    };
  }

  String toJson() => json.encode(toMap());
}

class PostHashtag {
  final int? id;
  final String? name;

  PostHashtag({
    this.id,
    this.name,
  });

  factory PostHashtag.fromJson(Map<String, dynamic> json) => PostHashtag(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
