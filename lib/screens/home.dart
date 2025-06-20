import 'package:dart_image_differ/providers/image_a_provider.dart';
import 'package:dart_image_differ/providers/image_b_provider.dart';
import 'package:dart_image_differ/providers/image_diff_provider.dart';
import 'package:dart_image_differ/widgets/image_well.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const padding = 16.0;
    final diffImage = ref.watch(imageDiffImageProviderProvider).valueOrNull;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ImageWell(
                      title: 'Image A',
                      imageProvider: ref.watch(imageAImageProviderProvider),
                      setImage: (bytes) {
                        ref
                            .read(imageAUint8ListProvider.notifier)
                            .setUint8List(bytes);
                      },
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: ImageWell(
                      title: 'Image B',
                      imageProvider: ref.watch(imageBImageProviderProvider),
                      setImage: (bytes) {
                        ref
                            .read(imageBUint8ListProvider.notifier)
                            .setUint8List(bytes);
                      },
                    ),
                  ),
                ],
              ),
              if (diffImage != null) SizedBox(height: padding),
              if (diffImage != null) Image(image: diffImage),
            ],
          ),
        ),
      ),
    );
  }
}
