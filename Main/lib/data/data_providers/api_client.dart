import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:ezeness/data/models/pick_location_model.dart';
import 'package:ezeness/data/repositories/app_config_repository.dart';
import 'package:ezeness/data/utils/api_deserializer.dart';
import 'package:ezeness/data/utils/errors.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Directory, File, Platform;
import '../../pkg/media_library-main/lib/pkg/compressor-main/lib/compressor.dart';
import '../models/app_file.dart';
import '../models/auth/login_response.dart';
import '../models/country_model.dart';

class ApiClient {
  late final http.Client httpClient;
  late final SharedPreferences prefs;

  LoginResponse? _loginResponse;
  String? _languageCode;
  int isKids = 0;
  String currency = "AED";
  PickLocationModel? currentLocation;
  PickLocationModel? userLocation;
  CountryModel? appCountry;
  final String baseURL;
  final AppConfigRepository appConfigRepository;

  ApiClient({
    required this.baseURL,
    required String languageCode,
    required this.appConfigRepository,
  }) {
    httpClient = http.Client();
    _languageCode = languageCode;
  }

  // setters
  void setLanguageCode(String code) {
    _languageCode = code;
  }

  set setLoginResponse(LoginResponse? loginResponse) {
    _loginResponse = loginResponse;
    _saveLoginResponse();
  }

  set setIsKids(int isKids) {
    this.isKids = isKids;
    prefs.setInt(Constants.isKidsKey, this.isKids);
  }

  set setCurrency(String currency) {
    this.currency = currency;
    prefs.setString(Constants.currencyKey, this.currency);
  }

  set setCurrentLocation(PickLocationModel? currentLocation) {
    this.currentLocation = currentLocation;
    if (currentLocation != null) {
      prefs.setString(
          Constants.currentLocationKey, this.currentLocation!.toJson());
    } else {
      prefs.remove(Constants.currentLocationKey);
    }
  }

  set setUserLocation(PickLocationModel? userLocation) {
    this.userLocation = userLocation;
    if (userLocation != null) {
      prefs.setString(Constants.userLocationKey, this.userLocation!.toJson());
    } else {
      prefs.remove(Constants.userLocationKey);
    }
  }

  set setAppCountry(CountryModel? appCountry) {
    this.appCountry = appCountry;
    if (appCountry != null) {
      prefs.setString(Constants.appCountryKey, this.appCountry!.toJson());
    } else {
      prefs.remove(Constants.appCountryKey);
    }
  }

// getters
  void get languageCode => _languageCode;

  LoginResponse? get loginResponse => _loginResponse;

  Map<String, String> head(
      {String? contentType,
      String? auth,
      String? token,
      int? isKids,
      bool withIsKids = true}) {
    return {
      "Authorization": auth ?? "Bearer ${token ?? loginResponse?.accessToken}",
      "Content-Type": contentType ?? "application/json",
      "Accept": "application/json",
      "Accept-Language": _languageCode!,
      if (currency != S.current.defaultCurrency) "currency": currency,
      if (withIsKids)
        "is_kids": isKids != null ? isKids.toString() : "${this.isKids}",
      if (currentLocation != null) ...{
        "lat": "${currentLocation?.lat}",
        "lng": "${currentLocation?.lng}",
      },
      "platform": Platform.isIOS ? "ios" : "android",
      "version": appConfigRepository.packageInfo.version,
      if (appCountry != null) "country": appCountry!.value,
    };
  }

