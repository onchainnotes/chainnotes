

class EtherscanConfig {
  EtherscanConfig._();

  static const String _fromEnv = String.fromEnvironment(
    'ETHERSCAN_API_KEY',
    defaultValue: '',
  );

  static const String _embeddedDefault = '{sensitive information}';

  static String get apiKey {
    final fromEnv = _fromEnv.trim();
    if (fromEnv.isNotEmpty) return fromEnv;
    final embedded = _embeddedDefault.trim();
    if (embedded.isEmpty || embedded == '{sensitive information}') return '';
    return embedded;
  }
}
