import '../entities/ml_model_entity.dart';
import '../repositories/ml_model_repository.dart';

class GetActiveModelUseCase {
  final MLModelRepository _repository;

  const GetActiveModelUseCase(this._repository);

  Future<MLModelEntity> call() {
    return _repository.getActiveModel();
  }
}
