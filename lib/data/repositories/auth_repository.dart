import 'dart:convert';

import 'package:ezeness/data/data_providers/api_client.dart';
import 'package:ezeness/data/models/auth/signup_body.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/pick_location_model.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import '../../config/api_config.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../models/app_config/app_config_model.dart';
import '../models/auth/login_body.dart';
import '../models/auth/login_response.dart';
import '../models/country_model.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  late String tempVerificationValue;
  String? tempInvitationCode;
  late String tempCodeNumber;
  late bool tempIsSignUpWithEmail;

  late String tempResetValue;
  late String tempResetCode;
  late String tempResetCodeNumber;
  late bool tempResetIsEmail;
  Future<void> signOut(AppConfigCubit appConfigCubit,
      {bool withApi = true}) async {
    try {
      if (withApi) {
        await apiClient.invokeApi<String>(
          ApiConfig.logout,
          requestType: HttpRequestType.get,
        );
      }
      await apiClient.removeLoginResponse();
      appConfigCubit.setUser(User());
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<LoginResponse?> sigIn(LoginBody body) async {
    LoginResponse? loginResponse;
    try {
      loginResponse = await apiClient.invokeApi<LoginResponse>(
        ApiConfig.login,
        body: body.toJson(),
        headers: apiClient.head()..remove('Authorization'),
      );
      apiClient.setLoginResponse = loginResponse;
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return loginResponse;
  }

  Future<LoginResponse?> socialSigIn(
      String token, String provider, String fcmToken) async {
    LoginResponse? loginResponse;
    try {
      loginResponse = await apiClient.invokeApi<LoginResponse>(
        ApiConfig.socialLogin,
        body: json.encode({
          "token": token,
          "provider": provider,
          "fcm_token": fcmToken,
        }),
        headers: apiClient.head()..remove('Authorization'),
      );
      apiClient.setLoginResponse = loginResponse;
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return loginResponse;
  }

  Future<List<String>?> getUserNameSuggestion(String name) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(ApiConfig.userNameSuggestion,
          requestType: HttpRequestType.post,
          body: jsonEncode({"username": "$name"}));
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return jsonDecode(response!)["data"]
        .map<String>((s) => s.toString())
        .toList();
  }

  Future<void> checkInvitationCode(String invitationCode) async {
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.checkCode,
        body: {
          "code": invitationCode,
        },
        headers:
            apiClient.head(contentType: "application/x-www-form-urlencoded")
              ..remove('Authorization'),
      );
      tempInvitationCode = invitationCode;
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<void> sendVerificationCode(String verificationValue,
      bool isSignUpWithEmail, String codeNumber) async {
    tempIsSignUpWithEmail = isSignUpWithEmail;
    tempVerificationValue = verificationValue;
    tempCodeNumber = codeNumber;

    try {
      await apiClient.invokeApi<String>(
        ApiConfig.sendCode,
        body: json.encode(isSignUpWithEmail
            ? {
                "email": verificationValue,
                //   "code":tempInvitationCode,
              }
            : {
                "phone_number": verificationValue,
                "code_number": codeNumber,
                //"code":tempInvitationCode,
              }),
        headers: apiClient.head()..remove('Authorization'),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<void> sendResetPasswordCode(
      String resetValue, bool isEmail, String codeNumber) async {
    tempResetIsEmail = isEmail;
    tempResetValue = resetValue;
    tempResetCodeNumber = codeNumber;
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.sendResetPasswordCode,
        body: isEmail
            ? {
                "email": resetValue,
              }
            : {
                "phone_number": resetValue,
                "code_number": codeNumber,
              },
        headers:
            apiClient.head(contentType: "application/x-www-form-urlencoded")
              ..remove('Authorization'),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<void> reSendResetPasswordCode() async {
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.sendResetPasswordCode,
        body: tempResetIsEmail
            ? {
                "email": tempResetValue,
              }
            : {
                "phone_number": tempResetValue,
                "code_number": tempResetCodeNumber,
              },
        headers:
            apiClient.head(contentType: "application/x-www-form-urlencoded")
              ..remove('Authorization'),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<void> checkResetPasswordCode(String code) async {
    tempResetCode = code;
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.checkResetPasswordCode,
        body: tempResetIsEmail
            ? {
                "email": tempResetValue,
                "code": code,
              }
            : {
                "phone_number": tempResetValue,
                "code_number": tempResetCodeNumber,
                "code": code,
              },
        headers:
            apiClient.head(contentType: "application/x-www-form-urlencoded")
              ..remove('Authorization'),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<void> resetPassword(
      String password, String passwordConfirmation) async {
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.resetPassword,
        body: tempResetIsEmail
            ? {
                "email": tempResetValue,
                "code": tempResetCode,
                "password": password,
                "password_confirmation": passwordConfirmation,
              }
            : {
                "phone_number": tempResetValue,
                "code_number": tempResetCodeNumber,
                "code": tempResetCode,
                "password": password,
                "password_confirmation": passwordConfirmation,
              },
        headers:
            apiClient.head(contentType: "application/x-www-form-urlencoded")
              ..remove('Authorization'),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<void> createChangePassword({
      required String password, required String passwordConfirmation,String? oldPassword}) async {
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.createChangePassword,
        body: json.encode({
          if(oldPassword!=null)
          "old_password": oldPassword,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.deleteAccount,
        body: json.encode({
          "password": password,
        }),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<void> reSendVerificationCode() async {
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.sendCode,
        body: tempIsSignUpWithEmail
            ? {
                "email": tempVerificationValue,
                //  "code":tempInvitationCode,
              }
            : {
                "phone_number": tempVerificationValue,
                "code_number": tempCodeNumber,
                //  "code":tempInvitationCode,
              },
        headers:
            apiClient.head(contentType: "application/x-www-form-urlencoded")
              ..remove('Authorization'),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<void> verifyCode(String code) async {
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.verifyCode,
        body: json.encode(tempIsSignUpWithEmail
            ? {
                "email": tempVerificationValue,
                "code": code,
              }
            : {
                "phone_number": tempVerificationValue,
                "code_number": tempCodeNumber,
                "code": code,
              }),
        headers: apiClient.head()..remove('Authorization'),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<LoginResponse?> signUp(SignUpBody body) async {
    body = body.copyWith(
      code: tempInvitationCode,
      email: tempIsSignUpWithEmail ? tempVerificationValue : null,
      phoneNumber: tempIsSignUpWithEmail ? null : tempVerificationValue,
      codeNumber: tempIsSignUpWithEmail ? null : tempCodeNumber,
    );
    LoginResponse? loginResponse;
    try {
      loginResponse = await apiClient.invokeApi<LoginResponse>(
        ApiConfig.signup,
        body: body.toJson(),
        headers: apiClient.head()..remove('Authorization'),
      );
      apiClient.setLoginResponse = loginResponse;
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return loginResponse;
  }

  Future<String?> validateSignUpInfo(SignUpBody body) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.validateSignUpInfo,
        body: body.toJson(),
        headers: apiClient.head()..remove('Authorization'),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  PickLocationModel? getCurrentLocation() {
    return apiClient.currentLocation;
  }

  PickLocationModel? getUserLocation() {
    return apiClient.userLocation;
  }

  CountryModel? getAppCountry() {
    return apiClient.appCountry;
  }

  int getIsKids() {
    return apiClient.isKids;
  }

  void setIsKids(int isKids) {
    apiClient.setIsKids = isKids;
  }

  void setCurrentLocation(PickLocationModel? currentLocation) {
    apiClient.setCurrentLocation = currentLocation;
  }

  void setUserLocation(PickLocationModel? UserLocation) {
    apiClient.setUserLocation = UserLocation;
  }

  void setAppCountry(CountryModel? appCountry) {
    apiClient.setAppCountry = appCountry;
  }

  Future<void> sendInvitation(String email, String name) async {
    try {
      await apiClient.invokeApi<String>(
        ApiConfig.sendInvitation,
        body: json.encode({
          "email": email,
          "name": name,
        }),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }

  Future<AppConfigModel?> getAppConfig() async {
    AppConfigModel? response;
    try {
      response = await apiClient.invokeApi<AppConfigModel>(
        ApiConfig.appConfig,
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
    return response;
  }

  String getCurrency() {
    return apiClient.currency;
  }

  void setCurrency(String currency) {
    apiClient.setCurrency = currency;
  }
}
