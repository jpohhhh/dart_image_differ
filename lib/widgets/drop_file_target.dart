import 'dart:async';
import 'dart:typed_data';

import 'package:dart_image_differ/misc/border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:libmonet/contrast.dart';
import 'package:libmonet/hct.dart';
import 'package:libmonet/theming/monet_theme.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

typedef Uint8ListCallback = Function(Uint8List bytes);

class DropFileTarget extends HookConsumerWidget {
  final Widget child;
  final Uint8ListCallback? onImageDropped;

  const DropFileTarget({super.key, required this.child, this.onImageDropped});
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
          formats: kDropRegionSupportedFormats,
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
          onPerformDrop: (event) async {
            showOverlay.value = false;
            final bytes = await onPerformDropHandler(context, ref, event);
            if (bytes != null && onImageDropped != null) {
              onImageDropped!(bytes);
            }
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

const kDropRegionSupportedFormats = <DataFormat<Object>>[
  Formats.uri,
  Formats.png,
  Formats.jpeg,
  Formats.webp,
];

Future<Uint8List?> onPerformDropHandler(
  BuildContext context,
  WidgetRef ref,
  PerformDropEvent event,
) async {
  try {
    // Process the first item in the drop event
    if (event.session.items.isNotEmpty) {
      final dropItem = event.session.items.first;
      return await bytesForImageDropItem(dropItem);
    }
  } catch (e) {
    debugPrint('Error processing dropped file: $e');
  }
  return null;
}

DataFormat? formatForDropItem(DropItem dropItem) {
  final allFormats = dropItem.dataReader?.getFormats(
    kDropRegionSupportedFormats,
  );
  if (allFormats == null) {
    return null;
  }
  final topProviderFormat = allFormats.firstOrNull;
  if (topProviderFormat == null) {
    return null;
  }
  final topFormat =
      (topProviderFormat == Formats.plainText &&
          allFormats.contains(Formats.uri))
      ? Formats.uri
      : topProviderFormat;
  return topFormat;
}

Future<Uint8List> bytesForImageDropItem(DropItem dropItem) {
  @pragma('vm:awaiter-link')
  final completer = Completer<Uint8List>();
  final topFormat = formatForDropItem(dropItem);
  if (topFormat == null) {
    // There is no reason to use Magika here, the caller only sends drop items
    // that have a format that matches the image formats.
    completer.completeError('no formats', StackTrace.current);
    return completer.future;
  }

  if (topFormat is ValueFormat) {
    dropItem.dataReader?.getValue(
      topFormat,
      (image) async {
        if (image is Uint8List) {
          completer.complete(image);
        } else {
          completer.completeError(
            'image is not a Uint8List',
            StackTrace.current,
          );
        }
      },
      onError: (value) {
        completer.completeError(value, StackTrace.current);
      },
    );
  } else if (topFormat is FileFormat) {
    dropItem.dataReader?.getFile(
      topFormat,
      (file) async {
        final bytes = await file.readAll();

        completer.complete(bytes);
      },
      onError: (value) {
        completer.completeError(value, StackTrace.current);
      },
    );
  } else {
    completer.completeError(
      'unsupported format: $topFormat',
      StackTrace.current,
    );
  }
  return completer.future;
}
