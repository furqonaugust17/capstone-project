import 'package:flutter/material.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';

class HomeStartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HomeStartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final buttonColor = Color.lerp(
      AppColors.primary,
      AppColors.secondary,
      0.5,
    )!;
    final shadowColor = Color.lerp(
      AppColors.primary,
      AppColors.textPrimary,
      0.25,
    )!;

    return Semantics(
      button: true,
      label: 'Mulai menggambar',
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          onTap: onPressed,
          radius: 78,
          containedInkWell: false,
          splashColor: AppColors.primary.withValues(alpha: 0.16),
          highlightColor: Colors.transparent,
          child: SizedBox(
            width: 132,
            height: 136,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, 7),
                  child: Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      color: shadowColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Mulai',
                      style: AppTextStyles.button.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
