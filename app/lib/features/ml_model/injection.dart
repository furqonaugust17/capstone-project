import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/ml/tflite_service.dart';
import 'data/datasources/ml_model_remote_data_source.dart';
import 'data/repositories/ml_model_repository_impl.dart';
import 'data/services/ml_model_cache_service.dart';
import 'domain/repositories/ml_model_repository.dart';
import 'domain/usecases/ensure_model_ready_usecase.dart';
import 'domain/usecases/get_active_model_usecase.dart';

import '../../core/network/api_client.dart';

Future<void> initMLModelFeature(GetIt di) async {
  // Services
  di.registerLazySingleton<MLModelCacheService>(
    () => MLModelCacheService(di<ApiClient>().dio, di<SharedPreferences>()),
  );

  // Data sources
  di.registerLazySingleton<MLModelRemoteDataSource>(
    () => MLModelRemoteDataSourceImpl(di()),
  );

  // Repository
  di.registerLazySingleton<MLModelRepository>(
    () => MLModelRepositoryImpl(di(), di()),
  );

  // Use cases
  di.registerLazySingleton(() => GetActiveModelUseCase(di()));
  di.registerLazySingleton(() => EnsureModelReadyUseCase(di(), di<TFLiteService>()));
}
