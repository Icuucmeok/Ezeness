import 'package:ezeness/data/models/app_config/app_config_model.dart';
import 'package:ezeness/data/models/auth/login_body.dart';
import 'package:ezeness/data/models/auth/login_response.dart';
import 'package:ezeness/data/models/auth/signup_body.dart';
import 'package:ezeness/data/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

import '../../../data/models/country_model.dart';
import '../../../data/models/pick_location_model.dart';
import '../app_config/app_config_cubit.dart';

part 'session_controller_state.dart';

class SessionControllerCubit extends Cubit<SessionControllerState> {
  final AuthRepository _authRepository;
  SessionControllerCubit(this._authRepository)
      : super(SessionControllerInitial());

  bool isGetCurrentCurrency = true;
  void signOut(AppConfigCubit appConfigCubit) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.signOut(appConfigCubit);
      emit(SessionControllerSignedOut());
    } catch (e) {
      await _authRepository.signOut(appConfigCubit, withApi: false);
      emit(SessionControllerSignedOut());
      emit(SessionControllerError(e));
    }
  }

  void restartApp() async {
    emit(SessionControllerSignedOut());
    emit(SessionControllerInitial());
  }

  void goToSigInScreen() async {
    emit(SessionControllerGoToSigInScreen());
    emit(SessionControllerInitial());
  }

  void sigIn(LoginBody body) async {
    emit(SessionControllerLoading());
    try {
      var response = await _authRepository.sigIn(body);

      emit(SessionControllerSignedIn(response!));
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void socialSigIn(
      {required String token,
      required String provider,
      required String fcmToken}) async {
    emit(SessionControllerLoading());
    try {
      var response =
          await _authRepository.socialSigIn(token, provider, fcmToken);

      emit(SessionControllerSocialSignedIn(response!));
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void getUserNameSuggestion(String name) async {
    emit(SessionControllerUserNameSuggestionLoading());
    try {
      final data = await _authRepository.getUserNameSuggestion(name);
      emit(SessionControllerUserNameSuggestionLoaded(data!));
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void checkInvitationCode(String invitationCode) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.checkInvitationCode(invitationCode);

      emit(const SessionControllerInvitationCodeChecked());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void sendInvitation({required String email, required String name}) async {
    emit(SessionControllerInvitationLoading());
    try {
      await _authRepository.sendInvitation(email, name);

      emit(const SessionControllerInvitationSent());
    } catch (e) {
      emit(SessionControllerInvitationError(e));
    }
  }

  void sendVerificationCode(
      {required String value,
      required bool isSignUpWithEmail,
      required String codeNumber}) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.sendVerificationCode(
          value, isSignUpWithEmail, codeNumber);

      emit(const SessionControllerVerificationSent());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void reSendVerificationCode() async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.reSendVerificationCode();

      emit(const SessionControllerVerificationReSent());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void verifyCode(String code) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.verifyCode(code);

      emit(const SessionControllerCodeVerified());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void signUp(SignUpBody body) async {
    emit(SessionControllerLoading());
    try {
      var response = await _authRepository.signUp(body);

      emit(SessionControllerSignedUp(response!));
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void sendResetPasswordCode(
      {required String resetValue,
      required bool isEmail,
      required String codeNumber}) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.sendResetPasswordCode(
          resetValue, isEmail, codeNumber);

      emit(SessionControllerResetPasswordCodeSent());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void resendResetPasswordCode() async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.reSendResetPasswordCode();

      emit(SessionControllerResetPasswordCodeReSent());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void checkResetPasswordCode({required String code}) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.checkResetPasswordCode(code);

      emit(SessionControllerResetPasswordCodeChecked());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void resetPassword(
      {required String password, required String passwordConfirmation}) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.resetPassword(password, passwordConfirmation);

      emit(SessionControllerResetPasswordDone());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void createChangePassword(
      {required String password,
      required String passwordConfirmation,
      String? oldPassword}) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.createChangePassword(
          password: password,
          passwordConfirmation: passwordConfirmation,
          oldPassword: oldPassword);
      emit(SessionControllerCreateChangePasswordDone());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void deleteAccount({required String password}) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.deleteAccount(password);

      emit(SessionControllerDeleteAccountDone());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  void validateSignUpInfo({required SignUpBody body}) async {
    emit(SessionControllerLoading());
    try {
      await _authRepository.validateSignUpInfo(body);

      emit(SessionControllerSignUpInfoValidateDone());
    } catch (e) {
      emit(SessionControllerError(e));
    }
  }

  bool isLoggedIn() {
    return _authRepository.apiClient.isLoggedIn();
  }

  String getVerificationValue() {
    return _authRepository.tempVerificationValue;
  }

  String getCodeNumber() {
    return _authRepository.tempCodeNumber;
  }

  String getInviteCode() {
    return _authRepository.tempInvitationCode ?? '';
  }

  bool getIsSignUpWithEmail() {
    return _authRepository.tempIsSignUpWithEmail;
  }

  PickLocationModel? getCurrentLocation() {
    return _authRepository.getCurrentLocation();
  }

  PickLocationModel? getUserLocation() {
    return _authRepository.getUserLocation();
  }

  CountryModel? getAppCountry() {
    return _authRepository.getAppCountry();
  }

  int getIsKids() {
    return _authRepository.getIsKids();
  }

  void setIsKids(int isKids) {
    _authRepository.setIsKids(isKids);
  }

  void setCurrentLocation(PickLocationModel? currentLocation) {
    _authRepository.setCurrentLocation(currentLocation);
  }

  void setUserLocation(PickLocationModel? userLocation) {
    _authRepository.setUserLocation(userLocation);
  }

  void setAppCountry(CountryModel? appCountry) {
    _authRepository.setAppCountry(appCountry);
  }

  void signedUpNextPage() async {
    emit(SessionControllerInitial());
    emit(SessionControllerSignedUpNextPage());
  }

  void signedUpPreviousPage() async {
    emit(SessionControllerInitial());
    emit(SessionControllerSignedUpPreviousPage());
  }

  Future getAppConfig() async {
    try {
      final AppConfigModel? data = await _authRepository.getAppConfig();
      if (data != null) {
        AppData.reasonsList = data.reasonsList!;
        AppData.termOfUse = data.termOfUse.toString();
        AppData.privacyPolicy = data.privacyPolicy.toString();
        AppData.isUserProfileLocationRequired =
            data.isUserProfileLocationRequired;
        AppData.isUserProfileNationalityRequired =
            data.isUserProfileNationalityRequired;
        AppData.isUserProfileGenderRequired = data.isUserProfileGenderRequired;
        AppData.isUserProfileBirthDateRequired =
            data.isUserProfileBirthDateRequired;
        AppData.isShowBoostButton = data.isShowBoostButton;
        AppData.liftUpCoinRate = data.liftUpCoinRate;
        AppData.isShowGoogleButton = data.isShowGoogleButton;
        AppData.liftUps = data.liftUps;
      }
    } catch (e) {}
  }

  String getCurrency() {
    return _authRepository.getCurrency();
  }

  void setCurrency(String currency) {
    _authRepository.setCurrency(currency);
  }
}
