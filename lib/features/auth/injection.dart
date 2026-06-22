import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../core/env/environment.dart';
import '../../core/network/api_client.dart';
import '../../core/network/interceptors/auth_interceptor.dart';
import '../../core/network/interceptors/token_refresh_interceptor.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/check_auth_status_usecase.dart';
import 'domain/usecases/get_profile_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/auth_event.dart';

Future<void> initAuthFeature(GetIt di) async {
  // Storage
  di.registerLazySingleton(() => const FlutterSecureStorage());

  // Network / Core
  di.registerLazySingleton<ApiClient>(() {
    final secureStorage = di<FlutterSecureStorage>();
    final authInterceptor = AuthInterceptor(secureStorage);
    
    // Create a separate Dio for refreshing to avoid interceptor loop
    final refreshDio = Dio(BaseOptions(baseUrl: Environment.current.apiBaseUrl));
    final tokenRefreshInterceptor = TokenRefreshInterceptor(
      secureStorage: secureStorage,
      dio: refreshDio,
      onAuthExpired: () {
        // Trigger logout when token refresh fails completely
        if (di.isRegistered<AuthBloc>()) {
          di<AuthBloc>().add(const AuthLogoutRequested());
        }
      },
    );
    
    return ApiClient(
      baseUrl: Environment.current.apiBaseUrl,
      authInterceptor: authInterceptor,
      tokenRefreshInterceptor: tokenRefreshInterceptor,
    );
  });

  // Data Sources
  di.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(di()),
  );
  di.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(di()),
  );

  // Repository
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(di(), di()),
  );

  // Use Cases
  di.registerLazySingleton(() => LoginUseCase(di()));
  di.registerLazySingleton(() => RegisterUseCase(di()));
  di.registerLazySingleton(() => LogoutUseCase(di()));
  di.registerLazySingleton(() => GetProfileUseCase(di()));
  di.registerLazySingleton(() => CheckAuthStatusUseCase(di()));

  // BLoC
  di.registerLazySingleton(
    () => AuthBloc(
      checkAuthStatusUseCase: di(),
      loginUseCase: di(),
      registerUseCase: di(),
      logoutUseCase: di(),
    ),
  );
}
