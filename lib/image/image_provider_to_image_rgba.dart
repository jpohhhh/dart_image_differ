import 'dart:async';
import 'dart:ui' as ui;

import 'package:dart_image_differ/image/image_rgba.dart';
import 'package:flutter/material.dart';


Future<ImageRgba> imageProviderToRgba(ImageProvider imageProvider) {
  // Resize image added:
  // - Test image: PNG 4016x6016 from Unsplash. 8.5 MB.
  // - Time for ImageStreamListener to fire: 340 ms instead of 480 ms.
  // - M2 Macbook Air on 2024 Jan 3.

  final stream = imageProvider.resolve(const ImageConfiguration());
  // rationale, false positive, compiler complains it might not be set
  // within the block passed to ImageStreamListener.
  // ignore: avoid-unnecessary-local-late
  late ImageStreamListener listener;
  @pragma('vm:awaiter-link')
  final completer = Completer<ImageRgba>();
  final sw = Stopwatch()..start();
  void handleResult(ImageInfo frame) async {
    try {
      stream.removeListener(listener);
      final image = frame.image;
      final width = image.width;
      final height = image.height;

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      if (byteData == null) {
        completer.completeError(
          'Failed to scale image. ByteData is null.',
          StackTrace.current,
        );
        frame.dispose();
        return;
      }
      sw.stop();
      completer.complete(
        ImageRgba(
          width: width,
          height: height,
          bytes: byteData.buffer.asUint32List(),
        ),
      );
      frame.dispose();
    } catch (e, s) {
      completer.completeError(
        'imageProviderToRgba: Failed to scale image. Error receieved: $e',
        s,
      );
      frame.dispose();
    }
  }

  listener = ImageStreamListener(
    (frame, sync) {
      handleResult(frame);
    },
    onError: (e, stack) {
      completer.completeError(
        'imageProviderToRgba: Failed to scale image. Error receieved: $e',
        stack,
      );
    },
  );
  stream.addListener(listener);
  return completer.future;
}