  Future<R?> invokeApi<R>(
    String path, {
    HttpRequestType requestType = HttpRequestType.post,
    Map<String, String>? headers,
    Object? body,
    List<AppFile> files = const [],
    PostRequestType postRequestType = PostRequestType.none,
  }) async {
    var fullPath = path;
    final Uri url = Uri.parse('$baseURL$fullPath');
    late final http.Response response;
    Map<String, String> requestHeaders = headers ?? head();
    try {
      if (requestType == HttpRequestType.get) {
        response = await httpClient.get(url, headers: requestHeaders);
      } else if (requestType == HttpRequestType.put) {
        response =
            await httpClient.put(url, headers: requestHeaders, body: body);
      } else if (requestType == HttpRequestType.post) {
        if (postRequestType == PostRequestType.none) {
          response =
              await httpClient.post(url, headers: requestHeaders, body: body);
        } else if (postRequestType == PostRequestType.uploadFile) {
          Map<String, String> requestBody = {};
          (body as Map).forEach((key, value) {
            requestBody[key.toString()] = value.toString();
          });
          var request = http.MultipartRequest(
            'POST',
            url,
          );
          request.headers.addAll(requestHeaders);
          request.fields.addAll(requestBody);
          for (AppFile file in files) {
            if (Helpers.isVideoExtension(file.fileExtension!)) {
              // if Bigger than 3 MBs Then compress
              if (File(file.filePath!).lengthSync() >
                  10000000 /*&& Platform.isAndroid*/) {
                final Directory extDir =
                    await getApplicationDocumentsDirectory();
                final String dirPath = '${extDir.path}/compressed_videos';
                await Directory(dirPath).create(recursive: true);
                final String compressedPath = '$dirPath/compressed_video.mp4';

                final output = await Compressor.compressVideo(
                    file.filePath!, compressedPath);
                request.files.add(await http.MultipartFile.fromPath(
                  file.fileKey!,
                  output!,
                  filename: file.fileName,
                  contentType: MediaType(file.fileType!, file.fileExtension!),
                ));
              } else {
                request.files.add(await http.MultipartFile.fromPath(
                  file.fileKey!,
                  file.filePath!,
                  filename: file.fileName,
                  contentType: MediaType(file.fileType!, file.fileExtension!),
                ));
              }
            } else {
              request.files.add(await http.MultipartFile.fromPath(
                  '${file.fileKey}', '${file.filePath}',
                  filename: '${file.fileName}',
                  contentType:
                      MediaType('${file.fileType}', '${file.fileExtension}')));
            }
          }
          var streamResponse = await httpClient.send(request);

          response = await http.Response.fromStream(streamResponse);
        }
      } else if (requestType == HttpRequestType.delete) {
        response = await httpClient.delete(url, headers: requestHeaders);
      }
      // log('Request BODY $body');
      //log('Header $requestHeaders');
      log('ENDPOINT $path');
      //log('STATUS CODE ${response.statusCode}');
      // log('RESPONSE BODY ${response.body}');
      String source = const Utf8Decoder().convert(response.bodyBytes);
      if (response.statusCode == 401) {
        throw SessionExpiredException(message: S.current.sessionExpired);
      } else if (response.statusCode >= 400) {
        throw ServerException(message: jsonDecode(source)["message"]);
      }
      // log(source);
      return ApiDeserializer<R>(rawJson: source).deserialize() as R;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  bool isLoggedIn() {
    return _loginResponse != null;
  }

  Future<void> loadLoginResponse() async {
    prefs = await SharedPreferences.getInstance();
    var json = prefs.getString(Constants.loginResponseKey);
    _loginResponse =
        json == null ? null : LoginResponse.loadFromJson(jsonDecode(json));

    isKids = prefs.getInt(Constants.isKidsKey) ?? 0;
    currency = prefs.getString(Constants.currencyKey) ?? "AED";

    var currentLocationJson = prefs.getString(Constants.currentLocationKey);
    currentLocation = currentLocationJson == null
        ? null
        : PickLocationModel.fromJson(jsonDecode(currentLocationJson));

    var userLocationJson = prefs.getString(Constants.userLocationKey);
    userLocation = userLocationJson == null
        ? null
        : PickLocationModel.fromJson(jsonDecode(userLocationJson));

    var appCountryJson = prefs.getString(Constants.appCountryKey);
    appCountry = appCountryJson == null
        ? null
        : CountryModel.fromJson(jsonDecode(appCountryJson));
  }

  Future<void> removeLoginResponse() async {
    _loginResponse = null;
    isKids = 0;
    currency = "AED";
    currentLocation = null;
    userLocation = null;
    await prefs.remove(Constants.loginResponseKey);
    await prefs.remove(Constants.isKidsKey);
    await prefs.remove(Constants.currencyKey);
    await prefs.remove(Constants.currentLocationKey);
    await prefs.remove(Constants.userLocationKey);
    await prefs.remove(Constants.kUser);
    await prefs.remove(Constants.cartItemsKey);
  }

  void _saveLoginResponse() async {
    if (_loginResponse != null) {
      prefs.setString(Constants.loginResponseKey, loginResponse!.toJson());
    }
  }
}

enum HttpRequestType {
  get,
  post,
  delete,
  put,
}

enum PostRequestType {
  none,
  uploadFile,
}
