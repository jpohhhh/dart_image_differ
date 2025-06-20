import 'package:dart_image_differ/providers/image_a_provider.dart';
import 'package:dart_image_differ/providers/image_b_provider.dart';
import 'package:dart_image_differ/providers/image_diff_provider.dart';
import 'package:dart_image_differ/widgets/image_upload_row.dart';
import 'package:dart_image_differ/widgets/overlay_comparison_section.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const padding = 16.0;
    final diffImage = ref.watch(imageDiffImageProviderProvider).valueOrNull;
    final imageAProvider = ref.watch(imageAImageProviderProvider);
    final imageBProvider = ref.watch(imageBImageProviderProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image upload wells
              ImageUploadRow(),

              // Overlay comparison section
              if (imageAProvider != null && imageBProvider != null)
                OverlayComparisonSection(
                  imageAProvider: imageAProvider,
                  imageBProvider: imageBProvider,
                  diffImage: diffImage,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
