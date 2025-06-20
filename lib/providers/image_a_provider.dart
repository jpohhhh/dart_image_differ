import 'dart:typed_data';

import 'package:dart_image_differ/image/image_provider_to_image_rgba.dart';
import 'package:dart_image_differ/image/image_rgba.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_a_provider.g.dart';

@Riverpod(keepAlive: true)
class ImageAUint8List extends _$ImageAUint8List {
  @override
  Uint8List? build() {
    return null;
  }

  void setUint8List(Uint8List? image) async {
    state = image;
  }
}

@Riverpod(keepAlive: true)
class ImageAImageProvider extends _$ImageAImageProvider {
  @override
  ImageProvider? build() {
    final uint8List = ref.watch(imageAUint8ListProvider);
    if (uint8List != null) {
      return MemoryImage(uint8List);
    }
    return null;
  }
}

@Riverpod(keepAlive: true)
class ImageARgba extends _$ImageARgba {
  @override
  Future<ImageRgba?> build() {
    final imageProvider = ref.watch(imageAImageProviderProvider);
    if (imageProvider != null) {
      return imageProviderToRgba(imageProvider);
    }
    return Future.value(null);
  }
}
