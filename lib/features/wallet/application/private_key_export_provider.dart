import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/features/wallet/utils/evm_signing_helper.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'private_key_export_provider.g.dart';

enum PrivateKeyExportPhase {
  booting,
  ready,
  error,
}

class PrivateKeyExportState {
  const PrivateKeyExportState({
    required this.phase,
    required this.walletAddress,
    this.errorText,
    this.privateKeyHex,
    this.selectedChain,
    this.chainResolvedAddress,
    this.showPrivateKey = false,
    this.copied = false,
  });

  final PrivateKeyExportPhase phase;
  final String walletAddress;
  final String? errorText;
  final String? privateKeyHex;
  final Chain? selectedChain;
  final String? chainResolvedAddress;
  final bool showPrivateKey;
  final bool copied;

  PrivateKeyExportState copyWith({
    PrivateKeyExportPhase? phase,
    String? errorText,
    String? privateKeyHex,
    Chain? selectedChain,
    bool clearSelectedChain = false,
    String? chainResolvedAddress,
    bool clearChainResolvedAddress = false,
    bool? showPrivateKey,
    bool? copied,
  }) {
    return PrivateKeyExportState(
      phase: phase ?? this.phase,
      walletAddress: walletAddress,
      errorText: errorText ?? this.errorText,
      privateKeyHex: privateKeyHex ?? this.privateKeyHex,
      selectedChain: clearSelectedChain ? null : (selectedChain ?? this.selectedChain),
      chainResolvedAddress: clearChainResolvedAddress
          ? null
          : (chainResolvedAddress ?? this.chainResolvedAddress),
      showPrivateKey: showPrivateKey ?? this.showPrivateKey,
      copied: copied ?? this.copied,
    );
  }
}

@riverpod
List<Chain> privateKeyExportChains(Ref ref) {
  const want = [
    'Ethereum',
    'BSC',
    'Polygon',
    'Arbitrum',
    'Optimism',
    'Avalanche',
    'Fantom',
    'Base',
  ];
  final main = ChainFromDemo.mainnetChains;
  final byName = {for (final c in main) c.name: c};
  final list = <Chain>[];
  for (final n in want) {
    final c = byName[n];
    if (c != null) list.add(c);
  }
  if (list.isEmpty) {
    return main
        .where((c) => chainHasResolvableEndpoint(c) && (c.chainId ?? 0) > 0)
        .take(12)
        .toList();
  }
  return list;
}

String privateKeyBytesToHex(List<int> bytes) {
  final sb = StringBuffer('0x');
  for (final b in bytes) {
    sb.write(b.toRadixString(16).padLeft(2, '0'));
  }
  return sb.toString();
}

@riverpod
class PrivateKeyExport extends _$PrivateKeyExport {
  Timer? _copiedResetTimer;

  @override
  PrivateKeyExportState build(String walletAddress) {
    ref.onDispose(() {
      _copiedResetTimer?.cancel();
    });
    return PrivateKeyExportState(
      phase: PrivateKeyExportPhase.booting,
      walletAddress: walletAddress,
    );
  }

  Future<void> bootstrap(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (walletAddress.isEmpty) {
      state = state.copyWith(
        phase: PrivateKeyExportPhase.error,
        errorText: l10n.walletErrMissingAddress,
      );
      return;
    }

    if (!context.mounted) return;
    final masterKey = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PasswordVerifyDialog(
        purpose: PasswordVerifyPurpose.exportPrivateKey,
      ),
    );

    if (!context.mounted) return;
    if (masterKey == null) {
      context.pop();
      return;
    }

    final display = await loadCurrentWalletDisplayInfo(
      walletAddress,
      null,
    );
    final pk = await EvmSigningHelper.getEvmPrivateKey(
      masterKeyBase64: masterKey,
      currentAddress: walletAddress,
      evmAddressHint: display.protocolAddress,
    );

    if (!context.mounted) return;
    if (pk == null) {
      state = state.copyWith(
        phase: PrivateKeyExportPhase.error,
        errorText: l10n.walletErrGetPrivateKeyFailed,
      );
      return;
    }

    state = state.copyWith(
      phase: PrivateKeyExportPhase.ready,
      privateKeyHex: privateKeyBytesToHex(pk),
    );
  }

  void headerBack(BuildContext context) {
    if (state.selectedChain != null) {
      state = state.copyWith(
        clearSelectedChain: true,
        clearChainResolvedAddress: true,
        showPrivateKey: false,
        copied: false,
      );
    } else {
      context.pop();
    }
  }

  Future<void> openChainDetail(Chain c) async {
    final display = await loadCurrentWalletDisplayInfo(
      walletAddress,
      c.chainId,
    );
    String resolved;
    final p = display.protocolAddress;
    if (p != null && p.isNotEmpty) {
      resolved = p;
    } else {
      final derived =
          WalletUtils.getEvmAddressFromPrivateKey(state.privateKeyHex ?? '');
      resolved = derived ?? walletAddress;
    }
    state = state.copyWith(
      selectedChain: c,
      chainResolvedAddress: resolved,
      showPrivateKey: false,
      copied: false,
    );
  }

  void toggleShowPrivateKey() {
    state = state.copyWith(showPrivateKey: !state.showPrivateKey);
  }

  Future<void> copyPrivateKey(BuildContext context) async {
    final hex = state.privateKeyHex;
    if (hex == null || !state.showPrivateKey) return;
    await Clipboard.setData(ClipboardData(text: hex));
    if (!context.mounted) return;
    state = state.copyWith(copied: true);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.privateKeyCopied)),
    );
    _copiedResetTimer?.cancel();
    _copiedResetTimer = Timer(const Duration(seconds: 2), () {
      state = state.copyWith(copied: false);
    });
  }

  void backToChainList() {
    state = state.copyWith(
      clearSelectedChain: true,
      clearChainResolvedAddress: true,
      showPrivateKey: false,
      copied: false,
    );
  }
}
