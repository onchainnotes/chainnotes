import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';

bool walletManagementAddrEqualsPk(String a, String b) {
  if (a == b) return true;
  if (a.startsWith('0x') && b.startsWith('0x')) {
    return a.toLowerCase() == b.toLowerCase();
  }
  return false;
}

AggregatedWallet? walletManagementAggregatedForRepresentativeAddress(
  String address,
) {
  try {
    final list = WalletUtils.getRealmManager().loadAllAggregatedWallets();
    for (final agg in list) {
      final rep = agg.currentWallet?.address ??
          (agg.wallets.isNotEmpty ? agg.wallets.first.address : null);
      if (rep != null && walletManagementAddrEqualsPk(rep, address)) {
        return agg;
      }
      for (final w in agg.wallets) {
        if (walletManagementAddrEqualsPk(w.address, address)) return agg;
        for (final p in w.protocolAccounts) {
          if (walletManagementAddrEqualsPk(p.address, address)) return agg;
        }
      }
    }
  } catch (_) {}
  return null;
}
