import 'dart:io';
import 'dart:typed_data';

import 'package:media_library/core/enums.dart';
import 'package:media_library/core/extension/extensions.dart';
import 'package:media_library/src/widgets/image_editor/vs_story_designer/src/domain/models/editable_items.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editable_item_type.dart';
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
    // List<VideoEditableItem>? newList = null;
    if (videoEditableItem != null) {
      // final newList = this.videoEditableItems;
      // newList?.add(videoEditableItems);
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
}