import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:media_library/core/enums.dart';
import 'package:media_library/core/extension/extensions.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/models/graphic_info.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MediaFile {
  final String id;
  final String name;
  final String path;
  final String type;
  final int? size;
  final String? thumbnailUrl;
  final Uint8List? unit;
  final AssetEntity assetEntity;
  final AssetType assetType;
  final AssetSourceType? assetSourceType;
  final List<VideoEditableItem>? videoEditableItems;

  const MediaFile({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    this.size,
    this.thumbnailUrl,
    required this.assetEntity,
    this.unit,
    required this.assetType,
    required this.assetSourceType,
    this.videoEditableItems,
  });

  factory MediaFile.fromFile(
    File file, {
    Uint8List? unit,
    AssetEntity? assetEntity,
    AssetSourceType? assetSourceType,
    String? thumbnailUrl,
    List<VideoEditableItem>? videoEditableItems,
  }) {
    return MediaFile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: file.path.split('/').last,
        path: file.path,
        type: file.path.split('.').last,
        size: file.lengthSync(),
        assetType: file.isVideo() ? AssetType.video : AssetType.image,
        thumbnailUrl: thumbnailUrl,
        assetSourceType: assetSourceType ?? (AssetSourceType.camera),
        assetEntity: assetEntity ??
            AssetEntity(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                typeInt: file.isVideo() ? 2 : 1,
                width: 1920,
                height: 1080),
        unit: unit,
        videoEditableItems: videoEditableItems);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'type': type,
      'size': size,
      'thumbnailUrl': thumbnailUrl,
      'unit': unit
    };
  }

  // copy with
  MediaFile copyWith({
    String? id,
    String? name,
    String? path,
    String? type,
    int? size,
    String? thumbnailUrl,
    Uint8List? unit,
    AssetEntity? assetEntity,
    AssetType? assetType,
    AssetSourceType? assetSourceType,
    VideoEditableItem? videoEditableItem,
  }) {
    if (videoEditableItem != null) {
      videoEditableItems!.add(videoEditableItem);
    }

    return MediaFile(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      size: size ?? this.size,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      unit: unit ?? this.unit,
      assetEntity: assetEntity ?? this.assetEntity,
      assetType: assetType ?? this.assetType,
      assetSourceType: assetSourceType ?? this.assetSourceType,
      videoEditableItems: this.videoEditableItems,
    );
  }

  AssetEntity? getAssetEntity() {
    return assetEntity;
  }

  File? getFile() {
    return File(path);
  }

  /// Trims the video and saves to a new path.
  Future<String?> trimVideo({
    required int startTime,
    required int endTime,
  }) async {
    final String outputPath = path.replaceAll(
      RegExp(r'\.mp4$'),
      '_trimmed.mp4',
    );

    String command = "-i $path -ss $startTime -to $endTime -c copy $outputPath";
    await FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        print("Trimmed video saved at: $outputPath");
        return outputPath;
      } else {
        print("Error trimming video: ${await session.getFailStackTrace()}");
        return null;
      }
    });

    return outputPath;
  }
}


void main() async {
  final mediaFile = MediaFile.fromFile(File("/path/to/video.mp4"));

  // Trim video from 10 seconds to 30 seconds
  final trimmedVideoPath = await mediaFile.trimVideo(startTime: 10, endTime: 30);

  if (trimmedVideoPath != null) {
    print("Trimmed video saved at: $trimmedVideoPath");
  } else {
    print("Trimming failed.");
  }
}
