import '../repositories/drawing_repository.dart';

class ClearDrawingUseCase {
  final DrawingRepository repository;
  ClearDrawingUseCase(this.repository);

  Future<void> call({String? id}) async {
    await repository.clearDrawing(id: id);
  }
}
