import 'package:app/core/database/app_database.dart';
import 'package:app/core/ml/image_preprocessor.dart';
import 'package:app/core/ml/tensor_converter.dart';
import 'package:app/core/ml/tflite_service.dart';
import 'package:app/features/classification/injection.dart'
    as classification_injection;
import 'package:app/features/drawing/injection.dart' as drawing_injection;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt di = GetIt.instance;

Future<void> configureDependencies() async {
  // Core / singletons
  di.registerLazySingleton<AppDatabase>(() => AppDatabase());

  di.registerLazySingleton<ImagePreprocessor>(() => const ImagePreprocessor());
  di.registerLazySingleton<TensorConverter>(() => const TensorConverter());

  final tflite = TFLiteService();
  await tflite.init();
  di.registerSingleton<TFLiteService>(tflite);

  // Local storage example (environment/settings)
  final prefs = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(prefs);

  await classification_injection.initClassificationFeature(di);
  await drawing_injection.initDrawingFeature(di);
}
