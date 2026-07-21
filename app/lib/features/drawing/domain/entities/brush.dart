import 'package:flutter/material.dart';

enum ToolType { pen, eraser }

class Brush {
  final Color color;
  final double strokeWidth;
  final ToolType tool;

  const Brush({
    required this.color,
    required this.strokeWidth,
    this.tool = ToolType.pen,
  });

  Brush copyWith({Color? color, double? strokeWidth, ToolType? tool}) {
    return Brush(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      tool: tool ?? this.tool,
    );
  }
}
