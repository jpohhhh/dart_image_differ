import 'package:flutter/material.dart';

OutlinedBorder createShapeBorder({Color? color}) {
  return RoundedSuperellipseBorder(
    borderRadius: BorderRadius.circular(8.0),
    side: BorderSide(
      color: color ?? Colors.transparent,
      width: color == null || color == Colors.transparent ? 0.0 : 1.0,
    ),
  );
}
