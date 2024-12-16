import 'dart:convert';

import 'package:ezeness/data/models/bank_model.dart';
import 'package:ezeness/data/models/category/category.dart';
import 'package:ezeness/data/models/category/category_list.dart';
import 'package:ezeness/data/models/identity_card.dart';
import 'package:ezeness/data/models/playlist/playlist.dart';
import 'package:ezeness/data/models/playlist/playlist_list.dart';
import 'package:ezeness/data/models/store/store.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../upgrade_username_plan/upgrade_username_plan.dart';

class User {
  final int? id;
  final String themeMood;
  final bool isDarkBottomNavigation;
  final String? name;
  final String? wallet;
  final String? image;
  final String? coverImage;
  final String? username;
  final String? lat;
  final String? lng;
  final String? address;
  final String? proUsername;
  final String? email;
  final String? phoneNumber;
  final String? codeNumber;
  final String? birthDate;
  final int? gender;
  final String? role;
  final String? website;
  final String? accountCategory;
  final String? bio;
  final int? type;
  final UpgradeUsernamePlan? usernamePlan;
  final Store? store;
  final IdentityCard? identityCard;
  final BankModel? bank;
  final List<Category>? categoryList;
  final List<Playlist> playlist;
  int followers;
  int following;
  final int? posts;
  final int? totalPosts;
  final int? vipPosts;
  int reviews;
  String? contactNumber;
  String? contactNumberCode;
  String? contactCallNumber;
  final String coins;
  final String? nationality;
  final num? rate;
  final bool isSetPassword;

  ///Other Users only
  bool isFollowing;
  bool isFollowers;
  final double? distance;
  final double? time;
  bool? isFavourite;
  bool isSubscribeToNotification;

  final bool isSocialRegister;

