import 'package:compressor/models/image_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import "dart:typed_data";
import "dart:ui";

import 'compressor_method_channel.dart';
import 'models/color_model.dart';

abstract class CompressorPlatform extends PlatformInterface {
  CompressorPlatform() : super(token: _token);

  static final Object _token = Object();

  static CompressorPlatform _instance = MethodChannelCompressor();

  static CompressorPlatform get instance => _instance;

  static set instance(CompressorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> compressVideo(String inputPath, String outputPath) {
    throw UnimplementedError('compressVideo() has not been implemented.');
  }

  Future<String?> trimVideo(
      String inputPath, String outputPath, double startTime, double endTime) {
    throw UnimplementedError('trimVideo() has not been implemented.');
  }

  Future<String?> exportCover(
      String inputPath, String outputPath, double coverTime) {
    throw UnimplementedError('exportCover() has not been implemented.');
  }

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
  }) {
    throw UnimplementedError('addOverlays() has not been implemented.');
  }

  Future<String?> addFilterVideo(
    String videoPath,
    String outputPath,
    ColorModel color,
  ) {
    throw UnimplementedError('addFilterVideo() has not been implemented.');
  }
}
