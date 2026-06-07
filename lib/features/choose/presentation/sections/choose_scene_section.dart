import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
// imports kept minimal — radius not required in this section
import 'package:app/features/choose/presentation/widgets/animal_pill.dart';

class ChooseSceneSection extends StatelessWidget {
  const ChooseSceneSection({super.key});

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
            // Header back + title
            Positioned(
              left: 16,
              top: 12,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.primary,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            // Right top label
            Positioned(
              right: 24,
              top: 20,
              child: Text(
                'HEWAN',
                style: AppTextStyles.button.copyWith(color: AppColors.primary),
              ),
            ),

            // Center title
            Positioned(
              top: 36,
              left: 0,
              right: 0,
              child: Text(
                'MAU MENGGAMBAR APA HARI INI?',
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              ),
            ),

            // Choices row
            Positioned(
              left: AppSpacing.xxl,
              right: AppSpacing.xxl,
              top: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimalPill(
                    label: 'Kucing',
                    icon: Icons.pets,
                    onTap: () =>
                        context.push('/mode', extra: {'animal': 'Kucing'}),
                  ),
                  AnimalPill(
                    label: 'Sapi',
                    icon: Icons.grass,
                    onTap: () =>
                        context.push('/mode', extra: {'animal': 'Sapi'}),
                  ),
                  AnimalPill(
                    label: 'Bebek',
                    icon: Icons.water,
                    onTap: () =>
                        context.push('/mode', extra: {'animal': 'Bebek'}),
                  ),
                  AnimalPill(
                    label: 'Ikan',
                    icon: Icons.set_meal,
                    onTap: () =>
                        context.push('/mode', extra: {'animal': 'Ikan'}),
                  ),
                  AnimalPill(
                    label: 'Lumba\nLumba',
                    icon: Icons.pool,
                    onTap: () =>
                        context.push('/mode', extra: {'animal': 'Lumba-Lumba'}),
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
