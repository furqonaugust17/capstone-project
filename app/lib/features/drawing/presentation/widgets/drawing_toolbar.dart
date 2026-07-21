import 'package:flutter/material.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import '../../domain/entities/brush.dart';

class DrawingToolbar extends StatelessWidget {
  final Brush brush;
  final void Function(Brush) onBrushChanged;
  final VoidCallback onUndo;
  final VoidCallback onClear;

  const DrawingToolbar({
    super.key,
    required this.brush,
    required this.onBrushChanged,
    required this.onUndo,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(icon: const Icon(Icons.undo), onPressed: onUndo),
        _buildBrushSelector(context),
        IconButton(icon: const Icon(Icons.delete), onPressed: onClear),
      ],
    );
  }

  Widget _buildBrushSelector(BuildContext context) {
    return PopupMenuButton<Brush>(
      icon: Icon(Icons.brush, color: brush.color),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: brush.copyWith(strokeWidth: 3.0),
          child: Row(
            children: [
              _sizePreview(3.0, brush.color),
              const SizedBox(width: AppSpacing.md),
              Text('Thin', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: brush.copyWith(strokeWidth: 6.0),
          child: Row(
            children: [
              _sizePreview(6.0, brush.color),
              const SizedBox(width: AppSpacing.md),
              Text('Medium', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: brush.copyWith(strokeWidth: 12.0),
          child: Row(
            children: [
              _sizePreview(12.0, brush.color),
              const SizedBox(width: AppSpacing.md),
              Text('Thick', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: brush.copyWith(tool: ToolType.eraser),
          child: Row(
            children: [
              const Icon(Icons.cleaning_services_outlined),
              const SizedBox(width: AppSpacing.md),
              Text('Eraser', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
      onSelected: onBrushChanged,
    );
  }

  Widget _sizePreview(double width, Color color) {
    final size = width * 1.8; // scale for visibility in menu
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
