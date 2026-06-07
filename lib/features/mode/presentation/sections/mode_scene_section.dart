import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/features/mode/presentation/widgets/mode_pill.dart';

class ModeSceneSection extends StatelessWidget {
  final String? selectedAnimal;

  const ModeSceneSection({super.key, this.selectedAnimal});

  @override
  Widget build(BuildContext context) {
    const artboardWidth = 917.0;
    const artboardHeight = 412.0;

    return RepaintBoundary(
      child: SizedBox(
        width: artboardWidth,
        height: artboardHeight,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.white)),

            // Header
            Positioned(
              left: 24,
              top: 16,
              child: Row(
                children: [
                  Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'MODE',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Title
            Positioned(
              left: 0,
              right: 0,
              top: 150,
              child: Center(
                child: Text(
                  'PILIH MODE',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            // Mode pills (vertical rotated layout in Figma converted to horizontal stack)
            Positioned(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              top: 220,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ),
          ],
        ),
      ),
    );
  }
}
