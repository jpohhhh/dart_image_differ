import 'package:dart_image_differ/widgets/image_well.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const padding = 16.0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(padding),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ImageWell(title: 'Image A', setImage: () {}),
            ),
            SizedBox(width: padding),
            Expanded(
              child: ImageWell(
                title: 'Image B',
                setImage: () {
                  // Implement the logic to set the image
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
