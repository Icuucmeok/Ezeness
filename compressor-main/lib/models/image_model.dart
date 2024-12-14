import 'dart:typed_data';

class ImageModel {
  final Uint8List image;
  final int imgX;
  final int imgY;
  final int imgWidth;
  final int imgHeight;

  ImageModel(this.image, this.imgX, this.imgY, this.imgWidth, this.imgHeight);
}
