import '../entities/stroke.dart';
import '../repositories/drawing_repository.dart';

class SaveDrawingUseCase {
  final DrawingRepository repository;
  SaveDrawingUseCase(this.repository);

  Future<void> call(List<Stroke> strokes, {String? id}) async {
    await repository.saveDrawing(strokes, id: id);
  }
}
