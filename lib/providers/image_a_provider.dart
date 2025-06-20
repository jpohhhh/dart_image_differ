import 'package:dart_image_differ/image/image_rgba.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_a_provider.g.dart';

@Riverpod(keepAlive: true)
class ImageA extends _$ImageA {
  @override
  ImageRgba? build() {
    return null;
  }

  void setImage(ImageRgba? image) {
    state = image;
  }
}