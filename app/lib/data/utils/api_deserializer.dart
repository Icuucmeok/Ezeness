import 'dart:developer';

import 'package:ezeness/data/models/app_config/app_config_model.dart';
import 'package:ezeness/data/models/auth/login_response.dart';
import 'package:ezeness/data/models/boost/plans/boost_plans_list.dart';
import 'package:ezeness/data/models/calculate_coin_model.dart';
import 'package:ezeness/data/models/category/category.dart';
import 'package:ezeness/data/models/category/category_list.dart';
import 'package:ezeness/data/models/hashtag/hashtag_list.dart';
import 'package:ezeness/data/models/invite_credit/invite_credit_list.dart';
import 'package:ezeness/data/models/invite_user/invite_user_list.dart';
import 'package:ezeness/data/models/my_favourite_response.dart';
import 'package:ezeness/data/models/notification/all_notifications_list.dart';
import 'package:ezeness/data/models/playlist/playlist.dart';
import 'package:ezeness/data/models/post/post_list.dart';
import 'package:ezeness/data/models/review/review.dart';
import 'package:ezeness/data/models/review/review_list.dart';
import 'package:ezeness/data/models/search_response.dart';
import 'package:ezeness/data/models/user/blocked_user_list.dart';
import 'package:ezeness/data/models/user/bookmark_user_list.dart';
import 'package:ezeness/data/models/user/liftup_user_list.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/user/user_list.dart';
import 'package:ezeness/data/utils/errors.dart';
import 'package:flutter/services.dart';

import '../models/comment/comment.dart';
import '../models/comment/comment_list.dart';
import '../models/explore_response.dart';
import '../models/followers.dart';
import '../models/notification/notification_list.dart';
import '../models/post/post.dart';
import '../models/upgrade_store_plan/upgrade_store_plan_list.dart';
import '../models/upgrade_username_plan/upgrade_username_plan_list.dart';
import '../models/user/like_user_list.dart';

class ApiDeserializer<R> {
  final String rawJson;

  ApiDeserializer({required this.rawJson});

  dynamic deserialize() {
    try {
      switch (R) {
        case String:
          return rawJson;
        case User:
          return User.parsed(rawJson);
        case UserList:
          return UserList.parsed(rawJson);
        case BlockedUserList:
          return BlockedUserList.parsed(rawJson);
        case LikeUserList:
          return LikeUserList.parsed(rawJson);
        case BookmarkUserList:
          return BookmarkUserList.parsed(rawJson);
        case CategoryList:
          return CategoryList.parsed(rawJson);
        case LoginResponse:
          return LoginResponse.parsed(rawJson);
        case UpgradeUsernamePlanList:
          return UpgradeUsernamePlanList.parsed(rawJson);
        case UpgradeStorePlanList:
          return UpgradeStorePlanList.parsed(rawJson);
        case PostList:
          return PostList.parsed(rawJson);
        case Post:
          return Post.parsed(rawJson);
        case Category:
          return Category.parsed(rawJson);
        case CommentList:
          return CommentList.parsed(rawJson);
        case CommentModel:
          return CommentModel.parsed(rawJson);
        case ExploreResponse:
          return ExploreResponse.parsed(rawJson);
        case InviteUserList:
          return InviteUserList.parsed(rawJson);
        case InviteCreditList:
          return InviteCreditList.parsed(rawJson);
        case MyFavouriteResponse:
          return MyFavouriteResponse.parsed(rawJson);
        case Followers:
          return Followers.parsed(rawJson);
        case SearchResponse:
          return SearchResponse.parsed(rawJson);
        case NotificationList:
          return NotificationList.parsed(rawJson);
        case AllNotificationList:
          return AllNotificationList.parsed(rawJson);
        case ReviewList:
          return ReviewList.parsed(rawJson);
        case ReviewModel:
          return ReviewModel.parsed(rawJson);
        case HashtagList:
          return HashtagList.parsed(rawJson);
        case AppConfigModel:
          return AppConfigModel.parsed(rawJson);
        case Playlist:
          return Playlist.parsed(rawJson);
        case CalculateCoinModel:
          return CalculateCoinModel.parsed(rawJson);
        case BoostPlansList:
          return BoostPlansList.parsed(rawJson);
        case LiftUpUserList:
          return LiftUpUserList.parsed(rawJson);

        default:
          throw PlatformException(code: '', message: 'can not found response');
      }
    } on Error catch (e, s) {
      log(e.toString());
      log(s.toString());
      throw ParsingException(
        message: e.toString(),
        stack: s.toString(),
      );
    }
  }
}
