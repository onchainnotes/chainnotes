

class BlockscoutProConfig {
  BlockscoutProConfig._();

  static const String _fromEnv = String.fromEnvironment(
    'BLOCKSCOUT_PRO_API_KEY',
    defaultValue: '',
  );

  static const String _embeddedDefault = '';

  static String get apiKey {
    final e = _fromEnv.trim();
    if (e.isNotEmpty) return e;
    return _embeddedDefault.trim();
  }
}
