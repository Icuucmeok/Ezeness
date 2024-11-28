import 'dart:convert';

import 'package:ezeness/data/models/invite_credit/invite_credit_list.dart';
import 'package:ezeness/data/models/invite_user/invite_user.dart';

import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../models/invite_user/invite_user_list.dart';
import '../utils/error_handler.dart';

class InviteUserRepository {
  final ApiClient apiClient;

  InviteUserRepository(this.apiClient);

  Future<InviteUserList?> getInvitation(int type) async {
    InviteUserList? response;
    try {
      response = await apiClient.invokeApi<InviteUserList>(
        ApiConfig.getInvitation + "/$type",
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  // get invitations Credits
  Future<InviteCreditList?> getInvitationCredit() async {
    InviteCreditList? response;
    try {
      response = await apiClient.invokeApi<InviteCreditList>(
        ApiConfig.getInvitationCredit,
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> sendInvite(InviteUser body) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.addInvite,
        body: body.toJson(),
        requestType: HttpRequestType.post,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> deleteInvite(int id) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.deleteInvite + id.toString(),
        requestType: HttpRequestType.delete,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  // get pro Invitation
  Future<InviteUserList?> getProInvitation() async {
    InviteUserList? response;
    try {
      response = await apiClient.invokeApi<InviteUserList>(
        ApiConfig.getProInvitation,
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  // Toggle Pro Invitation Status
  Future<String?> toggleProInvitationStatus(int id) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.toggleProInvitationStatus + id.toString(),
        requestType: HttpRequestType.put,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> sendProInvite({required String title}) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.addProInvite,
        body: json.encode({"title": title}),
        requestType: HttpRequestType.post,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }
}
