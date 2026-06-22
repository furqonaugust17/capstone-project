import 'package:flutter/material.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 224,
      top: 54,
      width: 468,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'GAME EDUKASI\nMENGGAMBAR HEWAN',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: 0.32,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Ayo belajar menggambar hewan lucu dengan\ncara yang menyenangkan!',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
