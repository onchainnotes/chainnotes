import 'package:chain_notes/features/wallet/domain/entity/chain_type.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';

class WalletMapper {
  const WalletMapper._();

  static Wallet fromMap(Map<String, dynamic> map) {
    final protocolsRaw = map['protocolAccounts'] as List<dynamic>? ?? [];
    final protocolAccounts = protocolsRaw
        .cast<Map<String, dynamic>>()
        .map(_protocolFromMap)
        .toList();
    return Wallet(
      id: map['id'] as String,
      address: map['address'] as String,
      type: _parseWalletType(map['type'] as String?),
      name: map['name'] as String?,
      chainType: _parseChainType(map['chainType'] as String?),
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      walletCoreCoinType: map['walletCoreCoinType'] as int?,
      defaultPublicKey: map['defaultPublicKey'] as String?,
      defaultAddress: map['defaultAddress'] as String?,
      derivationPath: map['derivationPath'] as String?,
      protocolAccounts: protocolAccounts,
    );
  }

  static Protocol _protocolFromMap(Map<String, dynamic> map) {
    return Protocol(
      publicKeyHex: map['publicKeyHex'] as String,
      address: map['address'] as String,
      derivationPath: map['derivationPath'] as String,
      walletCoreCoinType: map['walletCoreCoinType'] as int,
      protocolType: map['protocolType'] as int,
    );
  }

  static WalletType _parseWalletType(String? v) {
    if (v == null) return WalletType.importedMnemonic;
    return WalletType.values.asNameMap()[v] ?? WalletType.importedMnemonic;
  }

  static ChainType _parseChainType(String? v) {
    if (v == null) return ChainType.evm;
    return ChainType.values.asNameMap()[v] ?? ChainType.evm;
  }

  static Map<String, dynamic> toMap(Wallet entity) {
    return {
      'id': entity.id,
      'address': entity.address,
      'type': entity.type.name,
      if (entity.name != null) 'name': entity.name,
      'chainType': entity.chainType.name,
      'createdAt': entity.createdAt,
      if (entity.updatedAt != null) 'updatedAt': entity.updatedAt,
      if (entity.walletCoreCoinType != null)
        'walletCoreCoinType': entity.walletCoreCoinType,
      if (entity.defaultPublicKey != null)
        'defaultPublicKey': entity.defaultPublicKey,
      if (entity.defaultAddress != null) 'defaultAddress': entity.defaultAddress,
      if (entity.derivationPath != null)
        'derivationPath': entity.derivationPath,
      'protocolAccounts': entity.protocolAccounts.map(_protocolToMap).toList(),
    };
  }

  static Map<String, dynamic> _protocolToMap(Protocol p) {
    return {
      'publicKeyHex': p.publicKeyHex,
      'address': p.address,
      'derivationPath': p.derivationPath,
      'walletCoreCoinType': p.walletCoreCoinType,
      'protocolType': p.protocolType,
    };
  }
}
