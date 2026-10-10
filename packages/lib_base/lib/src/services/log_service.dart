import 'package:flutter/foundation.dart';

class LogService {
  static const String _tag = '[lib_base]';

  static void d(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint('$_tag${tag != null ? '[$tag]' : ''} $message');
    }
  }

  static void i(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint('$_tag${tag != null ? '[$tag]' : ''} ℹ️ $message');
    }
  }

  static void w(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint('$_tag${tag != null ? '[$tag]' : ''} ⚠️ $message');
    }
  }

  static void e(String message, [Object? error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      debugPrint('$_tag${tag != null ? '[$tag]' : ''} ❌ $message');
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }
}
