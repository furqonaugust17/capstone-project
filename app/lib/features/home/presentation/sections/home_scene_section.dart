import 'package:flutter/material.dart';

import 'package:app/features/home/presentation/sections/home_decorations_section.dart';
import 'package:app/features/home/presentation/sections/home_hero_section.dart';
import 'package:app/features/home/presentation/widgets/home_profile_widget.dart';

class HomeSceneSection extends StatelessWidget {
  final VoidCallback onStartPressed;
  final bool showDecorations;

  const HomeSceneSection({
    super.key, 
    required this.onStartPressed,
    this.showDecorations = true,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 917,
        height: 412,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (showDecorations) const HomeDecorationsSection(),
            HomeHeroSection(onStartPressed: onStartPressed),
            const Positioned(top: 10, left: 10, child: HomeProfileWidget()),
          ],
        ),
      ),
    );
  }
}
