import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_dimensions.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/theme/app_typography.dart';

class ResultActionButtons extends StatelessWidget {
  const ResultActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ResultPillButton(
          width: AppDimensions.resultPillWidth,
          height: AppDimensions.resultPillHeight,
          backgroundColor: AppColors.scorePill,
          borderColor: AppColors.primary.withValues(alpha: 0.1),
          onPressed: () => context.go('/'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.list, size: 16, color: AppColors.textNavyMuted),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'KEMBALI',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 15,
                  fontWeight: AppTypography.fwBold,
                  color: AppColors.textNavyMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        _ResultPillButton(
          width: AppDimensions.resultPillWidth,
          height: AppDimensions.resultPillHeight,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          onPressed: () => context.go('/choose'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BERIKUTNYA',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 15,
                  fontWeight: AppTypography.fwBold,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.textOnPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultPillButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? gradient;

  const _ResultPillButton({
    required this.width,
    required this.height,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.full),
        onTap: onPressed,
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 2)
                : null,
            boxShadow: gradient != null
                ? [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.12),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
