import 'package:get_it/get_it.dart';

import 'data/datasources/tflite_local_data_source.dart';
import 'data/repositories/classification_repository_impl.dart';
import 'domain/repositories/classification_repository.dart';
import 'domain/usecases/classify_sketch_usecase.dart';
import 'presentation/bloc/classification_bloc.dart';

Future<void> initClassificationFeature(GetIt sl) async {
  sl.registerLazySingleton<TFLiteLocalDataSource>(
    () => TFLiteLocalDataSourceImpl(
      tfliteService: sl(),
      preprocessor: sl(),
      tensorConverter: sl(),
    ),
  );

  sl.registerLazySingleton<ClassificationRepository>(
    () => ClassificationRepositoryImpl(sl()),
  );

  sl.registerFactory(() => ClassifySketchUseCase(sl()));

  sl.registerFactory(() => ClassificationBloc(sl()));
}
