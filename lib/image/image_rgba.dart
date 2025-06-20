import 'dart:typed_data';

class ImageRgba {
  int width;
  int height;
  Uint32List bytes;

  ImageRgba({required this.width, required this.height, required this.bytes});
}
