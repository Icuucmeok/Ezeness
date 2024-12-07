import 'package:ezeness/data/repositories/app_config_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../data/models/user/user.dart';

part 'app_config_state.dart';

class AppConfigCubit extends Cubit<AppConfigState> {
  final AppConfigRepository _appConfigRepository;
  AppConfigCubit(this._appConfigRepository)
      : super(
    AppConfigState(
      languageCode: _appConfigRepository.locale.languageCode,
      user: _appConfigRepository.user,
    ),
  );

  void setLocale(String languageCode) async {
    _appConfigRepository.setLocale(languageCode);
    emit(
      AppConfigState(
        languageCode: _appConfigRepository.locale.languageCode,
        user: _appConfigRepository.user,
      ),
    );
  }

  void setUser(User user,{bool isEditTheme=false}) async {
    if(isEditTheme){
      _appConfigRepository.setUser(user);
    }else{
      _appConfigRepository.setUser(user.copyWith(themeMood:_appConfigRepository.user.themeMood));
    }

    emit(
      AppConfigState(
        languageCode: _appConfigRepository.locale.languageCode,
        user: _appConfigRepository.user,
      ),
    );
  }

  User getUser() {
    return _appConfigRepository.user;

  }

  bool isEn(){
    return _appConfigRepository.isEnglish;
  }
  void setDiscoverScreenGoUp(VoidCallback goUp){
    _appConfigRepository.discoverScreenGoUp=goUp;
  }
  void discoverScreenGoUp(){
    if(_appConfigRepository.discoverScreenGoUp!=null)
      _appConfigRepository.discoverScreenGoUp!();
  }
  void seExploreScreenGoUp(VoidCallback goUp){
    _appConfigRepository.exploreScreenGoUp=goUp;
  }
  void exploreScreenGoUp(){
    if(_appConfigRepository.exploreScreenGoUp!=null)
      _appConfigRepository.exploreScreenGoUp!();
  }

  void setPanelScreenOnTapLogo(VoidCallback onTap){
    _appConfigRepository.panelScreenOnTapLogo=onTap;
  }
  void panelScreenOnTapLogo(){
    if(_appConfigRepository.panelScreenOnTapLogo!=null)
      _appConfigRepository.panelScreenOnTapLogo!();
  }
  PackageInfo getPackageInfo(){
    return _appConfigRepository.packageInfo;
  }
  void setFirstLaunchToFalse(){
    _appConfigRepository.setFirstLaunchToFalse();
  }
  bool getIsFirstLaunch(){
    return _appConfigRepository.isFirstLaunch;
  }
}
