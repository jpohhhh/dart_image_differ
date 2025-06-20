String hexFromArgb(int argb, {bool leadingHashSign = true}) {
  final red = redFromArgb(argb);
  final green = greenFromArgb(argb);
  final blue = blueFromArgb(argb);
  return '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0').toUpperCase()}'
      '${green.toRadixString(16).padLeft(2, '0').toUpperCase()}'
      '${blue.toRadixString(16).padLeft(2, '0').toUpperCase()}';
}

/// Returns the red component of a color in ARGB format.
int redFromArgb(int argb) {
  return argb >> 16 & 255;
}

/// Returns the green component of a color in ARGB format.
int greenFromArgb(int argb) {
  return argb >> 8 & 255;
}

/// Returns the blue component of a color in ARGB format.
int blueFromArgb(int argb) {
  return argb & 255;
}