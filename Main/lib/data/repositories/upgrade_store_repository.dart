import 'dart:convert';

import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../models/app_file.dart';
import '../models/upgrade_store_plan/upgrade_store_plan_body.dart';
import '../models/upgrade_store_plan/upgrade_store_plan_list.dart';
import '../utils/error_handler.dart';



class UpgradeStoreRepository {
  final ApiClient apiClient;

  UpgradeStoreRepository(this.apiClient);


  Future<UpgradeStorePlanList?> getPlan() async {

    UpgradeStorePlanList? response;
    try {
      response = await apiClient.invokeApi<UpgradeStorePlanList>(
        ApiConfig.upgradeStorePlan,
        requestType: HttpRequestType.get,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> editStorePlan(int storeTypeId) async {

    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.editStorePlan,
        body:jsonEncode({
          "type_id" : storeTypeId,
        }),
        requestType: HttpRequestType.post,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> upgradeToStorePlan(UpgradeStorePlanBody body,List<AppFile> files) async {

    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.upgradeToStorePlan,
        headers: apiClient.head(contentType: "multipart/form-data"),
        body: body.toMap(),
        requestType: HttpRequestType.post,
        files: files,
        postRequestType: PostRequestType.uploadFile,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> editStoreInfo(UpgradeStorePlanBody body,List<AppFile> files) async {

    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.editStoreInfo,
        headers: apiClient.head(contentType: "multipart/form-data"),
        body: body.toMap(),
        requestType: HttpRequestType.post,
        files: files,
        postRequestType: PostRequestType.uploadFile,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }


}
