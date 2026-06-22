import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  AuthInterceptor(this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip endpoints that don't require auth
    final path = options.path;
    if (path.contains(AppConstants.authLoginPath) ||
        path.contains(AppConstants.authRegisterPath) ||
        path.contains(AppConstants.authRefreshPath)) {
      return handler.next(options);
    }

    final accessToken = await secureStorage.read(key: AppConstants.accessTokenKey);
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }
}
