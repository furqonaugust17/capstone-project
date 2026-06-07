import '../entities/stroke.dart';

abstract class DrawingRepository {
  Future<void> saveDrawing(List<Stroke> strokes, {String? id});
  Future<List<Stroke>> loadDrawing({String? id});
  Future<void> clearDrawing({String? id});
}
