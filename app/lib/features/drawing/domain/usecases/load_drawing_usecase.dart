import '../entities/stroke.dart';
import '../repositories/drawing_repository.dart';

class LoadDrawingUseCase {
  final DrawingRepository repository;
  LoadDrawingUseCase(this.repository);

  Future<List<Stroke>> call({String? id}) async {
    return repository.loadDrawing(id: id);
  }
}
