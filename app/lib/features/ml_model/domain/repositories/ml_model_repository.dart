import '../../domain/entities/ml_model_entity.dart';

abstract class MLModelRepository {
  /// Fetches the active ML model metadata and ensures the file is downloaded.
  /// Returns the model entity with the local file path replacing the remote URL.
  Future<MLModelEntity> getActiveModel();
}
