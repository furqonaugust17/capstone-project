import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/token_refresh_interceptor.dart';

class ApiClient {
  final Dio dio;

  ApiClient({
    required String baseUrl,
    required AuthInterceptor authInterceptor,
    required TokenRefreshInterceptor tokenRefreshInterceptor,
  }) : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: AppConstants.connectTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          sendTimeout: AppConstants.sendTimeout,
          headers: {'Content-Type': 'application/json'},
        )) {
    dio.interceptors.addAll([
      authInterceptor,
      tokenRefreshInterceptor,
      LoggingInterceptor(),
    ]);
  }
}
