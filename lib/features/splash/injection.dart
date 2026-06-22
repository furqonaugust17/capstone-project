import 'package:get_it/get_it.dart';
import 'presentation/bloc/splash_cubit.dart';

Future<void> initSplashFeature(GetIt di) async {
  di.registerFactory(() => SplashCubit(
        checkAuthStatusUseCase: di(),
        ensureModelReadyUseCase: di(),
      ));
}
