import 'dart:convert';

import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../models/followers.dart';
import '../utils/error_handler.dart';




class FollowingRepository {
  final ApiClient apiClient;

  FollowingRepository(this.apiClient);

  Future<String?> followUnFollowUser(int userId) async {

    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.userFollowUnFollow,
        body: jsonEncode({
          "user_id":userId,
        }),
        requestType: HttpRequestType.post,
      );
      response=userId.toString();
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<Followers?> getFollowers(int userId) async {

    Followers? response;
    try {
      response = await apiClient.invokeApi<Followers>(
        ApiConfig.followers+"/$userId/followers",
        requestType: HttpRequestType.get,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }
}
