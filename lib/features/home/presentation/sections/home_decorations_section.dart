import 'package:flutter/material.dart';

import 'package:app/features/home/presentation/widgets/home_decorative_sketch.dart';
import 'package:app/features/home/presentation/widgets/home_image_assets.dart';

class HomeDecorationsSection extends StatelessWidget {
  const HomeDecorationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      clipBehavior: Clip.none,
      children: [
        HomeDecorativeSketch(
          assetPath: HomeImageAssets.cat,
          left: 24,
          top: 48,
          width: 122,
          height: 122,
          rotationDegrees: -13,
          opacity: 0.15,
        ),
        HomeDecorativeSketch(
          assetPath: HomeImageAssets.sun,
          left: 670,
          top: 47,
          width: 72,
          height: 72,
          opacity: 0.25,
        ),
        HomeDecorativeSketch(
          assetPath: HomeImageAssets.bird,
          left: 811,
          top: 233,
          width: 84,
          height: 84,
          opacity: 0.2,
        ),
      ],
    );
  }
}
