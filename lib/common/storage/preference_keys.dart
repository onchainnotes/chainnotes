
abstract final class PreferenceKeys {

  static const String currentChainId = 'current-chain-id';

  static const String currentWallet = 'current-wallet';

  static const String wallets = 'wallets';

  static const String walletMnemonic = 'wallet-mnemonic';

  static const String onboardingCompleted = 'onboarding-completed';

  static const String walletPrivateKey = 'wallet-privatekey';

  static const String boundEmail = 'bound-email';

  static const String themeMode = 'theme-mode';

  static const String appLanguageCode = 'app-language';

  static const String homeHideBalance = 'home-hide-balance';

  static const String networkNodesPrefix = 'network_nodes_';

  static String networkNodesKey(String chainId) =>
      '$networkNodesPrefix$chainId';
}
