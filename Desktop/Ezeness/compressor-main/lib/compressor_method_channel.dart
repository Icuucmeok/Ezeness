import 'package:compressor/models/color_model.dart';
import 'package:compressor/models/image_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'compressor_platform_interface.dart';

/// An implementation of [CompressorPlatform] that uses method channels.
class MethodChannelCompressor extends CompressorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('video_compression');

  @override
  Future<String?> compressVideo(String inputPath, String outputPath) async {
    try {
      final Map<String, dynamic> params = {
        'inputPath': inputPath,
        'outputPath': outputPath,
      };
      final String? result =
          await methodChannel.invokeMethod('compressVideo', params);
      return result;
    } on PlatformException catch (e) {
      return 'Error: ${e.message}';
    }
  }

  @override
  Future<String?> trimVideo(String inputPath, String outputPath,
      double startTime, double endTime) async {
    try {
      final Map<String, dynamic> params = {
        'inputPath': inputPath,
        'outputPath': outputPath,
        'startTime': startTime,
        'endTime': endTime,
      };
      final String? result =
          await methodChannel.invokeMethod('trimVideo', params);
      return result;
    } on PlatformException catch (e) {
      return 'Error: ${e.message}';
    }
  }

  @override
  Future<String?> exportCover(
      String inputPath, String outputPath, double coverTime) async {
    try {
      final Map<String, dynamic> params = {
        'inputPath': inputPath,
        'outputPath': outputPath,
        'coverTime': coverTime,
      };
      final String? result =
          await methodChannel.invokeMethod('exportCover', params);
      return result;
    } on PlatformException catch (e) {
      return 'Error: ${e.message}';
    }
  }

  @override
  Future<String?> addOverlays(
    String videoPath,
    String outputPath, {
    ImageModel? image,
    String? text,
    int? textX,
    int? textY,
    String? fontFilePath,
    int? fontSize,
    String? fontColor,
    int? shapeX,
    int? shapeY,
    int? shapeWidth,
    int? shapeHeight,
    String? shapeColor,
  }) async {
    try {
      final Map<String, dynamic> params = {
        'videoPath': videoPath,
        'outputPath': outputPath,
        'imageData': image?.image,
        'imgX': image?.imgX,
        'imgY': image?.imgY,
        'imgWidth': image?.imgWidth,
        'imgHeight': image?.imgHeight,
        'text': text,
        'textX': textX,
        'textY': textY,
        'fontFilePath': fontFilePath,
        'fontSize': fontSize,
        'fontColor': fontColor,
        'shapeX': shapeX,
        'shapeY': shapeY,
        'shapeWidth': shapeWidth,
        'shapeHeight': shapeHeight,
        'shapeColor': shapeColor,
      };
      final String? result =
          await methodChannel.invokeMethod('addOverlays', params);
      return result;
    } on PlatformException catch (e) {
      return 'Error: ${e.message}';
    }
  }

  @override
  Future<String?> addFilterVideo(
      String videoPath, String outputPath, ColorModel color) async {
    try {
      final Map<String, dynamic> params = {
        'videoPath': videoPath,
        'outputPath': outputPath,
        'red': color.redValue,
        'green': color.greenValue,
        'blue': color.blueValue,
      };
      final String? result =
          await methodChannel.invokeMethod('addFilterVideo', params);
      return result;
    } on PlatformException catch (e) {
      return 'Error: ${e.message}';
    }
  }
}
