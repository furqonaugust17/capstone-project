import 'package:app/core/database/app_database.dart';
import 'package:app/core/ml/image_preprocessor.dart';
import 'package:app/core/ml/tensor_converter.dart';
import 'package:app/core/ml/tflite_service.dart';
import 'package:app/features/drawing/injection.dart' as drawing_injection;
import 'package:app/features/auth/injection.dart' as auth_injection;
import 'package:app/features/classification/injection.dart'
    as classification_injection;
import 'package:app/features/animal/injection.dart' as animal_injection;
import 'package:app/features/ml_model/injection.dart' as ml_model_injection;
import 'package:app/features/splash/injection.dart' as splash_injection;
import 'package:app/features/game_session/injection.dart' as game_session_injection;
import 'package:app/features/leaderboard/injection.dart' as leaderboard_injection;
import 'package:app/features/statistics/injection.dart' as statistics_injection;
import 'package:app/features/inventory/injection.dart' as inventory_injection;
import 'package:app/features/shop/injection.dart' as shop_injection;
import 'package:app/features/purchase/injection.dart' as purchase_injection;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt di = GetIt.instance;

Future<void> configureDependencies() async {
  // Core / singletons
  di.registerLazySingleton<AppDatabase>(() => AppDatabase());

  di.registerLazySingleton<ImagePreprocessor>(() => const ImagePreprocessor());
  di.registerLazySingleton<TensorConverter>(() => const TensorConverter());

  // Register TFLiteService without init — SplashCubit will call
  // initFromFile() (online model) or init() (bundled fallback).
  di.registerSingleton<TFLiteService>(TFLiteService());

  // Local storage example (environment/settings)
  final prefs = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(prefs);

  await classification_injection.initClassificationFeature(di);
  await drawing_injection.initDrawingFeature(di);
  await auth_injection.initAuthFeature(di);
  await animal_injection.initAnimalFeature(di);
  await ml_model_injection.initMLModelFeature(di);
  await splash_injection.initSplashFeature(di);
  await game_session_injection.initGameSessionFeature(di);
  await leaderboard_injection.initLeaderboardFeature(di);
  await statistics_injection.initStatisticsFeature(di);
  await inventory_injection.initInventoryFeature(di);
  await shop_injection.initShopFeature(di);
  await purchase_injection.initPurchaseFeature(di);
}
