sealed class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  const NetworkException(this.message, {this.statusCode});

  @override
  String toString() => '$runtimeType: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException(super.message, {super.statusCode});
}

class ForbiddenException extends NetworkException {
  const ForbiddenException(super.message, {super.statusCode});
}

class NotFoundException extends NetworkException {
  const NotFoundException(super.message, {super.statusCode});
}

class ConflictException extends NetworkException {
  const ConflictException(super.message, {super.statusCode});
}

class ServerException extends NetworkException {
  const ServerException(super.message, {super.statusCode});
}

class TimeoutException extends NetworkException {
  const TimeoutException(super.message, {super.statusCode});
}

class NoInternetException extends NetworkException {
  const NoInternetException(super.message, {super.statusCode});
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException(super.message, {super.statusCode});
}
