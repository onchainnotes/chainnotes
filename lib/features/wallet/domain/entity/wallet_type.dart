
enum WalletType {

  created,

  importedMnemonic,

  importedPrivateKey,
}

extension WalletTypeX on WalletType {
  String get displayName => switch (this) {
    WalletType.created => '创建',
    WalletType.importedMnemonic => '恢复短语',
    WalletType.importedPrivateKey => '安全密钥',
  };
}
