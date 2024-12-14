import 'package:flutter/foundation.dart';

class LoadingController extends ChangeNotifier {
  bool _isAddingGalleryPicsLoading = false;
  bool _isDeleteAssetLoading = false;
  bool _isVideoInitializing = false;
  bool get isAddingGalleryPicsLoading => _isAddingGalleryPicsLoading;
  bool get isDeleteAssetLoading => _isDeleteAssetLoading;
  bool get isVideoInitializing => _isVideoInitializing;

  void toggleAddingGalleryPicsLoading() {
    _isAddingGalleryPicsLoading = !_isAddingGalleryPicsLoading;
    notifyListeners();
  }

  void toggleDeleteAssetLoading() {
    _isDeleteAssetLoading = !_isDeleteAssetLoading;
    notifyListeners();
  }

  void toggleVideoInitializing(bool isVideoInitializing) {
    _isVideoInitializing = isVideoInitializing;
    notifyListeners();
  }
}
