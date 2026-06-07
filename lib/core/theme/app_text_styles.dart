import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTextStyles {
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 40,
    fontWeight: AppTypography.fwBold,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 32,
    fontWeight: AppTypography.fwBold,
    color: AppColors.textPrimary,
  );

  static TextStyle get headingLarge => const TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 24,
    fontWeight: AppTypography.fwMedium,
    color: AppColors.textPrimary,
  );

  static TextStyle get headingMedium => const TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 20,
    fontWeight: AppTypography.fwMedium,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => const TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 18,
    fontWeight: AppTypography.fwMedium,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 16,
    fontWeight: AppTypography.fwRegular,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 14,
    fontWeight: AppTypography.fwRegular,
    color: AppColors.textSecondary,
  );

  static TextStyle get caption => const TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 12,
    fontWeight: AppTypography.fwRegular,
    color: AppColors.textSecondary,
  );

  static TextStyle get button => const TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 16,
    fontWeight: AppTypography.fwMedium,
    color: AppColors.textOnPrimary,
  );
}
