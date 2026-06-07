import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';

class ResultImageCard extends StatelessWidget {
  final String? imageAsset;
  final Uint8List? imageBytes;

  const ResultImageCard({super.key, this.imageAsset, this.imageBytes})
    : assert(
        imageAsset != null || imageBytes != null,
        'Either imageAsset or imageBytes must be provided',
      );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          color: AppColors.primary.withValues(alpha: 0.1),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.1),
              blurRadius: 25,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: AppColors.surface.withValues(alpha: 0.5),
                      width: AppSpacing.xs,
                    ),
                  ),
                  child: imageBytes != null
                      ? Image.memory(imageBytes!, fit: BoxFit.cover)
                      : (imageAsset != null
                            ? Image.asset(imageAsset!, fit: BoxFit.contain)
                            : const SizedBox.shrink()),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -10,
              bottom: -12,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.successTint,
                child: const Icon(Icons.pets, color: AppColors.success),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
