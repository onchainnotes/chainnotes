import 'dart:async';

import 'package:chain_notes/app/providers.dart';
import 'package:chain_notes/common/config/app_display_switches.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/home/data/service/main_token_balance_service.dart';
import 'package:chain_notes/features/home/data/service/main_token_usd_price_service.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/shared/preference_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_page_provider.g.dart';

class HomePageUiState {
  const HomePageUiState({
    this.currentWallet,
    this.currentWalletName,
    this.currentProtocolAddress,
    this.hideBalance = false,
    this.mainTokenBalance,
    this.balanceLoading = false,
    this.mainTokenUsdUnitPrice,
  });

  final String? currentWallet;
  final String? currentWalletName;
  final String? currentProtocolAddress;
  final bool hideBalance;
  final String? mainTokenBalance;
  final bool balanceLoading;
  final double? mainTokenUsdUnitPrice;

  HomePageUiState copyWith({
    String? currentWallet,
    String? currentWalletName,
    String? currentProtocolAddress,
    bool? hideBalance,
    String? mainTokenBalance,
    bool? balanceLoading,
    double? mainTokenUsdUnitPrice,
    bool clearMainTokenBalance = false,
    bool clearMainTokenUsdUnitPrice = false,
  }) {
    return HomePageUiState(
      currentWallet: currentWallet ?? this.currentWallet,
      currentWalletName: currentWalletName ?? this.currentWalletName,
      currentProtocolAddress:
          currentProtocolAddress ?? this.currentProtocolAddress,
      hideBalance: hideBalance ?? this.hideBalance,
      mainTokenBalance:
          clearMainTokenBalance ? null : (mainTokenBalance ?? this.mainTokenBalance),
      balanceLoading: balanceLoading ?? this.balanceLoading,
      mainTokenUsdUnitPrice: clearMainTokenUsdUnitPrice
          ? null
          : (mainTokenUsdUnitPrice ?? this.mainTokenUsdUnitPrice),
    );
  }
}

@Riverpod(keepAlive: true)
class HomePageUi extends _$HomePageUi {
  int _walletLoadSeq = 0;

  @override
  HomePageUiState build() {
    ref.listen<Chain?>(currentChainProvider, (_, next) {
      unawaited(_reloadWalletAndBalances(next));
    });
    ref.listen<int>(homeWalletContextTickProvider, (previous, next) {
      if (previous == next) return;
      unawaited(_reloadWalletAndBalances(ref.read(currentChainProvider)));
    });
    Future.microtask(
      () => _reloadWalletAndBalances(ref.read(currentChainProvider)),
    );
    Future.microtask(_restoreHideBalancePreference);
    return const HomePageUiState();
  }

  void toggleHideBalance() {
    final next = !state.hideBalance;
    state = state.copyWith(hideBalance: next);
    unawaited(_persistHideBalancePreference(next));
  }

  Future<void> _restoreHideBalancePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(PreferenceKeys.homeHideBalance);
    if (saved == null) return;
    state = state.copyWith(hideBalance: saved);
  }

  Future<void> _persistHideBalancePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferenceKeys.homeHideBalance, value);
  }

  Future<void> refreshMainTokenBalance() async {
    final chain = ref.read(currentChainProvider);
    final address = state.currentProtocolAddress ?? state.currentWallet;
    if (chain == null || address == null) {
      state = state.copyWith(
        clearMainTokenBalance: true,
        clearMainTokenUsdUnitPrice: true,
        balanceLoading: false,
      );
      return;
    }

    unawaited(_loadMainTokenUsdPrice(chain));

    if (!chainHasResolvableEndpoint(chain)) {
      state = state.copyWith(clearMainTokenBalance: true, balanceLoading: false);
      return;
    }

    final chainIdAtRequest = chain.id;
    state = state.copyWith(balanceLoading: true);
    final balance = await MainTokenBalanceService.instance.getMainTokenBalance(
      chain: chain,
      address: address,
    );
    if (ref.read(currentChainProvider)?.id != chainIdAtRequest) return;
    state = state.copyWith(mainTokenBalance: balance, balanceLoading: false);
  }

  Future<void> _reloadWalletAndBalances(Chain? chain) async {
    final seq = ++_walletLoadSeq;
    final addr = await loadCurrentWalletAddress();
    if (seq != _walletLoadSeq) return;
    final displayInfo = await loadCurrentWalletDisplayInfo(
      addr,
      chain?.chainId,
    );
    if (seq != _walletLoadSeq) return;
    state = state.copyWith(
      currentWallet: addr,
      currentWalletName: displayInfo.walletName,
      currentProtocolAddress: displayInfo.protocolAddress ?? addr,
      clearMainTokenBalance: true,
      balanceLoading: true,
    );
    await _applyMainTokenBalanceAfterWallet(seq);
  }

  Future<void> _applyMainTokenBalanceAfterWallet(int seq) async {
    final chain = ref.read(currentChainProvider);
    final address = state.currentProtocolAddress ?? state.currentWallet;
    if (chain == null || address == null) {
      if (seq != _walletLoadSeq) return;
      state = state.copyWith(
        clearMainTokenBalance: true,
        clearMainTokenUsdUnitPrice: true,
        balanceLoading: false,
      );
      return;
    }

    unawaited(_loadMainTokenUsdPrice(chain));

    if (!chainHasResolvableEndpoint(chain)) {
      if (seq != _walletLoadSeq) return;
      state = state.copyWith(clearMainTokenBalance: true, balanceLoading: false);
      return;
    }

    final chainIdAtRequest = chain.id;
    if (seq != _walletLoadSeq) return;
    state = state.copyWith(balanceLoading: true);
    final balance = await MainTokenBalanceService.instance.getMainTokenBalance(
      chain: chain,
      address: address,
    );
    if (seq != _walletLoadSeq) return;
    if (ref.read(currentChainProvider)?.id != chainIdAtRequest) return;
    state = state.copyWith(mainTokenBalance: balance, balanceLoading: false);
  }

  Future<void> _loadMainTokenUsdPrice(Chain chain) async {
    if (!AppDisplaySwitches.showFiatUsdValues) {
      final chainKey = chain.id;
      if (ref.read(currentChainProvider)?.id != chainKey) return;
      state = state.copyWith(clearMainTokenUsdUnitPrice: true);
      return;
    }
    final chainKey = chain.id;
    final price =
        await MainTokenUsdPriceService.instance.getUsdUnitPriceForChain(chain);
    if (ref.read(currentChainProvider)?.id != chainKey) return;
    state = state.copyWith(mainTokenUsdUnitPrice: price);
  }
}
