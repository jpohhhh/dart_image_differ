import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageRgba {
  int width;
  int height;
  Uint32List bytes;

  ImageRgba({required this.width, required this.height, required this.bytes});

  Future<ImageProvider> toImageProvider() async {
    @pragma('vm:awaiter-link')
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      bytes.buffer.asUint8List(),
      width,
      height,
      ui.PixelFormat.rgba8888,
      (result) => completer.complete(result),
    );
    final image = await completer.future;

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    return MemoryImage(pngBytes);
  }
}
