import 'package:flutter/material.dart';
import '../../domain/entities/stroke.dart';

class SketchPainter extends CustomPainter {
  final List<Stroke> strokes;
  final Stroke? currentStroke;

  SketchPainter({
    required this.strokes,
    required this.currentStroke,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background is managed by parent widget
    for (final s in strokes) {
      _drawStroke(canvas, s, size);
    }
    if (currentStroke != null) {
      _drawStroke(canvas, currentStroke!, size);
    }
  }

  void _drawStroke(Canvas canvas, Stroke s, Size size) {
    if (s.points.isEmpty) return;
    final paint = Paint()
      ..color = Color(s.colorValue)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = s.strokeWidth
      ..isAntiAlias = true
      ..blendMode = s.isEraser ? BlendMode.clear : BlendMode.srcOver;

    final path = Path();
    final first = s.points.first;
    path.moveTo(first.x, first.y);
    for (var i = 1; i < s.points.length; i++) {
      final p = s.points[i];
      final prev = s.points[i - 1];
      // Use quadratic bezier for smoothing
      final midX = (prev.x + p.x) / 2;
      final midY = (prev.y + p.y) / 2;
      path.quadraticBezierTo(prev.x, prev.y, midX, midY);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) {
    // Repaint when references change (strokes list replaced or currentStroke changes)
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke;
  }
}
