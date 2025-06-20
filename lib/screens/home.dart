import 'package:dart_image_differ/widgets/drop_file_target.dart';
import 'package:dart_image_differ/widgets/image_well.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:libmonet/theming/monet_theme.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captionStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: MonetTheme.of(context).primary.fillText,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DropFileTarget(
                child: ImageWell(child: Text('Image A', style: captionStyle)),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: DropFileTarget(
                child: ImageWell(child: Text('Image B', style: captionStyle)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
