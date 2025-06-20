import 'package:dart_image_differ/providers/image_a_provider.dart';
import 'package:dart_image_differ/providers/image_b_provider.dart';
import 'package:dart_image_differ/widgets/image_well.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImageUploadRow extends HookConsumerWidget {
  const ImageUploadRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const padding = 16.0;
    final imageAProvider = ref.watch(imageAImageProviderProvider);
    final imageBProvider = ref.watch(imageBImageProviderProvider);

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ImageWell(
            title: 'Image A',
            imageProvider: imageAProvider,
            setImage: (bytes) {
              ref.read(imageAUint8ListProvider.notifier).setUint8List(bytes);
            },
          ),
        ),
        SizedBox(width: padding),
        Expanded(
          child: ImageWell(
            title: 'Image B',
            imageProvider: imageBProvider,
            setImage: (bytes) {
              ref.read(imageBUint8ListProvider.notifier).setUint8List(bytes);
            },
          ),
        ),
      ],
    );
  }
}