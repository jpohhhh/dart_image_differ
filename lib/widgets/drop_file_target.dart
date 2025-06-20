import 'package:dart_image_differ/misc/border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:libmonet/contrast.dart';
import 'package:libmonet/hct.dart';
import 'package:libmonet/theming/monet_theme.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DropFileTarget extends HookConsumerWidget {
  final Widget child;

  const DropFileTarget({super.key, required this.child});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorHct = Hct.fromColor(MonetTheme.of(context).primary.color);
    const backgroundTone = 10.0;
    final contrastingTone = contrastingLstar(
      withLstar: backgroundTone + 10,
      usage: Usage.text,
      contrast: MonetTheme.of(context).contrast,
    );
    final headlineHct = Hct.from(
      colorHct.hue,
      colorHct.chroma,
      contrastingTone,
    );
    final bgHct = Hct.from(colorHct.hue, colorHct.chroma, backgroundTone);
    final overlayWidget = Material(
      color: bgHct.color.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: ShapeDecoration(
            shape: createShapeBorder(),
            color: bgHct.color,
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.attach_file,
                      size: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.fontSize,
                      color: headlineHct.color,
                    ),
                  ),
                ),
                TextSpan(
                  text: 'Drop image here.',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: headlineHct.color,
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.labelLarge?.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final showOverlay = useState(false);

    return Stack(
      children: [
        DropRegion(
          hitTestBehavior: HitTestBehavior.translucent,
          formats: [Formats.uri, Formats.png, Formats.jpeg, Formats.webp],
          onDropOver: (DropOverEvent event) {
            // You can inspect local data here, as well as formats of each item.
            // However on certain platforms (mobile / web) the actual data is
            // only available when the drop is accepted (onPerformDrop).
            //
            // This drop region only supports copy operation.
            if (event.session.allowedOperations.contains(DropOperation.copy)) {
              return DropOperation.copy;
            } else {
              return DropOperation.none;
            }
          },
          onDropEnter: (_) {
            showOverlay.value = true;
          },
          onDropLeave: (_) {
            showOverlay.value = false;
          },
          onPerformDrop: (event) {
            onPerformDropHandler(context, ref, event);
            return Future.value();
          },
          child: child,
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: showOverlay.value
              ? IgnorePointer(
                  key: const ValueKey('overlay'),
                  child: overlayWidget,
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }
}


Future<void> onPerformDropHandler(
  BuildContext context,
  WidgetRef ref,
  PerformDropEvent event,
) async {
  final items = event.session.items;
  if (items.isEmpty) {
    return Future.value();
  }

  // TODO:
  // final imageBytes = (await bytesForImageDropItems(
  //   imageItems,
  // )).nonNulls.toList();
  // final docIds = await docIdsForDropItems(docManager, docItems);



}
