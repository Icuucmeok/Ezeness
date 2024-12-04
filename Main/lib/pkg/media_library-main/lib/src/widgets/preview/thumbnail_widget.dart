import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ThumbnailWidget extends StatelessWidget {
  final AssetEntity assetEntity;

  const ThumbnailWidget({
    Key? key,
    required this.assetEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: fetchThumbnailData(assetEntity, 100, 100),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final thumbnailData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.memory(
              thumbnailData,
              width: 50,
              height: 25,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<Uint8List?> fetchThumbnailData(
      AssetEntity assetEntity, int width, int height) async {
    try {
      // Load the thumbnail data directly from assetEntity.thumbData
      final thumbnailData = await assetEntity.thumbnailDataWithOption(
        ThumbnailOption(
          size: ThumbnailSize(width, height),
        ),
      );
      return thumbnailData;
    } catch (e) {
      return null;
    }
  }
}
