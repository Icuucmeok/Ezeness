import 'dart:convert';

import 'package:ezeness/config/api_config.dart';
import 'package:ezeness/data/data_providers/api_client.dart';
import 'package:ezeness/data/models/app_file.dart';
import 'package:ezeness/data/models/boost/plans/boost_plans_list.dart';
import 'package:ezeness/data/utils/error_handler.dart';

class BoostRepository {
  final ApiClient apiClient;
  BoostRepository(this.apiClient);

  Future<BoostPlansList?> getBannersPlans(
      {required int? postType, required int? isKids}) async {
    BoostPlansList? response;
    try {
      response = await apiClient.invokeApi<BoostPlansList>(
        ApiConfig.bannerPlans +
            (postType != null ? "?type=$postType" : "") +
            (isKids != null ? "&isKids=$isKids" : ""),
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<void> addBannerBoost({
    required int? postId,
    required int planId,
    required AppFile file,
    required String? startDate,
  }) async {
    try {
      final result = await apiClient.invokeApi<String>(
        ApiConfig.addBannerBoost,
        headers: apiClient.head(contentType: "multipart/form-data"),
        body: {"post_id": postId, "plan_id": planId, "start_date": startDate},
        requestType: HttpRequestType.post,
        files: [file],
        postRequestType: PostRequestType.uploadFile,
      );
      print(result);
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<BoostPlansList?> getPostPlans() async {
    BoostPlansList? response;
    try {
      response = await apiClient.invokeApi<BoostPlansList>(
        ApiConfig.postPlans,
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<void> addPostBoost({
    required int? postId,
    required int planId,
    required String? startDate,
  }) async {
    try {
      final result = await apiClient.invokeApi<String>(
        ApiConfig.addPostBoost,
        body: jsonEncode(
            {"post_id": postId, "plan_id": planId, "start_date": startDate}),
        requestType: HttpRequestType.post,
      );
      print(result);
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }
}
