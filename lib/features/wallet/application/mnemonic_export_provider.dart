import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';
import 'package:chain_notes/features/wallet/presentation/mnemonic_export_file.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/wallet/utils/evm_signing_helper.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:go_router/go_router.dart';

part 'mnemonic_export_provider.g.dart';

enum MnemonicExportPhase {
  booting,
  ready,
  error,
}

class MnemonicExportState {
  const MnemonicExportState({
    required this.phase,
    this.errorText,
    this.words = const [],
    this.showMnemonic = false,
    this.copied = false,
    this.resolvedAgg,
    this.saved = false,
    this.understand = false,
    this.responsibility = false,
  });

  final MnemonicExportPhase phase;
  final String? errorText;
  final List<String> words;
  final bool showMnemonic;
  final bool copied;
  final AggregatedWallet? resolvedAgg;
  final bool saved;
  final bool understand;
  final bool responsibility;

  bool get allConfirmed => saved && understand && responsibility;

  MnemonicExportState copyWith({
    MnemonicExportPhase? phase,
    String? errorText,
    List<String>? words,
    bool? showMnemonic,
    bool? copied,
    AggregatedWallet? resolvedAgg,
    bool? saved,
    bool? understand,
    bool? responsibility,
  }) {
    return MnemonicExportState(
      phase: phase ?? this.phase,
      errorText: errorText ?? this.errorText,
      words: words ?? this.words,
      showMnemonic: showMnemonic ?? this.showMnemonic,
      copied: copied ?? this.copied,
      resolvedAgg: resolvedAgg ?? this.resolvedAgg,
      saved: saved ?? this.saved,
      understand: understand ?? this.understand,
      responsibility: responsibility ?? this.responsibility,
    );
  }
}

@riverpod
class MnemonicExport extends _$MnemonicExport {
  Timer? _copiedResetTimer;

  @override
  MnemonicExportState build() {
    ref.onDispose(() {
      _copiedResetTimer?.cancel();
    });

    return const MnemonicExportState(
      phase: MnemonicExportPhase.booting,
    );
  }

  Future<void> bootstrap(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (!WalletUtils.hasWalletInRealm()) {
      state = state.copyWith(
        phase: MnemonicExportPhase.error,
        errorText: l10n.walletErrNoWalletYet,
      );
      return;
    }

    final addr = await loadCurrentWalletAddress();
    final aggId = await loadCurrentAggregatedWalletId();

    if (aggId == null) {
      state = state.copyWith(
        phase: MnemonicExportPhase.error,
        errorText: l10n.walletErrUnrecognizedAccount,
      );
      return;
    }

    final agg =
        WalletUtils.getRealmManager().loadAggregatedWalletByDbId(aggId);

    if (agg == null) {
      state = state.copyWith(
        phase: MnemonicExportPhase.error,
        errorText: l10n.walletErrWalletDataNotFound,
      );
      return;
    }

    if (agg.walletType == WalletType.importedPrivateKey) {
      state = state.copyWith(
        phase: MnemonicExportPhase.error,
        errorText: l10n.walletErrPrivateKeyWalletNoMnemonic,
      );
      return;
    }

    if (agg.encryptCore == null || agg.encryptCore!.isEmpty) {
      state = state.copyWith(
        phase: MnemonicExportPhase.error,
        errorText: l10n.walletErrNoEncryptedMnemonic,
      );
      return;
    }

    if (!context.mounted) return;

    final masterKey = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PasswordVerifyDialog(
        purpose: PasswordVerifyPurpose.exportMnemonic,
      ),
    );

    if (!context.mounted) return;

    if (masterKey == null) {
      context.pop();
      return;
    }

    final display = await loadCurrentWalletDisplayInfo(addr, null);

    final phrase =
        await EvmSigningHelper.getDecryptedMnemonic(
          masterKeyBase64: masterKey,
          currentAddress: addr,
          evmAddressHint: display.protocolAddress,
        );

    if (!context.mounted) return;

    if (phrase == null || phrase.isEmpty) {
      state = state.copyWith(
        phase: MnemonicExportPhase.error,
        errorText: l10n.walletErrDecryptFailed,
      );
      return;
    }

    final words = phrase
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    state = state.copyWith(
      phase: MnemonicExportPhase.ready,
      words: words,
      resolvedAgg: agg,
    );
  }

  String exportBody(AppLocalizations l10n) {
    final ts = DateTime.now().toLocal().toString().split('.').first;
    return '${l10n.exportMnemonicDocTitle}\n${l10n.exportMnemonicDocTime(ts)}\n\n'
        '${l10n.exportMnemonicDocLabel}\n${state.words.join(' ')}\n\n'
        '${l10n.exportMnemonicDocSecurity}';
  }

  Future<void> copyMnemonic(BuildContext context) async {
    if (!state.showMnemonic || state.words.isEmpty) return;

    await Clipboard.setData(
      ClipboardData(text: state.words.join(' ')),
    );

    if (!context.mounted) return;

    state = state.copyWith(copied: true);

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.mnemonicCopied)),
    );

    _copiedResetTimer?.cancel();

    _copiedResetTimer =
        Timer(const Duration(seconds: 2), () {
          state = state.copyWith(copied: false);
        });
  }

  Future<void> downloadMnemonic(BuildContext context) async {
    if (!state.showMnemonic) return;

    final l10n = AppLocalizations.of(context)!;
    final path =
        await writeMnemonicBackupFile(exportBody(l10n));

    if (!context.mounted) return;

    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportMnemonicUseCopyOnPlatform)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.exportMnemonicSavedTo(path))),
    );
  }

  void toggleShowMnemonic() {
    state = state.copyWith(
      showMnemonic: !state.showMnemonic,
    );
  }

  void setSaved(bool v) {
    state = state.copyWith(saved: v);
  }

  void setUnderstand(bool v) {
    state = state.copyWith(understand: v);
  }

  void setResponsibility(bool v) {
    state = state.copyWith(responsibility: v);
  }

  void finish(BuildContext context) {
    final agg = state.resolvedAgg;

    if (agg != null && agg.id != null) {
      final next = agg.copyWith(
        hadBackup: true,
      );

      WalletUtils
          .getRealmManager()
          .saveAggregatedWallet(next);
    }

    context.pop();
  }
}
