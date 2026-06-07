import 'dart:ui' show Offset;

class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  Offset toOffset() => Offset(x, y);
}
