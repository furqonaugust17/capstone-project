import 'package:flutter/material.dart';

import 'package:app/features/home/presentation/sections/home_decorations_section.dart';
import 'package:app/features/home/presentation/sections/home_hero_section.dart';
import 'package:app/features/home/presentation/widgets/home_start_button.dart';

class HomeSceneSection extends StatelessWidget {
  final VoidCallback onStartPressed;

  const HomeSceneSection({super.key, required this.onStartPressed});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 917,
        height: 412,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const HomeDecorationsSection(),
            const HomeHeroSection(),
            Positioned(
              left: 392.5,
              top: 216,
              child: HomeStartButton(onPressed: () => onStartPressed()),
            ),
          ],
        ),
      ),
    );
  }
}
