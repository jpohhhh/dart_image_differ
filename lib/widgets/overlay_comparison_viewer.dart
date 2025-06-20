import 'package:dart_image_differ/misc/border.dart';
import 'package:dart_image_differ/widgets/right_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:libmonet/theming/monet_theme.dart';

class OverlayComparisonViewer extends HookWidget {
  final ImageProvider imageAProvider;
  final ImageProvider imageBProvider;
  final ImageProvider? diffImage;
  final ValueNotifier<TransformationController> overlayTransformationController;
  final ValueNotifier<double> overlaySliderPosition;
  final ValueNotifier<int> overlayTransformationUpdate;
  final ValueNotifier<bool> showDiffOverlay;

  const OverlayComparisonViewer({
    super.key,
    required this.imageAProvider,
    required this.imageBProvider,
    this.diffImage,
    required this.overlayTransformationController,
    required this.overlaySliderPosition,
    required this.overlayTransformationUpdate,
    required this.showDiffOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: ShapeDecoration(
        shape: createShapeBorder(color: MonetTheme.of(context).primary.fill),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;

            return InteractiveViewer(
              transformationController: overlayTransformationController.value,
              minScale: 1.0, // Don't zoom out below natural size
              maxScale: 10.0,
              onInteractionUpdate: (details) {
                // Force divider line rebuild when transformation changes via gestures
                overlayTransformationUpdate.value++;
              },
              child: SizedBox(
                width: maxWidth,
                height: maxHeight,
                child: Stack(
                  children: [
                    // Image A (background/left side)
                    Positioned.fill(
                      child: Image(image: imageAProvider, fit: BoxFit.contain),
                    ),

                    // Image B (foreground/right side) - clipped to show only right portion
                    Positioned.fill(
                      child: ClipRect(
                        clipper: RightClipper(overlaySliderPosition.value),
                        child: Image(
                          image: imageBProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Slider line indicator with reactive scaling
                    ValueListenableBuilder<Matrix4>(
                      valueListenable: overlayTransformationController.value,
                      builder: (context, matrix, child) {
                        // Also check for manual updates
                        final _ = overlayTransformationUpdate.value;
                        double scale = matrix.getMaxScaleOnAxis();
                        return Positioned(
                          left:
                              maxWidth * overlaySliderPosition.value -
                              (1 / scale),
                          top: 0,
                          bottom: 0,
                          width: 2 / scale,
                          child: Container(
                            decoration: BoxDecoration(
                              color: MonetTheme.of(context).primary.fill,
                            ),
                          ),
                        );
                      },
                    ),

                    // Diff overlay (when enabled)
                    if (showDiffOverlay.value && diffImage != null)
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.7,
                          child: Image(image: diffImage!, fit: BoxFit.contain),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
