
sealed class AppError {
  const AppError();
  String get message;
}

final class NetworkError extends AppError {
  const NetworkError([this.message = '网络错误']);
  @override
  final String message;
}

final class ValidationError extends AppError {
  const ValidationError([this.message = '校验失败']);
  @override
  final String message;
}

final class UnauthorizedError extends AppError {
  const UnauthorizedError([this.message = '未授权']);
  @override
  final String message;
}

final class UnknownError extends AppError {
  const UnknownError([this.message = '未知错误']);
  @override
  final String message;
}
