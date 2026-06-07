import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomeDecorativeSketch extends StatelessWidget {
  final String assetPath;
  final double left;
  final double top;
  final double width;
  final double height;
  final double rotationDegrees;
  final double opacity;

  const HomeDecorativeSketch({
    super.key,
    required this.assetPath,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.rotationDegrees = 0,
    this.opacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: Transform.rotate(
            angle: rotationDegrees * math.pi / 180,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
      ),
    );
  }
}
