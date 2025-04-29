import 'dart:math';

import 'package:flutter/material.dart';

class CurvedRectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double radius = 20.0;
    Path path = Path();

    // Start at top-left
    path.moveTo(0, 0);

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.5);
    path.arcTo(
      Rect.fromPoints(
        Offset(size.width - radius, 0),
        Offset(size.width, radius),
      ), // Rect
      1.5 * pi, // Start engle
      0.5 * pi, // Sweep engle
      true,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
