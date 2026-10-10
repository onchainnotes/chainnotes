import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chain_notes/features/wallet/data/datasource/realm/wallet_realm_manager.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';

class WalletInfoState {
  const WalletInfoState({this.aggregatedWallet});

  final AggregatedWallet? aggregatedWallet;

  Wallet? get currentWallet => aggregatedWallet?.currentWallet;

  List<Wallet> get wallets => aggregatedWallet?.wallets ?? [];

  bool get hasWallet => aggregatedWallet != null && aggregatedWallet!.hasAny;

  WalletInfoState copyWith({AggregatedWallet? aggregatedWallet}) {
    return WalletInfoState(
      aggregatedWallet: aggregatedWallet ?? this.aggregatedWallet,
    );
  }
}

class WalletInfoNotifier extends Notifier<WalletInfoState> {
  @override
  WalletInfoState build() {
    return const WalletInfoState();
  }

  static WalletRealmManager _getRealmManager() {
    return WalletRealmManager();
  }

  void loadFromRealm() {
    final manager = _getRealmManager();
    final list = manager.loadAllAggregatedWallets();
    if (list.isNotEmpty) {
      state = state.copyWith(aggregatedWallet: list.first);
    }
  }

  void setAggregatedWallet(AggregatedWallet? aggregatedWallet) {
    state = state.copyWith(aggregatedWallet: aggregatedWallet);
  }

  void setCurrentWallet(String? walletId) {
    final agg = state.aggregatedWallet;
    if (agg == null) return;
    if (walletId != null && agg.walletById(walletId) == null) return;
    final next = agg.setCurrentWallet(walletId);
    state = state.copyWith(aggregatedWallet: next);
    _getRealmManager().saveAggregatedWallet(next);
  }

  void clear() {
    state = const WalletInfoState();
  }
}

final walletInfoProvider =
    NotifierProvider<WalletInfoNotifier, WalletInfoState>(
      WalletInfoNotifier.new,
    );

final currentWalletProvider = Provider<Wallet?>((ref) {
  return ref.watch(walletInfoProvider).currentWallet;
});

final aggregatedWalletProvider = Provider<AggregatedWallet?>((ref) {
  return ref.watch(walletInfoProvider).aggregatedWallet;
});
