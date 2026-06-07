import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/drawing_local_data_source.dart';
import 'data/repositories/drawing_repository_impl.dart';
import 'presentation/controllers/drawing_controller.dart';
import 'presentation/bloc/drawing_cubit.dart';
import 'domain/usecases/save_drawing_usecase.dart';
import 'domain/usecases/load_drawing_usecase.dart';
import 'domain/usecases/clear_drawing_usecase.dart';
import 'domain/repositories/drawing_repository.dart';

Future<void> initDrawingFeature(GetIt sl) async {
  sl.registerLazySingleton<DrawingLocalDataSource>(
    () => DrawingLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<DrawingRepository>(
    () => DrawingRepositoryImpl(local: sl<DrawingLocalDataSource>()),
  );

  sl.registerFactory(() => DrawingController());

  sl.registerFactory(() => SaveDrawingUseCase(sl()));
  sl.registerFactory(() => LoadDrawingUseCase(sl()));
  sl.registerFactory(() => ClearDrawingUseCase(sl()));

  sl.registerFactoryParam<DrawingCubit, DrawingController?, void>(
    (controller, _) => DrawingCubit(
      controller: controller ?? sl<DrawingController>(),
      saveUseCase: sl(),
      loadUseCase: sl(),
      clearUseCase: sl(),
    ),
  );
}
