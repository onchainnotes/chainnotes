import 'package:chain_notes/features/wallet/domain/entity/chain_type.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';

class Protocol {
  const Protocol({
    required this.publicKeyHex,
    required this.address,
    required this.derivationPath,
    required this.walletCoreCoinType,
    required this.protocolType,
  });

  final String publicKeyHex;
  final String address;
  final String derivationPath;
  final int walletCoreCoinType;
  final int protocolType;
}

class Wallet {
  const Wallet({
    required this.id,
    required this.address,
    required this.type,
    this.name,
    this.chainType = ChainType.evm,
    required this.createdAt,
    this.updatedAt,
    this.walletId,
    this.accountId,
    this.totalAmountUsd = 0.0,
    this.walletCoreCoinType,
    this.defaultPublicKey,
    this.defaultAddress,
    this.derivationPath,
    this.protocolAccounts = const [],
  });

  final String id;

  final String address;

  final WalletType type;

  final String? name;

  final ChainType chainType;

  final int createdAt;

  final int? updatedAt;

  final int? walletId;

  final String? accountId;

  final double totalAmountUsd;

  final int? walletCoreCoinType;

  final String? defaultPublicKey;

  final String? defaultAddress;

  final String? derivationPath;

  final List<Protocol> protocolAccounts;

  String get displayName => name ?? _shortAddress;

  String get _shortAddress {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  Wallet copyWith({
    String? id,
    String? address,
    WalletType? type,
    String? name,
    ChainType? chainType,
    int? createdAt,
    int? updatedAt,
    int? walletId,
    String? accountId,
    double? totalAmountUsd,
    int? walletCoreCoinType,
    String? defaultPublicKey,
    String? defaultAddress,
    String? derivationPath,
    List<Protocol>? protocolAccounts,
  }) {
    return Wallet(
      id: id ?? this.id,
      address: address ?? this.address,
      type: type ?? this.type,
      name: name ?? this.name,
      chainType: chainType ?? this.chainType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      walletId: walletId ?? this.walletId,
      accountId: accountId ?? this.accountId,
      totalAmountUsd: totalAmountUsd ?? this.totalAmountUsd,
      walletCoreCoinType: walletCoreCoinType ?? this.walletCoreCoinType,
      defaultPublicKey: defaultPublicKey ?? this.defaultPublicKey,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      derivationPath: derivationPath ?? this.derivationPath,
      protocolAccounts: protocolAccounts ?? this.protocolAccounts,
    );
  }
}
