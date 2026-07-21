import 'package:flutter/material.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_text_styles.dart';

class ModePill extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;
  final VoidCallback? onTap;

  const ModePill({
    super.key,
    required this.label,
    required this.background,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 72,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge.copyWith(
            color: textColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
