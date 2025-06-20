import 'package:dart_image_differ/widgets/overlay_comparison_viewer.dart';
import 'package:dart_image_differ/widgets/overlay_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:libmonet/theming/monet_theme.dart';
import 'package:libmonet/theming/monet_theme_data.dart';

class OverlayComparisonSection extends HookConsumerWidget {
  final ImageProvider imageAProvider;
  final ImageProvider imageBProvider;
  final ImageProvider? diffImage;

  const OverlayComparisonSection({
    super.key,
    required this.imageAProvider,
    required this.imageBProvider,
    this.diffImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const padding = 16.0;
    final overlayTransformationController = useState(
      TransformationController(),
    );
    final overlaySliderPosition = useState(0.5); // 0.0 = full A, 1.0 = full B
    final overlayTransformationUpdate = useState(
      0,
    ); // Counter to force divider line updates
    final showDiffOverlay = useState(
      true,
    ); // Whether to show diff overlay on slider comparison

    // Reset zoom when images change
    useEffect(() {
      overlayTransformationController.value.value = Matrix4.identity();
      return null;
    }, [diffImage, imageAProvider, imageBProvider]);

    return MonetTheme(
      monetThemeData: MonetThemeData.fromColor(
        backgroundTone: MonetTheme.of(context).backgroundTone,
        brightness: MonetTheme.of(context).brightness,
        color: MonetTheme.of(context).secondary.color,
      ),
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              SizedBox(height: padding * 3),
              Divider(
                thickness: 2,
                color: MonetTheme.of(context).primary.color,
              ),
              SizedBox(height: padding),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Compare',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Tooltip(
                        message:
                            '• Move the slider to reveal Image A (left) vs Image B (right)\n'
                            '• 0% = Full Image A, 100% = Full Image B, 50% = Half and half\n'
                            '• Zoom and pan to examine details closely\n'
                            '• Toggle "Show Diff Overlay" to overlay the difference visualization',
                        child: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: MonetTheme.of(context).primary.fill,
                        ),
                      ),
                    ],
                  ),
                  if (diffImage != null)
                    Row(
                      children: [
                        Text(
                          'Show Diff Overlay',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: MonetTheme.of(context).primary.text,
                          ),
                        ),
                        SizedBox(width: 8),
                        Switch(
                          value: showDiffOverlay.value,
                          onChanged: (value) {
                            showDiffOverlay.value = value;
                          },
                          activeColor: MonetTheme.of(context).primary.fill,
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: padding),

              // Overlay view with controls
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate the viewer size (400 height, full width available)
                  final viewerSize = Size(constraints.maxWidth, 400);

                  return Column(
                    children: [
                      // Zoom controls
                      OverlayControls(
                        overlayTransformationController:
                            overlayTransformationController,
                        overlaySliderPosition: overlaySliderPosition,
                        containerSize: viewerSize,
                        overlayTransformationUpdate:
                            overlayTransformationUpdate,
                      ),
                      SizedBox(height: 16),

                      // Interactive viewer
                      OverlayComparisonViewer(
                        imageAProvider: imageAProvider,
                        imageBProvider: imageBProvider,
                        diffImage: diffImage,
                        overlayTransformationController:
                            overlayTransformationController,
                        overlaySliderPosition: overlaySliderPosition,
                        overlayTransformationUpdate:
                            overlayTransformationUpdate,
                        showDiffOverlay: showDiffOverlay,
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
