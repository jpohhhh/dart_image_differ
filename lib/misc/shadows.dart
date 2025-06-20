import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:libmonet/hct.dart';
import 'package:libmonet/theming/monet_theme_data.dart';

double blurRadiusForPlatform(double spec) {
  final shouldHalf = defaultTargetPlatform == TargetPlatform.linux;
  return shouldHalf ? spec / 2.0 : spec;
}

double protectionBlurRadius() {
  return blurRadiusForPlatform(4.0);
}

/// Use with [StrokeText] or [StrokeIcon].
/// Passing in [Colors.transparent] will result in no shadows.
List<Shadow> headerProtectionShadows(Color baseColor) {
  if (baseColor == Colors.transparent) {
    return [];
  }
  return [
    BoxShadow(color: baseColor, blurRadius: 8, offset: Offset(0, 0)),
    BoxShadow(
      color: baseColor,
      blurRadius: 2,
      spreadRadius: 1,
      offset: Offset(0, 0),
    ),
  ];
}

/// Use with [StrokeText] or [StrokeIcon].
/// Passing in [Colors.transparent] will result in no shadows.
List<Shadow> protectionShadows(Color baseColor) {
  if (baseColor == Colors.transparent) {
    return [];
  }
  return [
    BoxShadow(color: baseColor, blurRadius: 8, offset: Offset(0, 0)),
    BoxShadow(color: baseColor, blurRadius: 8, offset: Offset(0, 0)),
    BoxShadow(color: baseColor, blurRadius: 8, offset: Offset(0, 0)),
    BoxShadow(
      color: baseColor,
      blurRadius: 2,
      spreadRadius: 1,
      offset: Offset(0, 0),
    ),
  ];
}

// Only used by STT button.
List<Shadow> barelyThereProtectionShadows(Color baseColor) {
  final blurRadius = protectionBlurRadius();
  return [
    Shadow(color: baseColor, blurRadius: blurRadius),
    Shadow(color: baseColor.withValues(alpha: 0.5), blurRadius: blurRadius),
  ];
}

// Used by Flushbar.
List<Shadow> surfaceShadowsForPlatform(Color baseColor) {
  const blurRadius = 6.0;
  return [
    Shadow(color: baseColor, blurRadius: blurRadius),
    Shadow(color: baseColor, blurRadius: blurRadius),
  ];
}

List<BoxShadow> aestheticShadows(Color color) {
  return [
    outlineOnlyShadow(color),
    // Penumbra: Partial shadow
    BoxShadow(
      offset: Offset.zero,
      blurRadius: protectionBlurRadius() / 2.0, // More diffuse than umbra
      spreadRadius: 1.0, // Natural edge
      color: color.withValues(alpha: 0.3),
    ),
    // Ambient: Most diffuse, scattered light
    BoxShadow(
      offset: Offset.zero,
      blurRadius: protectionBlurRadius(), // Most diffuse
      spreadRadius: 0.0,
      color: color.withValues(alpha: 0.5),
    ),
  ];
}

BoxShadow outlineOnlyShadow(Color color) {
  return BoxShadow(
    color: color,
    blurRadius: 0,
    spreadRadius: 1,
    offset: Offset.zero,
  );
}

List<BoxShadow> fabShadows(Color color) {
  return [
    ...?kElevationToShadow[16]?.map(
      (e) => BoxShadow(
        color: color.withValues(alpha: 0.3),
        blurRadius: e.blurRadius,
        spreadRadius: 0,
        offset: Offset.zero,
      ),
    ),
  ];
}

List<BoxShadow> modalShadows(MonetThemeData monetTheme) =>
    modalMenuShadows2(monetTheme);

List<BoxShadow> modalMenuShadows2(MonetThemeData monetTheme) {
  final bgTone = Hct.fromColor(monetTheme.primary.background).tone;
  final color = switch (bgTone) {
    (< 60) => Colors.black,
    (>= 60) => monetTheme.primary.colorHover,
    (_) => throw Exception('Invalid tone: $bgTone'),
  };

  const blurRadius = 8.0;
  final shadows = [Shadow(color: color, blurRadius: blurRadius)];
  return shadows
      .map(
        (e) => BoxShadow(
          color: e.color,
          blurRadius: e.blurRadius,
          offset: e.offset,
        ),
      )
      .toList();
}

List<BoxShadow> modalMenuShadows(MonetThemeData monetTheme) =>
    surfaceShadowsForPlatform(monetTheme.primary.background)
        .map(
          (e) => BoxShadow(
            color: e.color,
            blurRadius: e.blurRadius,
            offset: e.offset,
          ),
        )
        .toList();
