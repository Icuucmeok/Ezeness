import 'package:flutter/material.dart';
import 'package:media_library/core/entity/media_file.dart';
import 'package:media_library/src/controller/loading_controller.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../core/enums.dart';
import '../../controller/media_controller.dart';

class GalleryPickerButton extends StatelessWidget {
  final RequestType requestType;
  const GalleryPickerButton({super.key, this.requestType = RequestType.common});

  @override
  Widget build(BuildContext context) {
    return Selector<MediaController, MediaFile?>(
      selector: (context, mediaController) {
        return mediaController.firstImage;
      },
      builder: (context, firstImage, child) {
        if (firstImage != null) {
          return GestureDetector(
            onTap: () async {
              await pickImages(context);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.grey, // Border color
                  width: 2.0, // Border width
                ),

                image: DecorationImage(
                  image: MemoryImage(firstImage.unit!),
                  fit: BoxFit.cover,
                ),
                // color: Colors.transparent,
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: IconButton(
              onPressed: () async {
                await pickImages(context);
              },
              icon: Icon(
                Icons.photo_library,
                color: Colors.grey[300],
                size: 30,
              )),
        );
      },
    );
  }

  Future<void> pickImages(BuildContext context) async {
    final mediaController = context.read<MediaController>();
    final loadingController = context.read<LoadingController>();
    List<AssetEntity>? selectedAssets = [];

    mediaController.pickedFiles.map((e) {
      if (e.assetSourceType == AssetSourceType.gallery) {
        selectedAssets.add(e.assetEntity);
      }
    }).toList();
    loadingController.toggleAddingGalleryPicsLoading();

    final resultList = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        requestType: requestType,
        loadingIndicatorBuilder: (context, isAssetsEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
        maxAssets: mediaController.maxAssets! -
            (mediaController.pickedFiles.length - selectedAssets.length) -
            mediaController.editedImagesLength,
        previewThumbnailSize: const ThumbnailSize(3000, 3000),
        gridThumbnailSize: const ThumbnailSize(120, 120),
        pathThumbnailSize: const ThumbnailSize(300, 300),
        gridCount: 3,
        pageSize: 9, // Adjust the pageSize to be a multiple of gridCount
        selectedAssets: selectedAssets,
        selectPredicate: (context, asset, isSelected) async {
          if (isSelected) {
            if (selectedAssets.contains(asset)) {
              return false;
            }

            return true;
          }
          return true;
        },
      ),
    );
    if (resultList != null) {
      // Check if the asset is an image or video
      for (var asset in resultList) {
        final file = await asset.file;
        final unit = await asset.originBytes;
        await mediaController.addPickedFile(
          MediaFile.fromFile(file!,
              assetEntity: asset,
              unit: unit,
              assetSourceType: AssetSourceType.gallery),
        );
      }
    }
    loadingController.toggleAddingGalleryPicsLoading();

    if (mediaController.pickedFiles.isNotEmpty) {
      // Toggle preview mode
      context.read<MediaController>().setScreenView(view: ScreenView.preview);
    }
  }
}
