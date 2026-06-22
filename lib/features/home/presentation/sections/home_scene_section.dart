import 'package:flutter/material.dart';

import 'package:app/features/home/presentation/sections/home_decorations_section.dart';
import 'package:app/features/home/presentation/sections/home_hero_section.dart';
import 'package:app/features/home/presentation/widgets/home_start_button.dart';
import 'package:app/features/home/presentation/widgets/home_profile_widget.dart';

import 'package:go_router/go_router.dart';

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
              left: 392,
              top: 140,
              child: HomeStartButton(onPressed: () => onStartPressed()),
            ),
            // Profile Widget (Bottom Left)
            const Positioned(
              left: 9,
              top: 348,
              child: HomeProfileWidget(),
            ),
            // Bottom Center Controls (Galeri & Toko)
            Positioned(
              left: 339,
              top: 289,
              child: Row(
                children: [
                  _buildBottomControl(
                    context: context,
                    icon: Icons.image,
                    label: 'Galeri',
                    onTap: () => context.push('/history'),
                  ),
                  const SizedBox(width: 27),
                  _buildBottomControl(
                    context: context,
                    icon: Icons.storefront,
                    label: 'Toko',
                    onTap: () => context.push('/shop'), // Assuming /shop route exists or will be added
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControl({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 106,
        height: 79,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black, size: 20),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
