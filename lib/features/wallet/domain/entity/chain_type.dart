
enum ChainType {

  evm,

  btc,

  other,
}

extension ChainTypeX on ChainType {
  String get displayName => switch (this) {
    ChainType.evm => 'EVM',
    ChainType.btc => 'BTC',
    ChainType.other => '其他',
  };
}
