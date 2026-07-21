import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_radius.dart';

class DrawingFinishButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DrawingFinishButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColors.success,
      extendedPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      icon: const Icon(Icons.check, color: Colors.white),
      label: Text(
        'SELESAI',
        style: AppTextStyles.button.copyWith(color: Colors.white),
      ),
    );
  }
}
