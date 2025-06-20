import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:libmonet/theming/monet_theme.dart';

class OverlayControls extends HookWidget {
  final ValueNotifier<TransformationController> overlayTransformationController;
  final ValueNotifier<double> overlaySliderPosition;
  final Size? containerSize;
  final ValueNotifier<int>? overlayTransformationUpdate;

  const OverlayControls({
    super.key,
    required this.overlayTransformationController,
    required this.overlaySliderPosition,
    this.containerSize,
    this.overlayTransformationUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Zoom controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                final controller = overlayTransformationController.value;
                final currentMatrix = controller.value;
                final currentScale = currentMatrix.getMaxScaleOnAxis();

                // Don't zoom out below natural size (scale = 1.0)
                if (currentScale <= 1.0) {
                  return; // Already at or below natural size
                }

                // Calculate viewport center
                final centerX = (containerSize?.width ?? 400.0) / 2;
                final centerY = (containerSize?.height ?? 400.0) / 2;
                final centerPoint = Offset(centerX, centerY);

                // Calculate new scale, but don't go below 1.0
                final newScale = (currentScale * 0.8).clamp(
                  1.0,
                  double.infinity,
                );
                final actualScaleFactor = newScale / currentScale;

                // Create scale matrix centered on viewport center
                final scaleMatrix = Matrix4.identity()
                  ..translate(centerPoint.dx, centerPoint.dy)
                  ..scale(actualScaleFactor)
                  ..translate(-centerPoint.dx, -centerPoint.dy);

                // Apply the scale transformation
                controller.value = scaleMatrix * currentMatrix;

                // Force divider line to update
                if (overlayTransformationUpdate != null) {
                  overlayTransformationUpdate!.value++;
                }
              },
              icon: Icon(Icons.zoom_out),
              tooltip: 'Zoom Out',
            ),
            IconButton(
              onPressed: () {
                overlayTransformationController.value.value =
                    Matrix4.identity();

                // Force divider line to update
                if (overlayTransformationUpdate != null) {
                  overlayTransformationUpdate!.value++;
                }
              },
              icon: Icon(Icons.center_focus_strong),
              tooltip: 'Reset Zoom',
            ),
            IconButton(
              onPressed: () {
                final controller = overlayTransformationController.value;
                final currentMatrix = controller.value;

                // Calculate viewport center
                final centerX = (containerSize?.width ?? 400.0) / 2;
                final centerY = (containerSize?.height ?? 400.0) / 2;
                final centerPoint = Offset(centerX, centerY);

                // Create scale matrix centered on viewport center
                final scaleMatrix = Matrix4.identity()
                  ..translate(centerPoint.dx, centerPoint.dy)
                  ..scale(1.25)
                  ..translate(-centerPoint.dx, -centerPoint.dy);

                // Apply the scale transformation
                controller.value = scaleMatrix * currentMatrix;
              },
              icon: Icon(Icons.zoom_in),
              tooltip: 'Zoom In',
            ),
          ],
        ),
        SizedBox(height: 8),

        // Position slider
        Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: MonetTheme.of(context).secondary.fill,
                inactiveTrackColor: MonetTheme.of(
                  context,
                ).secondary.backgroundFill,
                thumbColor: MonetTheme.of(context).secondary.fill,
                overlayColor: MonetTheme.of(context).secondary.background,
                trackHeight: 4,
              ),
              child: Slider(
                value: overlaySliderPosition.value,
                onChanged: (value) {
                  overlaySliderPosition.value = value;
                },
                min: 0.0,
                max: 1.0,
                divisions: 100,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
