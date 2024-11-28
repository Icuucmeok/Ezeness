import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../../res/app_res.dart';
import '../models/user/user.dart';

class AppConfigRepository {
  late SharedPreferences prefs;
  late User user;
  late PackageInfo packageInfo;


  setUser(User newUser) async {
    user = newUser;
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.kUser, user.toJson());
  }




// locale section
  Locale _locale = const Locale('en');
  static const String _languageKey = 'language-key';
  bool _isEnglish = false;
  bool _isRTL = true;

  bool get isEnglish => _isEnglish;
  bool get isRTL => _isRTL;
  late bool _isFirstLaunch;
  Locale get locale => _locale;
  bool get isFirstLaunch => _isFirstLaunch;

  void setLocale(String locale) async {
    _locale = Locale(locale);
    await S.load(Locale(locale));
    _isEnglish = _locale.languageCode == 'en';
    _isRTL = Bidi.isRtlLanguage(_locale.languageCode);
    prefs.setString(_languageKey, locale);
  }

  // initiliaze all requirements
  Future<void> initializeApp() async {
    prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(_languageKey);
    // DEFAULT LANGUAGE CODE
    _locale = Locale(languageCode ?? 'en');
    _isEnglish = _locale.languageCode == 'en';
    _isRTL = Bidi.isRtlLanguage(_locale.languageCode);
    _isFirstLaunch = prefs.getBool(Constants.firstLaunchKey) ?? true;
     packageInfo = await PackageInfo.fromPlatform();
    var jsonUser=prefs.getString(Constants.kUser);
    user=jsonUser==null?User():User.fromJson(jsonDecode(jsonUser));
  }

  void setFirstLaunchToFalse() async {
    _isFirstLaunch=false;
    prefs.setBool(Constants.firstLaunchKey, _isFirstLaunch);
  }
  VoidCallback? discoverScreenGoUp;
  VoidCallback? exploreScreenGoUp;
  VoidCallback? panelScreenOnTapLogo;
}
