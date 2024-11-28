import 'dart:convert';

import 'package:ezeness/data/models/banner/banner_list.dart';
import 'package:ezeness/data/models/category/category.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/post/post_list.dart';
import 'package:ezeness/data/models/user/user.dart';

import 'banner/banner.dart';
import 'category/category_list.dart';



class ExploreResponse {
  final List<BannerModel> banners;
  final List<Category> categories;
  final List<User> connectsList;
  final List<Post> shopsPostList;
  final List<Post> forYouPostList;
  final List<Post> socialPostList;
  final List<Post> liftUpPostList;
  final List<Post> trendingPostList;
  final List<Post> vipPostList;
  final List<Post> islamPostList;
  final List<Post> savedPostList;
  final List<Post> bestSellersPostList;


  ExploreResponse({
    this.banners=const [],
    this.categories=const [],
    this.shopsPostList=const [],
    this.forYouPostList=const [],
    this.socialPostList=const [],
    this.liftUpPostList=const [],
    this.trendingPostList=const [],
    this.vipPostList=const [],
    this.connectsList=const [],
    this.islamPostList=const [],
    this.savedPostList=const [],
    this.bestSellersPostList=const [],
  });

  factory ExploreResponse.fromJson(Map<String, dynamic> json) =>
      ExploreResponse(
        banners:json['banners']==null?[]:BannerList.parsedToList(json['banners']),
        categories:  json['categories']==null?[]:CategoryList.parsedToList(json['categories']),
        connectsList:json['connects']==null?[]:User.parsedToList(json['connects']),
        shopsPostList:json['shops']==null?[]:PostList.parsedToList(json['shops']),
        forYouPostList:json['for_you']==null?[]:PostList.parsedToList(json['for_you']),
        socialPostList:json['socials']==null?[]:PostList.parsedToList(json['socials']),
        trendingPostList:json['trending']==null?[]:PostList.parsedToList(json['trending']),
        liftUpPostList:json['liftup']==null?[]:PostList.parsedToList(json['liftup']),
        vipPostList:json['vip']==null?[]:PostList.parsedToList(json['vip']),
        islamPostList:json['islam']==null?[]:PostList.parsedToList(json['islam']),
        savedPostList:json['saved']==null?[]:PostList.parsedToList(json['saved']),
        bestSellersPostList:json['best_seller']==null?[]:PostList.parsedToList(json['best_seller']),
      );


  static parsed(rawJson) {
    return ExploreResponse.fromJson(jsonDecode(rawJson)["data"]);
  }
}



