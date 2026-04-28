class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}

class SheetsException implements Exception {
  final String message;
  const SheetsException(this.message);
  @override
  String toString() => 'SheetsException: $message';
}

class QuotaExceededException implements Exception {
  @override
  String toString() => 'QuotaExceededException: Google Sheets API 할당량 초과';
}

class NetworkException implements Exception {
  @override
  String toString() => 'NetworkException: 네트워크 연결 없음';
}

class SheetCreateException implements Exception {
  final String message;
  const SheetCreateException(this.message);
  @override
  String toString() => 'SheetCreateException: $message';
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
  @override
  String toString() => 'ValidationException: $message';
}
