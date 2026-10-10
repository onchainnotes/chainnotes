import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/features/wallet/utils/evm_signing_helper.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mnemonic_backup_flow_provider.g.dart';

const List<String> kMnemonicBackupBip39Distractors = [
  'ability', 'able', 'about', 'above', 'absent', 'absorb', 'abstract', 'absurd',
  'abuse', 'access', 'accident', 'account', 'accuse', 'achieve', 'acid', 'acoustic',
  'acquire', 'across', 'act', 'action', 'actor', 'actual', 'adapt', 'add', 'address',
  'adjust', 'admit', 'adult', 'advance', 'advice', 'aerobic', 'affair', 'afford',
  'again', 'age', 'agent', 'agree', 'ahead', 'aim', 'air', 'airport', 'aisle',
  'alarm', 'album', 'alcohol', 'alert', 'alien', 'all', 'alley', 'allow', 'almost',
  'alone', 'alpha', 'already', 'also', 'alter', 'always', 'amateur', 'amazing',
];

enum MnemonicBackupLoadPhase {
  booting,
  ready,
  error,
}

class MnemonicBackupFlowState {
  const MnemonicBackupFlowState({
    required this.loadPhase,
    this.errorText,
    this.resolvedAgg,
    this.words = const [],
    this.step = 1,
    this.showMnemonic = false,
    this.copied = false,
    this.verifyIndices = const [],
    this.userSelections = const {},
    this.optionsPerIndex = const {},
  });

  final MnemonicBackupLoadPhase loadPhase;
  final String? errorText;
  final AggregatedWallet? resolvedAgg;
  final List<String> words;
  final int step;
  final bool showMnemonic;
  final bool copied;
  final List<int> verifyIndices;
  final Map<int, String> userSelections;
  final Map<int, List<String>> optionsPerIndex;

  bool get step3Verified {
    if (step != 3 || verifyIndices.length != 3) return false;
    if (userSelections.length != 3) return false;
    for (final i in verifyIndices) {
      if (userSelections[i] != words[i]) return false;
    }
    return true;
  }

  MnemonicBackupFlowState copyWith({
    MnemonicBackupLoadPhase? loadPhase,
    String? errorText,
    List<String>? words,
    AggregatedWallet? resolvedAgg,
    int? step,
    bool? showMnemonic,
    bool? copied,
    List<int>? verifyIndices,
    Map<int, String>? userSelections,
    Map<int, List<String>>? optionsPerIndex,
  }) {
    return MnemonicBackupFlowState(
      loadPhase: loadPhase ?? this.loadPhase,
      errorText: errorText ?? this.errorText,
      words: words ?? this.words,
      resolvedAgg: resolvedAgg ?? this.resolvedAgg,
      step: step ?? this.step,
      showMnemonic: showMnemonic ?? this.showMnemonic,
      copied: copied ?? this.copied,
      verifyIndices: verifyIndices ?? this.verifyIndices,
      userSelections: userSelections ?? this.userSelections,
      optionsPerIndex: optionsPerIndex ?? this.optionsPerIndex,
    );
  }
}

@riverpod
class MnemonicBackupFlow extends _$MnemonicBackupFlow {
  final Random _rng = Random.secure();
  Timer? _copiedResetTimer;

  @override
  MnemonicBackupFlowState build() {
    ref.onDispose(() {
      _copiedResetTimer?.cancel();
    });
    return MnemonicBackupFlowState(
      loadPhase: MnemonicBackupLoadPhase.booting,
      userSelections: {},
      optionsPerIndex: {},
    );
  }

  Future<void> bootstrap(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (!WalletUtils.hasWalletInRealm()) {
      state = state.copyWith(
        loadPhase: MnemonicBackupLoadPhase.error,
        errorText: l10n.walletErrNoWalletYet,
      );
      return;
    }

    final addr = await loadCurrentWalletAddress();
    final aggId = await loadCurrentAggregatedWalletId();
    if (aggId == null) {
      state = state.copyWith(
        loadPhase: MnemonicBackupLoadPhase.error,
        errorText: l10n.walletErrUnrecognizedAccount,
      );
      return;
    }

    final agg = WalletUtils.getRealmManager().loadAggregatedWalletByDbId(aggId);
    if (agg == null) {
      state = state.copyWith(
        loadPhase: MnemonicBackupLoadPhase.error,
        errorText: l10n.walletErrWalletDataNotFound,
      );
      return;
    }

    if (agg.walletType == WalletType.importedPrivateKey) {
      state = state.copyWith(
        loadPhase: MnemonicBackupLoadPhase.error,
        errorText: l10n.walletErrPrivateKeyWalletNoMnemonic,
      );
      return;
    }

    if (agg.encryptCore == null || agg.encryptCore!.isEmpty) {
      state = state.copyWith(
        loadPhase: MnemonicBackupLoadPhase.error,
        errorText: l10n.walletErrNoEncryptedMnemonic,
      );
      return;
    }

    if (!context.mounted) return;
    final masterKey = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PasswordVerifyDialog(
        purpose: PasswordVerifyPurpose.backupMnemonic,
      ),
    );

