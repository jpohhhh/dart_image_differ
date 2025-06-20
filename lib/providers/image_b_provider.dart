import 'dart:typed_data';

import 'package:dart_image_differ/image/image_provider_to_image_rgba.dart';
import 'package:dart_image_differ/image/image_rgba.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_b_provider.g.dart';

@Riverpod(keepAlive: true)
class ImageBUint8List extends _$ImageBUint8List {
  @override
  Uint8List? build() {
    return null;
  }

  void setUint8List(Uint8List? image) async {
    state = image;
  }
}

@Riverpod(keepAlive: true)
class ImageBImageProvider extends _$ImageBImageProvider {
  @override
  ImageProvider? build() {
    final uint8List = ref.watch(imageBUint8ListProvider);
    if (uint8List != null) {
      return MemoryImage(uint8List);
    }
    return null;
  }
}

@Riverpod(keepAlive: true)
class ImageBRgba extends _$ImageBRgba {
  @override
  Future<ImageRgba?> build() {
    final imageProvider = ref.watch(imageBImageProviderProvider);
    if (imageProvider != null) {
      return imageProviderToRgba(imageProvider);
    }
    return Future.value(null);
  }
}
