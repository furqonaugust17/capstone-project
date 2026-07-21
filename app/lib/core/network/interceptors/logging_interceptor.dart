import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
      print('Headers: ${options.headers}');
      if (options.data != null) {
        print('Body: ${options.data}');
      }
      print('--> END ${options.method.toUpperCase()}');
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('<-- ${response.statusCode} ${response.requestOptions.baseUrl}${response.requestOptions.path}');
      print('Headers: ${response.headers}');
      print('Response: ${response.data}');
      print('<-- END HTTP');
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('<-- Error ${err.message}');
      print('<-- Error Response: ${err.response?.data}');
    }
    return handler.next(err);
  }
}
