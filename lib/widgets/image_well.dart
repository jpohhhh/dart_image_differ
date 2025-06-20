import 'package:dart_image_differ/misc/border.dart';
import 'package:dart_image_differ/misc/constants.dart';
import 'package:dart_image_differ/misc/on_open_file.dart';
import 'package:dart_image_differ/widgets/drop_file_target.dart';
import 'package:dart_image_differ/widgets/monet_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:libmonet/theming/button_style.dart';
import 'package:libmonet/theming/monet_theme.dart';

class ImageWell extends HookConsumerWidget {
  final ImageProvider? imageProvider;
  final Uint8ListCallback setImage;
  final String title;

  const ImageWell({
    super.key,
    required this.title,
    required this.imageProvider,
    required this.setImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captionStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: MonetTheme.of(context).primary.fillText,
    );

    return DropFileTarget(
      onImageDropped: setImage,
      child: Container(
        decoration: ShapeDecoration(
          color: MonetTheme.of(context).primary.fill,
          shape: createShapeBorder(),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: VerticalPadding.amount),
              Text(title, style: captionStyle),
              SizedBox(height: VerticalPaddingHalf.amount),

              MonetElevatedButton(
                shadowColor: MonetTheme.of(context).primary.colorHover,
                icon: null,
                label: imageProvider == null ? Text('Add') : Text('Change'),
                onPressed: () {
                  onOpenFile().then((bytes) {
                    if (bytes != null) {
                      setImage(bytes);
                    }
                  });
                },
                outlineColorWhenNoShadow: MonetTheme.of(
                  context,
                ).tertiary.colorHover,
                statesController: null,
                style: filledButtonBackgroundIsColor(
                  MonetTheme.of(context).tertiary,
                ),
              ),

              if (imageProvider != null)
                Image(image: imageProvider!, fit: BoxFit.contain, height: 320),
              SizedBox(height: VerticalPadding.amount),
            ],
          ),
        ),
      ),
    );
  }
}
