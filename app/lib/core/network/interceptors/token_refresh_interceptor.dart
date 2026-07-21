import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import '../../constants/app_constants.dart';

class TokenRefreshInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final Dio dio;
  final Function? onAuthExpired;
  
  bool _isRefreshing = false;
  final _requestsQueue = <Completer<Response>>[];

  TokenRefreshInterceptor({
    required this.secureStorage,
    required this.dio,
    this.onAuthExpired,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip refresh endpoint itself
    if (err.requestOptions.path.contains(AppConstants.authRefreshPath)) {
      return handler.next(err);
    }

    final refreshToken = await secureStorage.read(key: AppConstants.refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      _logout();
      return handler.next(err);
    }

    if (_isRefreshing) {
      final completer = Completer<Response>();
      _requestsQueue.add(completer);
      try {
        final response = await completer.future;
        final newOptions = _updateHeaders(err.requestOptions, response.requestOptions.headers['Authorization'] as String?);
        return handler.resolve(await dio.fetch(newOptions));
      } catch (e) {
        return handler.next(err);
      }
    }

    _isRefreshing = true;

    try {
      final response = await dio.post(
        AppConstants.authRefreshPath,
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['data']['accessToken'] as String?;
      if (newAccessToken != null) {
        await secureStorage.write(key: AppConstants.accessTokenKey, value: newAccessToken);

        // Resolve queued requests
        for (final completer in _requestsQueue) {
          completer.complete(response);
        }
        _requestsQueue.clear();

        // Retry original request
        final newOptions = _updateHeaders(err.requestOptions, 'Bearer $newAccessToken');
        final retryResponse = await dio.fetch(newOptions);
        return handler.resolve(retryResponse);
      } else {
        _logout();
        return handler.next(err);
      }
    } catch (e) {
      for (final completer in _requestsQueue) {
        completer.completeError(e);
      }
      _requestsQueue.clear();
      _logout();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  void _logout() {
    secureStorage.delete(key: AppConstants.accessTokenKey);
    secureStorage.delete(key: AppConstants.refreshTokenKey);
    onAuthExpired?.call();
  }

  RequestOptions _updateHeaders(RequestOptions options, String? authHeader) {
    if (authHeader != null) {
      options.headers['Authorization'] = authHeader;
    }
    return options;
  }
}
