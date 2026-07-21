import 'point.dart';

class Stroke {
  final List<Point> points;
  final int colorValue; // store color as int for portability
  final double strokeWidth;
  final bool isEraser;

  Stroke({
    required this.points,
    required this.colorValue,
    required this.strokeWidth,
    this.isEraser = false,
  });

  Stroke copyWith({
    List<Point>? points,
    int? colorValue,
    double? strokeWidth,
    bool? isEraser,
  }) {
    return Stroke(
      points: points ?? List.of(this.points),
      colorValue: colorValue ?? this.colorValue,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isEraser: isEraser ?? this.isEraser,
    );
  }
}
