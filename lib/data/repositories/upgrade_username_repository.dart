import 'dart:convert';
import 'package:ezeness/data/models/upgrade_username_plan/upgrade_username_plan_list.dart';
import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../utils/error_handler.dart';



class UpgradeUserNameRepository {
  final ApiClient apiClient;

  UpgradeUserNameRepository(this.apiClient);


  Future<List<String>?> getMySuggestion() async {

    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.upgradeUserNameMySuggestion,
        requestType: HttpRequestType.get,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return jsonDecode(response!)["data"].map<String>((s) => s.toString()).toList();
  }

  Future<UpgradeUsernamePlanList?> getPlan() async {

    UpgradeUsernamePlanList? response;
    try {
      response = await apiClient.invokeApi<UpgradeUsernamePlanList>(
        ApiConfig.upgradeUserNamePlan,
        requestType: HttpRequestType.get,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> subscribeToPlan(int planId,String proUsername) async {

    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.upgradeUserNameSubscribe,
        body: jsonEncode({
          "plan_id":planId,
          "pro_username":proUsername,
        }),
        requestType: HttpRequestType.post,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> editUserName(String proUsername) async {

    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.upgradeUserNameEditUserName,
        body: jsonEncode({
          "pro_username":proUsername,
        }),
        requestType: HttpRequestType.post,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }


}
