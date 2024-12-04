import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_library/core/entity/media_file.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../core/enums.dart';
import '../../core/extension/extensions.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/get_path.dart';
import '../../pkg/compressor-main/lib/compressor.dart';

class MediaController with ChangeNotifier, DiagnosticableTreeMixin {
  List<MediaFile> _pickedFiles = [];
  late final List<File> _sharedFiles;

  MediaFile? _firstImage;
  ScreenView _screenView = ScreenView.camera;
  int? _maxAssets;
  int _editedImagesLength = 0;
  int _currentPreviewIndex = 0;

  MediaFile? _selectedMediaItem;
  VideoPlayerController? _selectedVideoController;

  List<MediaFile> get pickedFiles => _pickedFiles;

  MediaFile? get selectedMediaItem => _selectedMediaItem;
  VideoPlayerController? get selectedVideoController =>
      _selectedVideoController;

  ScreenView get screenView => _screenView;

  MediaFile? get firstImage => _firstImage;

  int? get maxAssets => _maxAssets;
  int get editedImagesLength => _editedImagesLength;
  int get currentPreviewIndex => _currentPreviewIndex;
  MediaController(
      int maxAssets, int editedImagesLength, List<File> sharedFiles) {
    _maxAssets = maxAssets;
    _editedImagesLength = editedImagesLength;

    _sharedFiles = [...sharedFiles];
    if (sharedFiles.isNotEmpty) {
      for (File file in _sharedFiles) {
        final unit = file.readAsBytesSync();
        addPickedFile(
          MediaFile.fromFile(
            file,
            unit: unit,
            assetSourceType: AssetSourceType.shared,
          ),
        );
      }

      _screenView = ScreenView.preview;
    }
  }
  void setCurrentIndex(int index) {
    _currentPreviewIndex = index;
    notifyListeners();
  }

  Future<void> addPickedFile(
    MediaFile file,
  ) async {
    final exist = _pickedFiles.map((e) => e.path).contains(file.path);
    if (exist) return;

    if (file.isVideo()) {
      final outputPath = await PathProvider.outPutFile(isVideo: false);
      await Compressor.exportCover(file.path, outputPath!, 0).then((value) {
        _pickedFiles.add(MediaFile(
            id: file.id,
            name: file.name,
            path: file.path,
            type: file.type,
            thumbnailUrl: outputPath,
            assetEntity: file.assetEntity,
            assetType: file.assetType,
            unit: file.unit,
            assetSourceType: file.assetSourceType));
      });
    } else {
      _pickedFiles.add(MediaFile(
          id: file.id,
          name: file.name,
          path: file.path,
          type: file.type,
          unit: file.unit,
          assetEntity: file.assetEntity,
          assetType: file.assetType,
          assetSourceType: file.assetSourceType));
    }
    if (_pickedFiles.length == 1) {
      _selectedMediaItem = _pickedFiles[0];
    }
    _selectedMediaItem = _pickedFiles.last;

    notifyListeners();
  }

  void deletePickedFile(PageController pageController) {
    _pickedFiles.removeAt(_currentPreviewIndex);

    if (_pickedFiles.isEmpty) {
      _screenView = ScreenView.camera;
      _selectedMediaItem = null;
      _selectedVideoController?.dispose();
      _selectedVideoController = null;
      notifyListeners();
      return;
    }

    if (_currentPreviewIndex >= _pickedFiles.length) {
      _currentPreviewIndex = _pickedFiles.length - 1;
    }

    _selectedMediaItem = _pickedFiles[_currentPreviewIndex];
    if (_selectedMediaItem?.isVideo() == true) {
      _selectedVideoController?.dispose();
    }

    pageController.jumpToPage(_currentPreviewIndex);
    notifyListeners();
  }

  void clearPickedFiles() {
    _pickedFiles.clear();
    _screenView = ScreenView.camera;
    notifyListeners();
  }

  void openVideoEditor(int index, VideoPlayerController controller) {
    _selectedVideoController = controller;
    _selectedMediaItem = _pickedFiles[index];
    _screenView = ScreenView.videoTrimmer;

    notifyListeners();
  }

  void openImageEditor(int index, VideoPlayerController controller) {
    _selectedMediaItem = _pickedFiles[index];
    _screenView = ScreenView.imageEditor;
    notifyListeners();
  }

  void setScreenView({required ScreenView view}) {
    _screenView = view;
    notifyListeners();
  }

  void setSelectedMedia(int index) {
    _selectedMediaItem = _pickedFiles[index];
    _currentPreviewIndex = index;
    notifyListeners();
  }

  bool canAddMoreAssets() {
    return _maxAssets != null &&
        _maxAssets! > (_pickedFiles.length + _editedImagesLength);
  }

  Future<void> replaceCropImage(MediaFile? imageData) async {
    _pickedFiles[_currentPreviewIndex] = imageData!;
    _screenView = ScreenView.preview;
    notifyListeners();
  }

  void replaceEditedVideo(MediaFile file) async {
    final outputPath = await PathProvider.outPutFile(isVideo: false);

    await Compressor.exportCover(file.path, outputPath!, 0).then((value) {
      _pickedFiles[_currentPreviewIndex] = MediaFile(
          id: file.id,
          name: file.name,
          path: file.path,
          type: file.type,
          thumbnailUrl: value!,
          assetEntity: file.assetEntity,
          assetType: file.assetType,
          unit: file.unit,
          assetSourceType: file.assetSourceType);
    });

    _screenView = ScreenView.preview;
    notifyListeners();
  }

  void replaceCoverImage(Uint8List coverImage) async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(coverImage);
    _pickedFiles[_currentPreviewIndex] =
        _pickedFiles[_currentPreviewIndex].copyWith(thumbnailUrl: file.path);
    _screenView = ScreenView.preview;

    notifyListeners();
  }

  Future<void> fetchFirstImage() async {
    if (_firstImage != null) return;

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isNotEmpty) {
      final List<AssetEntity> photos =
          await albums[0].getAssetListPaged(page: 0, size: 1);
      final File? file = await photos[0].file;
      final Uint8List? unit = await photos[0].originBytes;
      if (photos.isNotEmpty) {
        _firstImage =
            MediaFile.fromFile(file!, unit: unit, assetEntity: photos[0]);

        notifyListeners();
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<MediaFile>('pickedFiles', pickedFiles));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MediaController && other.pickedFiles == pickedFiles;
  }

  @override
  int get hashCode => pickedFiles.hashCode;

  @override
  String toStringShort() {
    return 'MediaController';
  }
}
