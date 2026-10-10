import 'package:chain_notes/features/wallet/data/mapper/wallet_mapper.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';

class AggregatedWalletMapper {
  const AggregatedWalletMapper._();

  static AggregatedWallet fromMap(Map<String, dynamic> map) {
    final list = map['wallets'] as List<dynamic>? ?? [];
    final wallets = list
        .cast<Map<String, dynamic>>()
        .map((e) => WalletMapper.fromMap(e))
        .toList();
    final currentId = map['currentWalletId'] as String?;
    final updatedAt = map['updatedAt'] as int?;
    return AggregatedWallet(
      walletType: WalletType.created,
      wallets: wallets,
      currentWalletId: currentId,
      updatedAt: updatedAt,
    );
  }

  static Map<String, dynamic> toMap(AggregatedWallet entity) {
    return {
      'wallets': entity.wallets.map(WalletMapper.toMap).toList(),
      if (entity.currentWalletId != null)
        'currentWalletId': entity.currentWalletId,
      if (entity.updatedAt != null) 'updatedAt': entity.updatedAt,
    };
  }
}