  User({
    this.id,
    this.themeMood = Constants.defaultSystemThemeKey,
    this.isDarkBottomNavigation = false,
    this.image,
    this.coverImage,
    this.name,
    this.username,
    this.lat,
    this.lng,
    this.address,
    this.proUsername,
    this.email,
    this.wallet,
    this.phoneNumber,
    this.codeNumber,
    this.birthDate,
    this.gender,
    this.role,
    this.accountCategory,
    this.website,
    this.bio,
    this.type,
    this.usernamePlan,
    this.store,
    this.identityCard,
    this.bank,
    this.categoryList,
    this.posts,
    this.totalPosts,
    this.followers = 0,
    this.following = 0,
    this.vipPosts,
    this.isFollowing = false,
    this.isFollowers = false,
    this.time,
    this.distance,
    this.isFavourite,
    this.isSubscribeToNotification = false,
    this.reviews = 0,
    this.contactNumber,
    this.contactNumberCode,
    this.contactCallNumber,
    this.playlist = const [],
    this.coins = "0",
    this.rate,
    this.isSocialRegister = false,
    this.nationality,
    this.isSetPassword = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        themeMood: json['themeMood'] ?? Constants.defaultSystemThemeKey,
        gender: json['gender'] as int?,
        name: json['name'] as String?,
        coverImage: json['cover_image'] as String?,
        image: json['image'] != null
            ? json['image']
            : (json['gender'] == Constants.femaleKey
                ? Constants.femaleImageUrl
                : Constants.maleImageUrl),
        wallet: json['wallet'].toString(),
        username: json['username'] as String?,
        lat: json['lat'] as String?,
        lng: json['lng'] as String?,
        address: json['address'] as String?,
        proUsername: json['pro_username'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phone_number'] as String?,
        codeNumber: json['code_number'] as String?,
        birthDate: json['date_of_birth'] as String?,
        role: json['role'] as String?,
        bio: json['bio'] as String?,
        website: json['website'] as String?,
        usernamePlan: json['plan'] == null
            ? null
            : UpgradeUsernamePlan.fromJson(json['plan']),
        store: json['store'] == null ? null : Store.fromJson(json['store']),
        identityCard: json['identity_card'] == null
            ? null
            : IdentityCard.fromJson(json['identity_card']),
        bank: json['bank'] == null ? null : BankModel.fromJson(json['bank']),
        categoryList: json['categories'] == null
            ? null
            : CategoryList.parsedToList(json['categories']),
        playlist: json['play_lists'] == null
            ? []
            : PlaylistList.parsedToList(json['play_lists']),
        vipPosts: json['vip_posts'] as int?,
        posts: json['posts'] as int?,
        totalPosts: json['total_post'] as int?,
        reviews: json['reviews'] ?? 0,
        type: json['type'] as int?,
        following: json['following'] ?? 0,
        followers: json['followers'] ?? 0,
        isFollowing: json['is_following'] ?? false,
        isFollowers: json['is_follower'] ?? false,
        isFavourite: json['is_favourite'] ?? false,
        isSubscribeToNotification: json['is_subscribe'] ?? false,
        distance: json["distance"] == null
            ? null
            : double.parse(json["distance"].toString()),
        time:
            json["time"] == null ? null : double.parse(json["time"].toString()),
        contactNumber: (json["contacts"] == null || json["contacts"].isEmpty)
            ? null
            : json["contacts"][0]["phone_number"],
        contactNumberCode:
            (json["contacts"] == null || json["contacts"].isEmpty)
                ? null
                : json["contacts"][0]["code_number"],
        contactCallNumber:
            (json["contacts"] == null || json["contacts"].isEmpty)
                ? null
                : json["contacts"][0]["phone"],
        coins: json['coins'] == null ? "0" : json['coins'].toString(),
        isDarkBottomNavigation: json['isDarkBottomNavigation'] ?? false,
        rate: json['rate'],
        isSocialRegister: json['is_social_register'] ?? false,
        nationality: json['country'],
        isSetPassword: json['is_set_password'] == null
            ? false
            : json['is_set_password'] == 1,
      );

  String? getUserName() {
    return proUsername ?? username;
  }

  String getFollowingStatus() {
    if (isFollowing && isFollowers) {
      return S.current.taggingUp;
    } else if (isFollowing && !isFollowers) {
      return S.current.uTagging;
    } else if (!isFollowing && isFollowers) {
      return S.current.taggingU;
    } else {
      return S.current.tagUpHim;
    }
  }

  Color? getFollowingStatusColor() {
    if (isFollowing && isFollowers) {
      return Colors.green;
    } else if (isFollowing && !isFollowers) {
      return AppColors.greyDark;
    } else if (!isFollowing && isFollowers) {
      return AppColors.gold;
    } else {
      return null;
    }
  }

  User copyWith({
    int? id,
    String? themeMood,
    String? name,
    String? image,
    String? coverImage,
    String? username,
    String? lat,
    String? lng,
    String? address,
    String? proUsername,
    String? email,
    String? phoneNumber,
    String? codeNumber,
    String? birthDate,
    int? gender,
    String? role,
    String? website,
    String? accountCategory,
    String? bio,
    bool? isDarkBottomNavigation,
    UpgradeUsernamePlan? usernamePlan,
    Store? store,
    IdentityCard? identityCard,
    BankModel? bank,
    String? wallet,
    List<Category>? categoryList,
    List<Playlist>? playlist,
    int? followers,
    int? following,
    int? reviews,
    int? posts,
    int? vipPosts,
    int? type,
    bool? isFavourite,
    String? contactNumber,
    String? contactNumberCode,
    String? contactCallNumber,
    String? coins,
    String? nationality,
    num? rate,
    bool? isSetPassword,
  }) =>
      User(
        id: id ?? this.id,
        themeMood: themeMood ?? this.themeMood,
        isDarkBottomNavigation:
            isDarkBottomNavigation ?? this.isDarkBottomNavigation,
        name: name ?? this.name,
        image: image ?? this.image,
        coverImage: coverImage ?? this.coverImage,
        username: username ?? this.username,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        address: address ?? this.address,
        wallet: wallet ?? this.wallet,
        proUsername: proUsername ?? this.proUsername,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        codeNumber: codeNumber ?? this.codeNumber,
        birthDate: birthDate ?? this.birthDate,
        gender: gender ?? this.gender,
        role: role ?? this.role,
        website: website ?? this.website,
        accountCategory: accountCategory ?? this.accountCategory,
        bio: bio ?? this.bio,
        type: type ?? this.type,
        usernamePlan: usernamePlan ?? this.usernamePlan,
        store: store ?? this.store,
        identityCard: identityCard ?? this.identityCard,
        bank: bank ?? this.bank,
        categoryList: categoryList ?? this.categoryList,
        playlist: playlist ?? this.playlist,
        followers: followers ?? this.followers,
        following: following ?? this.following,
        reviews: reviews ?? this.reviews,
        vipPosts: vipPosts ?? this.vipPosts,
        posts: posts ?? this.posts,
        isFavourite: isFavourite ?? this.isFavourite,
        contactNumber: contactNumber ?? this.contactNumber,
        contactNumberCode: contactNumberCode ?? this.contactNumberCode,
        contactCallNumber: contactCallNumber ?? this.contactCallNumber,
        coins: coins ?? this.coins,
        rate: rate ?? this.rate,
        nationality: nationality ?? this.nationality,
        isSetPassword: isSetPassword ?? this.isSetPassword,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'themeMood': themeMood,
      'isDarkBottomNavigation': isDarkBottomNavigation,
      'gender': gender,
      'name': name,
      'image': image,
      'cover_image': coverImage,
      'wallet': wallet,
      'username': username,
      'lat': lat,
      'lng': lng,
      'address': address,
      'pro_username': proUsername,
      'email': email,
      'phone_number': phoneNumber,
      'code_number': codeNumber,
      'date_of_birth': birthDate,
      'role': role,
      'type': type,
      "bio": bio,
      'plan': usernamePlan?.toMap(),
      'store': store?.toMap(),
      'identity_card': identityCard?.toMap(),
      'bank': bank?.toMap(),
      'following': following,
      'followers': followers,
      'posts': posts,
      'vip_posts': vipPosts,
      'is_favourite': isFavourite,
      'is_subscribe': isSubscribeToNotification,
      'reviews': reviews,
      'coins': coins,
      'rate': rate,
      'country': nationality,
      'is_set_password': isSetPassword,
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return User.fromJson(jsonDecode(rawJson)["data"]);
  }

  static parsedToList(rawJson) {
    final parsed = rawJson.cast<Map<String, dynamic>>();
    final list = parsed.map<User>((json) => User.fromJson(json)).toList();
    return list;
  }

  ThemeMode getUserThemeMode(context) {
    if (this.themeMood == Constants.darkThemeKey) return ThemeMode.dark;
    if (this.themeMood == Constants.lightThemeKey) return ThemeMode.light;
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  String getUserThemeName() {
    if (this.themeMood == Constants.darkThemeKey) return S.current.darkTheme;
    if (this.themeMood == Constants.lightThemeKey) return S.current.lightTheme;
    return S.current.systemDefault;
  }
}
