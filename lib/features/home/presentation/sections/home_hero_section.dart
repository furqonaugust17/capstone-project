import 'package:flutter/material.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 309,
      top: 46,
      width: 299,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ANIDRAW',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(
              fontFamily: 'PoetsenOne',
              fontSize: 64,
              color: Color(0xFF4285F4),
              fontWeight: FontWeight.w400,
              height: 38 / 64,
              letterSpacing: 0.64, // 0.01em
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Ayo belajar menggambar hewan lucu dengan\ncara yang menyenangkan!',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF44474E),
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 17 / 14,
            ),
          ),
        ],
      ),
    );
  }
}
