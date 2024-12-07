import 'dart:convert';

import 'package:ezeness/data/models/my_favourite_response.dart';
import 'package:ezeness/data/models/review/review_list.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/user/user_list.dart';

import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../models/app_file.dart';
import '../models/auth/edit_profile_body.dart';
import '../models/pagination_page.dart';
import '../models/review/review.dart';
import '../models/user/blocked_user_list.dart';
import '../utils/error_handler.dart';

class ProfileRepository {
  final ApiClient apiClient;
  final bool isTesting;
  ProfileRepository(this.apiClient, {this.isTesting = false});

  Future<User?> getMyProfile() async {
    User? response;
    try {
      response = await apiClient.invokeApi<User>(
        ApiConfig.myProfile,
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: apiClient.isKids == 1),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<User?> getUserProfile(int id) async {
    User? response;
    try {
      response = await apiClient.invokeApi<User>(
        ApiConfig.getUsers + "/$id",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: apiClient.isKids == 1),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> bookmarkUnBookmarkUser(int userId) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.userFavouriteUnFavourite + "/$userId/favourite",
        requestType: HttpRequestType.post,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> blockUnBlockUser(int userId) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.blockUnBlockUser,
        body: json.encode({"block_user_id": userId}),
        requestType: HttpRequestType.post,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
    response = userId.toString();
    return response;
  }

  Future<String?> subscribeUnSubscribeUserNotification(int userId) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.userSubscribeUnSubscribeNotification,
        body: json.encode({"subscribe_user_id": userId}),
        requestType: HttpRequestType.post,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> editProfile(
      EditProfileBody body, AppFile? image, AppFile? coverImage) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.editProfile,
        headers: apiClient.head(contentType: "multipart/form-data"),
        body: body.toMap(),
        requestType: HttpRequestType.post,
        files: [if (image != null) image, if (coverImage != null) coverImage],
        postRequestType: PostRequestType.uploadFile,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<UserList?> getUsers({String search = '', PaginationPage? page}) async {
    UserList? response;
    try {
      response = await apiClient.invokeApi<UserList>(
        ApiConfig.getUsers +
            "?search=$search"
                "${page == null ? "" : "&per_page=${page.pageSize}&page=${page.currentPage}"}",
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<BlockedUserList?> getBlockedUsers() async {
    BlockedUserList? response;
    try {
      response = await apiClient.invokeApi<BlockedUserList>(
        ApiConfig.getBlockUsers,
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<MyFavouriteResponse?> getMyFavourites() async {
    MyFavouriteResponse? response;
    try {
      response = await apiClient.invokeApi<MyFavouriteResponse>(
        ApiConfig.myFavourite + "?per_page=10000",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<ReviewModel?> addReview(
    int reviewedUserId,
    String review,
    int rate,
  ) async {
    ReviewModel? response;
    try {
      response = await apiClient.invokeApi<ReviewModel>(
        ApiConfig.addReview,
        body: jsonEncode({
          "reviewed_user_id": reviewedUserId,
          "review": review,
          "rate": rate
        }),
        requestType: HttpRequestType.post,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> deleteReviews(int id) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.deleteReviews + "/$id",
        requestType: HttpRequestType.delete,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
    response = id.toString();
    return response;
  }

  Future<ReviewList?> getReviews(int userId) async {
    ReviewList? response;
    try {
      response = await apiClient.invokeApi<ReviewList>(
        ApiConfig.getReviews + "?reviewed_user_id=$userId",
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }
}
