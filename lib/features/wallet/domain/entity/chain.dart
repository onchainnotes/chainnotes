

class Chain {
  const Chain({
    required this.id,
    required this.name,
    required this.symbol,
    required this.colorValue,
    this.displayName,
    this.chainId,
    this.icon,
    this.isTestnet = false,
    this.avgGasCost = 'medium',
    this.blockTime = '~12s',
    this.description,
    this.rpcUrl,
    this.restfulUrl,
    this.mainTokenDecimals = 18,
    this.chainLogo,
    this.explorerUrl,
    List<String>? faucetUrls,
  }) : faucetUrls = faucetUrls ?? const [];

  final String id;
  final String name;
  final String symbol;
  final int colorValue;
  final String? displayName;
  final int? chainId;
  final String? icon;
  final bool isTestnet;
  final String avgGasCost;
  final String blockTime;
  final String? description;
  final String? rpcUrl;
  final String? restfulUrl;
  final int mainTokenDecimals;
  final String? chainLogo;
  final String? explorerUrl;

  final List<String> faucetUrls;

  String get displayNameOrName => displayName ?? name;
}
