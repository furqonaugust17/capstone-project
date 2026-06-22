import 'package:dio/dio.dart';
import '../exceptions/network_exception.dart';

class NetworkErrorHandler {
  static NetworkException handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Connection timed out');
      case DioExceptionType.connectionError:
        return const NoInternetException('No internet connection');
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response);
      default:
        return UnknownNetworkException(error.message ?? 'Unknown error');
    }
  }

  static NetworkException _handleStatusCode(Response? response) {
    final statusCode = response?.statusCode;
    final message = _extractMessage(response);
    switch (statusCode) {
      case 401:
        return UnauthorizedException(message, statusCode: statusCode);
      case 403:
        return ForbiddenException(message, statusCode: statusCode);
      case 404:
        return NotFoundException(message, statusCode: statusCode);
      case 409:
        return ConflictException(message, statusCode: statusCode);
      case 500:
        return ServerException(message, statusCode: statusCode);
      default:
        return UnknownNetworkException(message, statusCode: statusCode);
    }
  }

  static String _extractMessage(Response? response) {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? 'Unknown error';
    }
    return 'Unknown error';
  }
}
