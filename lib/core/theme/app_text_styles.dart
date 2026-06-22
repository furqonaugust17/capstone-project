import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTextStyles {
  static TextStyle get displayLarge => TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 40,
    fontWeight: AppTypography.fwBold,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 32,
    fontWeight: AppTypography.fwBold,
    color: AppColors.textPrimary,
  );

  static TextStyle get headingLarge => TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 24,
    fontWeight: AppTypography.fwMedium,
    color: AppColors.textPrimary,
  );

  static TextStyle get headingMedium => TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 20,
    fontWeight: AppTypography.fwMedium,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 18,
    fontWeight: AppTypography.fwMedium,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 16,
    fontWeight: AppTypography.fwRegular,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 14,
    fontWeight: AppTypography.fwRegular,
    color: AppColors.textSecondary,
  );

  static TextStyle get caption => TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 12,
    fontWeight: AppTypography.fwRegular,
    color: AppColors.textSecondary,
  );

  static TextStyle get button => TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 16,
    fontWeight: AppTypography.fwMedium,
    color: AppColors.textOnPrimary,
  );
}
