import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/shared/preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

final goRouterProvider = Provider<GoRouter>((ref) => appRouter);

final homeWalletContextTickProvider = StateProvider<int>((ref) => 0);

final currentChainProvider =
    NotifierProvider<CurrentChainNotifier, Chain?>(CurrentChainNotifier.new);

class CurrentChainNotifier extends Notifier<Chain?> {
  @override
  Chain? build() {
    final fallback =
        ChainFromDemo.mainnetChains.isNotEmpty
            ? ChainFromDemo.mainnetChains.first
            : null;
    Future.microtask(() => _restoreSavedChain());
    return fallback;
  }

  Future<void> _restoreSavedChain() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(PreferenceKeys.currentChainId);
    if (savedId == null || savedId.isEmpty) return;
    final chain = ChainFromDemo.allChains.cast<Chain?>().firstWhere(
          (c) => c?.id == savedId,
          orElse: () => null,
        );
    if (chain != null) {
      state = chain;
    }
  }

  Future<void> setChain(Chain chain) async {
    state = chain;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.currentChainId, chain.id);
  }

  Future<void> clearSavedChain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PreferenceKeys.currentChainId);
    state =
        ChainFromDemo.mainnetChains.isNotEmpty
            ? ChainFromDemo.mainnetChains.first
            : null;
  }
}
