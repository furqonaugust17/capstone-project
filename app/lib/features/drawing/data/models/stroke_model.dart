import '../../domain/entities/point.dart';
import '../../domain/entities/stroke.dart';

class StrokeModel extends Stroke {
  StrokeModel({
    required super.points,
    required super.colorValue,
    required super.strokeWidth,
    super.isEraser = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((p) => {'x': p.x, 'y': p.y}).toList(),
      'colorValue': colorValue,
      'strokeWidth': strokeWidth,
      'isEraser': isEraser,
    };
  }

  factory StrokeModel.fromJson(Map<String, dynamic> json) {
    final pts = (json['points'] as List)
        .map(
          (e) => Point((e['x'] as num).toDouble(), (e['y'] as num).toDouble()),
        )
        .toList();
    return StrokeModel(
      points: pts,
      colorValue: json['colorValue'] as int,
      strokeWidth: (json['strokeWidth'] as num).toDouble(),
      isEraser: json['isEraser'] as bool,
    );
  }
}
