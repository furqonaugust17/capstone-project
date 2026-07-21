import '../../domain/entities/ml_model_entity.dart';
import '../../domain/repositories/ml_model_repository.dart';
import '../datasources/ml_model_remote_data_source.dart';
import '../services/ml_model_cache_service.dart';

class MLModelRepositoryImpl implements MLModelRepository {
  final MLModelRemoteDataSource _remoteDataSource;
  final MLModelCacheService _cacheService;

  const MLModelRepositoryImpl(this._remoteDataSource, this._cacheService);

  @override
  Future<MLModelEntity> getActiveModel() async {
    // 1. Fetch metadata from API
    final modelModel = await _remoteDataSource.getActiveModel();
    
    // 2. Download and cache the model file using version and URL
    final localPath = await _cacheService.downloadAndCacheModel(
      fileUrl: modelModel.fileUrl,
      version: modelModel.version,
    );

    // 3. Convert to Entity
    final entity = modelModel.toEntity();

    // 4. Return the entity with fileUrl replaced by the local file path
    // so the TFLite engine can load it directly from storage.
    return MLModelEntity(
      id: entity.id,
      name: entity.name,
      version: entity.version,
      fileUrl: localPath, 
      inputSize: entity.inputSize,
      isActive: entity.isActive,
      labels: entity.labels,
    );
  }
}
