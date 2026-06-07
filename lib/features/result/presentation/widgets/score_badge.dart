import 'package:flutter/material.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/theme/app_typography.dart';

class ScoreBadge extends StatelessWidget {
  final String score;

  const ScoreBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.scorePill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppColors.primary, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Text(
            score,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textNavyMuted,
              fontSize: 14,
              fontWeight: AppTypography.fwBold,
            ),
          ),
        ],
      ),
    );
  }
}
