import 'package:compressor/models/color_model.dart';
import 'package:compressor/models/image_model.dart';

import 'compressor_platform_interface.dart';

class Compressor {
  static Future<String?> compressVideo(String inputPath, String outputPath) {
    return CompressorPlatform.instance.compressVideo(inputPath, outputPath);
  }

  static Future<String?> trimVideo(
      String inputPath, String outputPath, double startTime, double endTime) {
    return CompressorPlatform.instance
        .trimVideo(inputPath, outputPath, startTime, endTime);
  }

  static Future<String?> exportCover(
      String inputPath, String outputPath, double coverTime) {
    return CompressorPlatform.instance
        .exportCover(inputPath, outputPath, coverTime);
  }

  static Future<String?> addOverlays(
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
    return CompressorPlatform.instance.addOverlays(
      videoPath,
      outputPath,
      image: image,
      text: text,
      textX: textX,
      textY: textY,
      fontFilePath: fontFilePath,
      fontSize: fontSize,
      fontColor: fontColor,
      shapeX: shapeX,
      shapeY: shapeY,
      shapeWidth: shapeWidth,
      shapeHeight: shapeHeight,
      shapeColor: shapeColor,
    );
  }

  static Future<String?> addFilterVideo(
    String videoPath,
    String outputPath,
    ColorModel color,
  ) {
    return CompressorPlatform.instance
        .addFilterVideo(videoPath, outputPath, color);
  }
}
