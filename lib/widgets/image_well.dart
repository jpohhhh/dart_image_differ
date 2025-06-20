import 'package:dart_image_differ/misc/border.dart';
import 'package:dart_image_differ/misc/constants.dart';
import 'package:dart_image_differ/widgets/monet_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:libmonet/theming/button_style.dart';
import 'package:libmonet/theming/monet_theme.dart';

class ImageWell extends HookConsumerWidget {
  final Widget child;

  const ImageWell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: ShapeDecoration(
        color: MonetTheme.of(context).primary.fill,
        shape: createShapeBorder(),
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: VerticalPadding.amount),
            child,
            SizedBox(height: VerticalPaddingHalf.amount),
            MonetElevatedButton(
              shadowColor: MonetTheme.of(context).primary.colorHover,
              icon: null,
              label: Text('Add Image'),
              onPressed: () {},
              outlineColorWhenNoShadow: MonetTheme.of(
                context,
              ).tertiary.colorHover,
              statesController: null,
              style: filledButtonBackgroundIsColor(
                MonetTheme.of(context).tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
