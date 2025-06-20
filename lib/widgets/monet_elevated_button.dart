import 'package:dart_image_differ/misc/border.dart';
import 'package:dart_image_differ/misc/constants.dart';
import 'package:dart_image_differ/misc/shadows.dart';
import 'package:libmonet/theming/monet_theme_data.dart';
import 'package:flutter/material.dart';


class MonetElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color shadowColor;
  final WidgetStatesController? statesController;
  final ButtonStyle? style;
  final Widget? icon;
  final Widget? label;
  final Color? outlineColorWhenNoShadow;

  const MonetElevatedButton({
    super.key,
    required this.shadowColor,
    this.statesController,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.outlineColorWhenNoShadow,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final hasOutline =
        shadowColor == Colors.transparent && outlineColorWhenNoShadow != null;
    final finalStyle = (style ?? const ButtonStyle()).copyWith(
      iconSize:
          style?.iconSize ??
          WidgetStateProperty.all(
            Theme.of(context).textTheme.bodyLarge!.fontSize,
          ),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      shape: WidgetStateProperty.all(createShapeBorder()),
      side: WidgetStateProperty.all(
        hasOutline
            ? BorderSide(color: outlineColorWhenNoShadow!, width: 1)
            : BorderSide.none,
      ),
      minimumSize:
          style?.minimumSize ??
          WidgetStatePropertyAll(Size(0, MonetThemeData.touchSize + 6)),
      // For some reason, default is 8/2 on iOS and 8/12 on ex. macOS.
      //
      // This was found while investigating why iOS/Android had little vertical
      // padding on home ideas buttons compared to other platforms.
      //
      // It looks like this is due to quite complicated conditional logic in
      // ex. ElevatedButton based on font size and visual density.
      padding: WidgetStatePropertyAll(
        EdgeInsets.only(
          // left tends to have inherent padding due to icon.
          // / 2 was initially selected. This worked well for read/ideas chips
          // but not for home ideas buttons.
          left: icon != null
              ? HorizontalPadding.amount - 4
              : HorizontalPadding.amount,
          right: label != null
              ? HorizontalPadding.amount - 2
              : HorizontalPadding.amount - 4,
          top: VerticalPaddingHalf.amount,
          bottom: VerticalPaddingHalf.amount,
        ),
      ),
    );
    ElevatedButton button;
    if (icon != null) {
      if (label != null) {
        // ElevatedButton.icon has a non-configurable gap between the icon
        // and text.
        //
        // This meant we could not get the "Change AI" button in the script
        // to have the same padding as the slider header icon and text.
        //
        // ElevatedButton.icon is a very thin wrapper implemented much like this
        button = ElevatedButton(
          statesController: statesController,
          onPressed: onPressed,
          style: finalStyle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  return IconTheme(
                    data: IconTheme.of(
                      context,
                    ).copyWith(color: DefaultTextStyle.of(context).style.color),
                    child: icon!,
                  );
                },
              ),
              SizedBox(width: 6),
              label!,
            ],
          ),
        );
      } else {
        button = ElevatedButton(
          statesController: statesController,
          onPressed: onPressed,
          style: finalStyle,
          child: icon!,
        );
      }
    } else {
      button = ElevatedButton(
        statesController: statesController,
        onPressed: onPressed,
        style: finalStyle,
        child: label,
      );
    }
    final List<BoxShadow> shadows;
    if (shadowColor == Colors.transparent) {
      shadows = [];
    } else {
      shadows = aestheticShadows(shadowColor);
    }
    return SelectionContainer.disabled(
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: ShapeDecoration(shadows: shadows, shape: createShapeBorder()),
        child: button,
      ),
    );
  }
}
