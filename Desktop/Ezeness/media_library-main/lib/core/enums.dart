enum AssetSourceType { camera, shared, gallery, imageEditor }

enum ScreenView {
  camera,
  videoTrimmer,
  preview,
  imageEditor,
  videoEDitorGraphicalView;

  String get title {
    switch (this) {
      case ScreenView.camera:
        return 'Camera';
      case ScreenView.videoTrimmer:
        return 'Video Trimmer';
      case ScreenView.preview:
        return 'Preview';
      case ScreenView.imageEditor:
        return 'Image Editor';
      case ScreenView.videoEDitorGraphicalView:
        return 'Video Editor Graphical View';
    }
  }
}
