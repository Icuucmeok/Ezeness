import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ezeness/presentation/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';

import '../../generated/l10n.dart';

class Helpers {
  Helpers._();

  static bool isTab(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  static bool isRTL(BuildContext context) {
    return Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
  }

  static bool isRtlText(String text) {
    return Bidi.detectRtlDirectionality(text);
  }

  static bool isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }

  static String getLanguageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  static void onGustTapButton() {
    AppToast(message: S.current.youHaveToSignInFirst).show();
  }

  static Future<void> launchURL(url, BuildContext context) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      AppSnackBar(message: e.toString(), context: context).showErrorSnackBar();
    }
  }

  static String getCurrencyName(String currency) {
    switch (currency) {
      case "IRR":
        return "تومان";
      default:
        return currency;
    }
  }

  static String getLanguageNameFromCode(String code) {
    switch (code) {
      case "ar":
        return "العربية";
      case "fa":
        return "فارسى";
      default:
        return "English";
    }
  }

  static bool isVideoExtension(String extension) {
    final videoExtensions = [
      'mp4',
      'mov',
      'wmv',
      'flv',
      'avi',
      'webm',
      'mkv',
      '3gp'
    ]; // Add more if needed
    return videoExtensions.contains(extension.toLowerCase());
  }

  static Future<File> urlToFile(String url, {String? path}) async {
    final http.Response responseData = await http.get(Uri.parse(url));
    var buffer = responseData.bodyBytes.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/${path != null ? path : 'img'}')
        .writeAsBytes(
            buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  static int getRandomNumber({int max = 100000}) {
    Random random = Random();
    return random.nextInt(max);
  }

  static double getPostWidgetWidth(BuildContext context) {
    return MediaQuery.of(context).size.width / 3;
  }

  static String removeDecimalZeroFormat(double n) {
    return n.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
  }

  static String handelMinuet(double min) {
    if (min >= 1440) {
      return "${(min / 1440).ceil()} Day${(min / 1440).ceil() > 1 ? "s" : ""}";
    }
    if (min >= 60) {
      return "${(min / 60).ceil()} Hours";
    }
    return "${min.ceil()} Min";
  }

  static Future<File> captureWidget(GlobalKey widgetKey) async {
    final RenderRepaintBoundary? boundary =
        widgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary!.toImage();

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$directory/photo.png');
    await imgFile.writeAsBytes(pngBytes);
    return imgFile;
  }

  static String numberFormatter(double number) {
    final oCcy = new NumberFormat("#,##0.##", "en_US");
    return oCcy.format(number);
  }

  static Future<String> getMyLocationCurrency(BuildContext context) async {
    String currency = "AED";
    try {
      Position position = await getCurrentLocation(context);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String? countryCode = placemarks[0].isoCountryCode;
      currency = getCurrencyFromCountryCode(countryCode.toString());
    } catch (_) {}
    return currency;
  }

  static Future<String> getMyLocationCurrencyFromLatLan(
      {required double latitude, required double longitude}) async {
    String currency = "AED";
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      String? countryCode = placemarks[0].isoCountryCode;
      currency = getCurrencyFromCountryCode(countryCode.toString());
    } catch (_) {}
    return currency;
  }

  static String getCurrencyFromCountryCode(String countryCode) {
    switch (countryCode) {
      case "US":
      case "EC":
      case "SV":
      case "MH":
      case "FM":
      case "PW":
      case "TL":
      case "ZW":
      case "VG":
      case "BQ":
      case "TC":
      case "IO":
      case "PA":
      case "PR":
        return "USD";
      case "AD":
      case "AT":
      case "BE":
      case "CY":
      case "EE":
      case "FI":
      case "FR":
      case "DE":
      case "GR":
      case "IE":
      case "IT":
      case "XK":
      case "LV":
      case "LT":
      case "LU":
      case "MT":
      case "MC":
      case "ME":
      case "NL":
      case "PT":
      case "SM":
      case "SK":
      case "SI":
      case "ES":
      case "VA":
        return "EUR";
      default:
        return "AED";
    }
  }

  static Future<Position> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppSnackBar(context: context).showLocationServiceDisabledSnackBar();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      AppSnackBar(context: context).showLocationPermanentlyDeniedSnackBar();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<String> getAddressFromLatLng(Position position) async {
    late Placemark place;
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placeMarks) {
      place = placeMarks[0];
    });
    return '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
  }

  static BoxShadow boxShadow(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: size.width * .007,
        blurRadius: size.width * .009,
        offset: Offset(size.width * .003, size.width * .01));
  }

  static EdgeInsets paddingInContainer(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return EdgeInsets.all(size.width * .03);
  }

  static SizedBox constVerticalDistance(double height, {double? space}) {
    return SizedBox(height: height * (space ?? .02));
  }
}
