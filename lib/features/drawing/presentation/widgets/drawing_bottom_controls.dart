import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_radius.dart';
import '../controllers/drawing_controller.dart';
import '../../domain/entities/brush.dart';

class DrawingBottomControls extends StatelessWidget {
  final DrawingController controller;
  final VoidCallback onClear;

  const DrawingBottomControls({
    super.key,
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isPencil = controller.brush.tool == ToolType.pen;
    final strokeWidth = controller.brush.strokeWidth;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            elevation: 8,
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.setBrush(
                        controller.brush.copyWith(tool: ToolType.pen),
                      );
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPencil ? AppColors.primary : AppColors.surface,
                        boxShadow: isPencil
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.create,
                        color: isPencil
                            ? AppColors.textOnPrimary
                            : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Brush size selectors
                  _BrushSizeButton(
                    size: 3,
                    active: (strokeWidth - 3).abs() < 1.0,
                    color: controller.brush.color,
                    onTap: () => controller.setBrush(
                      controller.brush.copyWith(
                        strokeWidth: 3.0,
                        tool: ToolType.pen,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _BrushSizeButton(
                    size: 6,
                    active: (strokeWidth - 6).abs() < 1.0,
                    color: controller.brush.color,
                    onTap: () => controller.setBrush(
                      controller.brush.copyWith(
                        strokeWidth: 6.0,
                        tool: ToolType.pen,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _BrushSizeButton(
                    size: 12,
                    active: (strokeWidth - 12).abs() < 1.5,
                    color: controller.brush.color,
                    onTap: () => controller.setBrush(
                      controller.brush.copyWith(
                        strokeWidth: 12.0,
                        tool: ToolType.pen,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: onClear,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrushSizeButton extends StatelessWidget {
  final double size;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _BrushSizeButton({
    required this.size,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? AppColors.primary : AppColors.surface,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: active ? AppColors.textOnPrimary : color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
