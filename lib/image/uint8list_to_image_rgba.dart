import 'dart:typed_data';

import 'package:dart_image_differ/image/image_provider_to_image_rgba.dart';
import 'package:dart_image_differ/image/image_rgba.dart';
import 'package:flutter/material.dart';

Future<ImageRgba?> uint8listToRgba(Uint8List? bytes) {
  if (bytes == null || bytes.isEmpty) {
    return Future.value(null);
  }

  try {
    return imageProviderToRgba(
      MemoryImage(bytes),
    );
  } catch (e) {
    debugPrint('Error converting Uint8List to ImageRgba: $e');
    return Future.value(null);
  }
}
