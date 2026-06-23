import 'package:flutter/material.dart';

import 'package:app/features/home/presentation/sections/home_decorations_section.dart';
import 'package:app/features/home/presentation/sections/home_hero_section.dart';
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
            HomeHeroSection(onStartPressed: onStartPressed),
            const Positioned(bottom: 10, left: 10, child: HomeProfileWidget()),
            Positioned(
              bottom: 10,
              right: 10,
              child: Row(
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'inventory_btn',
                    onPressed: () => context.push('/inventory'),
                    backgroundColor: Colors.blueAccent,
                    icon: const Icon(Icons.inventory_2, color: Colors.white),
                    label: const Text(
                      'Inventori',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton.extended(
                    heroTag: 'shop_btn',
                    onPressed: () => context.push('/shop'),
                    backgroundColor: Colors.orange,
                    icon: const Icon(Icons.storefront, color: Colors.white),
                    label: const Text(
                      'Toko',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
