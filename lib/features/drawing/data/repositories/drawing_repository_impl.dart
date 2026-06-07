import '../../domain/entities/stroke.dart';
import '../../domain/repositories/drawing_repository.dart';
import '../datasources/drawing_local_data_source.dart';
import '../models/stroke_model.dart';

class DrawingRepositoryImpl implements DrawingRepository {
  final DrawingLocalDataSource local;
  final String storageKey;

  DrawingRepositoryImpl({
    required this.local,
    this.storageKey = 'drawing_session',
  });

  @override
  Future<void> saveDrawing(List<Stroke> strokes, {String? id}) async {
    final key = id ?? storageKey;
    final models = strokes
        .map(
          (s) => StrokeModel(
            points: s.points,
            colorValue: s.colorValue,
            strokeWidth: s.strokeWidth,
            isEraser: s.isEraser,
          ),
        )
        .toList();
    await local.save(key, models);
  }

  @override
  Future<List<Stroke>> loadDrawing({String? id}) async {
    final key = id ?? storageKey;
    final models = await local.load(key);
    return models.map((m) => m as Stroke).toList();
  }

  @override
  Future<void> clearDrawing({String? id}) async {
    final key = id ?? storageKey;
    await local.clear(key);
  }
}
