import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/features/mode/presentation/widgets/mode_pill.dart';

class ModeSceneSection extends StatelessWidget {
  final dynamic selectedAnimal;

  const ModeSceneSection({super.key, this.selectedAnimal});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 24,
      children: [
        Text(
          'PILIH MODE',
          style: AppTextStyles.displayLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            ModePill(
              label: 'Ayo Tebalkan!',
              background: AppColors.surface,
              textColor: AppColors.primary,
              onTap: () => context.push(
                '/drawing',
                extra: {'animal': selectedAnimal, 'mode': 'thicken'},
              ),
            ),
            ModePill(
              label: 'Gambar Sendiri!',
              background: AppColors.primary,
              textColor: AppColors.textOnPrimary,
              onTap: () => context.push(
                '/drawing',
                extra: {'animal': selectedAnimal, 'mode': 'free'},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
