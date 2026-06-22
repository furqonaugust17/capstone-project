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
          left: 25.62,
          top: 81.62,
          width: 156.77,
          height: 156.77,
          rotationDegrees: 0,
          opacity: 0.2,
        ),
        HomeDecorativeSketch(
          assetPath: HomeImageAssets.sun,
          left: 651,
          top: 60,
          width: 96,
          height: 96,
          opacity: 1.0,
        ),
        HomeDecorativeSketch(
          assetPath: HomeImageAssets.bird, // assuming bird represents bebek
          left: 761,
          top: 222,
          width: 189.76,
          height: 189.76,
          opacity: 1.0,
        ),
      ],
    );
  }
}
