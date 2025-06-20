import 'package:flutter/material.dart';

class RightClipper extends CustomClipper<Rect> {
  final double sliderPosition;

  RightClipper(this.sliderPosition);

  @override
  Rect getClip(Size size) {
    // Show only the right portion of the image based on slider position
    double leftEdge = size.width * sliderPosition;
    return Rect.fromLTRB(leftEdge, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return oldClipper is RightClipper && oldClipper.sliderPosition != sliderPosition;
  }
}