import 'dart:typed_data';

import 'package:dart_image_differ/image/image_rgba.dart';
import 'package:dart_image_differ/providers/image_a_provider.dart';
import 'package:dart_image_differ/providers/image_b_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_diff_provider.g.dart';

@Riverpod(keepAlive: true)
class ImageDiffRgba extends _$ImageDiffRgba {
  @override
  Future<ImageRgba?> build() async {
    final imageAFuture = ref.watch(imageARgbaProvider);
    final imageBFuture = ref.watch(imageBRgbaProvider);
    final imageA = imageAFuture.valueOrNull;
    final imageB = imageBFuture.valueOrNull;
    if (imageA == null || imageB == null) {
      return null; // One or both images are not available
    }

    return _computeDifference(imageA, imageB);
  }

  ImageRgba _computeDifference(ImageRgba imageA, ImageRgba imageB) {
    // Ensure both images have the same dimensions
    if (imageA.width != imageB.width || imageA.height != imageB.height) {
      throw ArgumentError(
        'Images must have the same dimensions for comparison',
      );
    }

    final width = imageA.width;
    final height = imageA.height;
    final diffBytes = Uint32List(width * height);

    for (int i = 0; i < diffBytes.length; i++) {
      final pixelA = imageA.bytes[i];
      final pixelB = imageB.bytes[i];

      // Extract RGBA components
      final rA = (pixelA >> 0) & 0xFF;
      final gA = (pixelA >> 8) & 0xFF;
      final bA = (pixelA >> 16) & 0xFF;
      final aA = (pixelA >> 24) & 0xFF;

      final rB = (pixelB >> 0) & 0xFF;
      final gB = (pixelB >> 8) & 0xFF;
      final bB = (pixelB >> 16) & 0xFF;
      final aB = (pixelB >> 24) & 0xFF;

      // Check if any channel differs by more than 1
      final isDifferent =
          (rA - rB).abs() > 1 ||
          (gA - gB).abs() > 1 ||
          (bA - bB).abs() > 1 ||
          (aA - aB).abs() > 1;

      final int diffPixel;
      if (isDifferent) {
        // Create difference pixel (using max alpha for visibility)
        diffPixel = 0xFF0000FF;
      } else {
        // If pixels are the same or differ by 1 or less, set to transparent
        diffPixel = 0x00000000; // Fully transparent
      }

      diffBytes[i] = diffPixel;
    }

    return ImageRgba(width: width, height: height, bytes: diffBytes);
  }
}

@Riverpod(keepAlive: true)
class ImageDiffImageProvider extends _$ImageDiffImageProvider {
  @override
  Future<ImageProvider?> build() {
    final rgba = ref.watch(imageDiffRgbaProvider).valueOrNull;
    if (rgba == null) {
      return Future.value(null);
    }
    return rgba.toImageProvider();
  }
}