    if (!context.mounted) return;
    if (masterKey == null) {
      popOrGoHome(context);
      return;
    }

    final display = await loadCurrentWalletDisplayInfo(addr, null);
    final phrase = await EvmSigningHelper.getDecryptedMnemonic(
      masterKeyBase64: masterKey,
      currentAddress: addr,
      evmAddressHint: display.protocolAddress,
    );

    if (!context.mounted) return;
    if (phrase == null || phrase.isEmpty) {
      state = state.copyWith(
        loadPhase: MnemonicBackupLoadPhase.error,
        errorText: l10n.walletErrDecryptFailed,
      );
      return;
    }

    final words = phrase
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    state = state.copyWith(
      loadPhase: MnemonicBackupLoadPhase.ready,
      words: words,
      resolvedAgg: agg,
    );
  }

  List<String> _buildShuffledOptionsForWords(List<String> words, int wordIndex) {
    final correct = words[wordIndex];
    final wrong = <String>{};
    for (var i = 0; i < words.length; i++) {
      if (i != wordIndex) wrong.add(words[i]);
    }
    wrong.remove(correct);
    final picks = wrong.toList()..shuffle(_rng);
    final chosen = <String>[];
    for (final w in picks) {
      if (chosen.length >= 3) break;
      chosen.add(w);
    }
    var di = 0;
    while (chosen.length < 3) {
      final d = kMnemonicBackupBip39Distractors[
          di % kMnemonicBackupBip39Distractors.length];
      di++;
      if (d != correct && !chosen.contains(d)) chosen.add(d);
    }
    final all = [correct, ...chosen]..shuffle(_rng);
    return all;
  }

  Future<void> copyMnemonic(BuildContext context) async {
    if (!state.showMnemonic || state.words.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: state.words.join(' ')));
    if (!context.mounted) return;
    state = state.copyWith(copied: true);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.mnemonicCopied)),
    );
    _copiedResetTimer?.cancel();
    _copiedResetTimer = Timer(const Duration(seconds: 2), () {
      state = state.copyWith(copied: false);
    });
  }

  void toggleShowMnemonic() {
    state = state.copyWith(showMnemonic: !state.showMnemonic);
  }

  void selectVerifyWord(int wordIndex, String word) {
    state = state.copyWith(
      userSelections: {...state.userSelections, wordIndex: word},
    );
  }

  void onPrimaryButton(BuildContext context) {
    final step = state.step;
    if (step == 1) {
      state = state.copyWith(step: 2);
      return;
    }
    if (step == 2) {
      final words = state.words;
      if (words.length < 3) return;
      final idx = <int>{};
      while (idx.length < 3) {
        idx.add(_rng.nextInt(words.length));
      }
      final verifyIndices = idx.toList()..sort();
      final optionsPerIndex = <int, List<String>>{};
      for (final i in verifyIndices) {
        optionsPerIndex[i] = _buildShuffledOptionsForWords(words, i);
      }
      state = state.copyWith(
        step: 3,
        verifyIndices: verifyIndices,
        userSelections: {},
        optionsPerIndex: optionsPerIndex,
      );
      return;
    }
    if (step == 3) {
      if (!state.step3Verified) return;
      state = state.copyWith(step: 4);
      return;
    }
    if (step == 4) {
      final agg = state.resolvedAgg;
      if (agg != null && agg.id != null) {
        final next = agg.copyWith(hadBackup: true);
        WalletUtils.getRealmManager().saveAggregatedWallet(next);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          popAfterBackupComplete(context);
        }
      });
    }
  }

  void popAfterBackupComplete(BuildContext context) {
    if (!context.mounted) return;
    if (context.canPop()) {
      context.pop(true);
      return;
    }
    final nav = Navigator.maybeOf(context);
    if (nav != null && nav.canPop()) {
      nav.pop(true);
      return;
    }
    context.go(AppRoutes.home);
  }

  void popOrGoHome(BuildContext context) {
    if (!context.mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  void onBack(BuildContext context) {
    if (state.step > 1) {
      state = state.copyWith(step: state.step - 1);
    } else {
      popOrGoHome(context);
    }
  }
}
