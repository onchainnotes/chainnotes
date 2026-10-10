import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chain_notes/common/config/contract_config.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/features/home/data/service/gas_fee_calculator.dart';
import 'package:chain_notes/features/home/data/service/gas_speed.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_on_chain_confirm_provider.g.dart';

enum NoteOnChainConfirmResult {
  cancelled,
  confirmed,
  requestChangeGas,
}

@immutable
class NoteOnChainConfirmPop {
  const NoteOnChainConfirmPop._(this.result, [this.mintTxHash]);

  const NoteOnChainConfirmPop.cancelled()
      : this._(NoteOnChainConfirmResult.cancelled);

  const NoteOnChainConfirmPop.requestChangeGas()
      : this._(NoteOnChainConfirmResult.requestChangeGas);

  const NoteOnChainConfirmPop.confirmed()
      : this._(NoteOnChainConfirmResult.confirmed);

  const NoteOnChainConfirmPop.afterMint(String txHash)
      : this._(NoteOnChainConfirmResult.confirmed, txHash);

  final NoteOnChainConfirmResult result;

  final String? mintTxHash;
}

@immutable
class NotePublishResult {
  const NotePublishResult({required this.ok, this.txHash});

  final bool ok;
  final String? txHash;
}

@immutable
class NoteOnChainConfirmArgs {
  const NoteOnChainConfirmArgs({
    required this.chain,
    required this.fromAddress,
    required this.noteTitle,
    required this.noteContent,
    this.noteSha256Hex,
    this.contractDisplayName = 'OnChainNoteNFTProduct',
    this.gasSpeed,
    this.gasPrice = '--',
    this.gasLimit = '--',
    this.totalGasFee = '--',
    this.intentOnly = false,
  });

  final Chain chain;
  final String fromAddress;
  final String noteTitle;
  final String noteContent;
  final String? noteSha256Hex;
  final String contractDisplayName;
  final GasSpeed? gasSpeed;
  final String gasPrice;
  final String gasLimit;
  final String totalGasFee;
  final bool intentOnly;

  @override
  bool operator ==(Object other) {
    return other is NoteOnChainConfirmArgs &&
        other.chain.id == chain.id &&
        other.fromAddress == fromAddress &&
        other.noteTitle == noteTitle &&
        other.noteContent == noteContent &&
        other.noteSha256Hex == noteSha256Hex &&
        other.contractDisplayName == contractDisplayName &&
        other.gasSpeed == gasSpeed &&
        other.gasPrice == gasPrice &&
        other.gasLimit == gasLimit &&
        other.totalGasFee == totalGasFee &&
        other.intentOnly == intentOnly;
  }

  @override
  int get hashCode => Object.hash(
        chain.id,
        fromAddress,
        noteTitle,
        noteContent,
        noteSha256Hex,
        contractDisplayName,
        gasSpeed,
        gasPrice,
        gasLimit,
        totalGasFee,
        intentOnly,
      );
}

enum NoteOnChainUiGasSpeed { slow, normal, fast }

NoteOnChainUiGasSpeed noteOnChainUiGasSpeed(GasSpeed? s) {
  switch (s) {
    case GasSpeed.slow:
      return NoteOnChainUiGasSpeed.slow;
    case GasSpeed.fast:
      return NoteOnChainUiGasSpeed.fast;
    case GasSpeed.normal:
    case null:
      return NoteOnChainUiGasSpeed.normal;
  }
}

({String label, IconData icon, Color color, Color bg, String time})
    noteOnChainGasVisual(NoteOnChainUiGasSpeed s, bool isDark) {
  switch (s) {
    case NoteOnChainUiGasSpeed.slow:
      return (
        label: '慢速',
        icon: Icons.schedule_rounded,
        color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF4b5563),
        bg: isDark ? const Color(0xFF374151) : const Color(0xFFf3f4f6),
        time: '~5分钟',
      );
    case NoteOnChainUiGasSpeed.fast:
      return (
        label: '快速',
        icon: Icons.bolt_rounded,
        color: const Color(0xFFea580c),
        bg: isDark
            ? const Color(0xFF7c2d12).withValues(alpha: 0.35)
            : const Color(0xFFffedd5),
        time: '~15秒',
      );
    case NoteOnChainUiGasSpeed.normal:
      return (
        label: '标准',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFF2563eb),
        bg: isDark
            ? const Color(0xFF1e3a5f).withValues(alpha: 0.5)
            : const Color(0xFFdbeafe),
        time: '~1分钟',
      );
  }
}

String noteOnChainResolveHashHex(NoteOnChainConfirmArgs args) {
  final existing = args.noteSha256Hex?.trim();
  if (existing != null && existing.isNotEmpty) return existing;
  final digest = sha256.convert(
    utf8.encode('${args.noteTitle}\n${args.noteContent}'),
  );
  return digest.toString();
}

String noteOnChainDisplayTitle(NoteOnChainConfirmArgs args) {
  final t = args.noteTitle.trim();
  return t.isEmpty ? '（无标题）' : t;
}

String noteOnChainToContractAddress(NoteOnChainConfirmArgs args) {
  final cid = args.chain.chainId;
  if (cid != null && ContractConfig.contractByChainId.containsKey(cid)) {
    return ContractConfig.contractByChainId[cid]!;
  }
  return '0x0000000000000000000000000000000000000000';
}

String noteOnChainMintParamSummaryJson({
  required AppLocalizations l10n,
  required NoteOnChainConfirmArgs args,
  required String displayTitle,
  required String contentHashHex,
  required String contractAddress,
}) {
  final mintCall = <String, dynamic>{
    'abi': 'mintNote(string tokenUri, string contentUri)',
    'tokenUri': l10n.noteOnChainParamJsonValueUriPending,
    'contentUri': l10n.noteOnChainParamJsonValueUriPending,
  };

  final verifyContext = <String, dynamic>{
    l10n.noteOnChainParamJsonKeyNetwork: args.chain.displayNameOrName,
    if (args.chain.chainId != null)
      l10n.noteOnChainParamJsonKeyChainId: args.chain.chainId,
    l10n.noteOnChainParamJsonKeyFeeToken: args.chain.symbol,
    l10n.noteOnChainParamJsonKeySender: args.fromAddress.trim(),
    l10n.noteOnChainParamJsonKeyContract: contractAddress,
    l10n.noteOnChainParamJsonKeyContractName: args.contractDisplayName,
    l10n.noteOnChainParamJsonKeyFunction: 'mintNote',
    l10n.noteOnChainParamJsonKeyNoteTitle: displayTitle,
    l10n.noteOnChainParamJsonKeyContentSha256: contentHashHex,
  };

  final map = <String, dynamic>{
    l10n.noteOnChainParamJsonGroupMintCall: mintCall,
    l10n.noteOnChainParamJsonGroupContext: verifyContext,
  };
  return const JsonEncoder.withIndent('  ').convert(map);
}

String noteOnChainContentPreview(String content) {
  if (content.length <= 200) {
    return content.isEmpty ? '（无正文）' : content;
  }
  return '${content.substring(0, 200)}...';
}

String noteOnChainFormatAddress(String address) {
  if (address.contains('...')) return address;
  if (address.length < 10) return address;
  return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
}

String noteOnChainAvatarFromAddr(String address) {
  final t = address.trim();
  if (t.startsWith('0x') && t.length >= 4) {
    return t.substring(2, 4).toUpperCase();
  }
  if (t.length >= 2) return t.substring(0, 2).toUpperCase();
  return '?';
}

String noteOnChainHashShort(String hashHex) {
  if (hashHex.isEmpty) return '无';
  return hashHex.length > 16 ? '${hashHex.substring(0, 16)}...' : hashHex;
}

double _noteOnChainFallbackBaseGwei(String chainId) {
  final id = chainId.toLowerCase();
  const map = <String, double>{
    'ethereum': 30,
    'bsc': 5,
    'polygon': 30,
    'arbitrum': 0.1,
    'optimism': 0.001,
    'avalanche': 25,
    'fantom': 20,
    'base': 0.001,
    'holesky': 1,
    'sepolia': 1,
  };
  return map[id] ?? 20;
}

@immutable
class NoteOnChainConfirmUiState {
  const NoteOnChainConfirmUiState({
    required this.args,
    required this.resolvedHashHex,
    required this.displayTitle,
    required this.toContractAddress,
    required this.contentPreview,
    required this.showAdvanced,
    required this.showChainDetails,
    required this.showNoteHash,
    required this.isGasQuoteLoading,
    this.quotedGasPrice,
    this.quotedGasLimit,
    this.quotedTotalGasFee,
    this.displayNonce = '--',
  });

  final NoteOnChainConfirmArgs args;
  final String resolvedHashHex;
  final String displayTitle;
  final String toContractAddress;
  final String contentPreview;
  final bool showAdvanced;
  final bool showChainDetails;
  final bool showNoteHash;
  final bool isGasQuoteLoading;
  final String? quotedGasPrice;
  final String? quotedGasLimit;
  final String? quotedTotalGasFee;

  final String displayNonce;

  factory NoteOnChainConfirmUiState.initial(NoteOnChainConfirmArgs args) {
    final hash = noteOnChainResolveHashHex(args);
    final title = noteOnChainDisplayTitle(args);
    final to = noteOnChainToContractAddress(args);
    return NoteOnChainConfirmUiState(
      args: args,
      resolvedHashHex: hash,
      displayTitle: title,
      toContractAddress: to,
      contentPreview: noteOnChainContentPreview(args.noteContent),
      showAdvanced: false,
      showChainDetails: false,
      showNoteHash: false,
      isGasQuoteLoading: true,
    );
  }

  NoteOnChainConfirmUiState copyWith({
    bool? showAdvanced,
    bool? showChainDetails,
    bool? showNoteHash,
    bool? isGasQuoteLoading,
    String? quotedGasPrice,
    String? quotedGasLimit,
    String? quotedTotalGasFee,
    String? displayNonce,
  }) {
    return NoteOnChainConfirmUiState(
      args: args,
      resolvedHashHex: resolvedHashHex,
      displayTitle: displayTitle,
      toContractAddress: toContractAddress,
      contentPreview: contentPreview,
      showAdvanced: showAdvanced ?? this.showAdvanced,
      showChainDetails: showChainDetails ?? this.showChainDetails,
      showNoteHash: showNoteHash ?? this.showNoteHash,
      isGasQuoteLoading: isGasQuoteLoading ?? this.isGasQuoteLoading,
      quotedGasPrice: quotedGasPrice ?? this.quotedGasPrice,
      quotedGasLimit: quotedGasLimit ?? this.quotedGasLimit,
      quotedTotalGasFee: quotedTotalGasFee ?? this.quotedTotalGasFee,
      displayNonce: displayNonce ?? this.displayNonce,
    );
  }
}

@riverpod
class NoteOnChainConfirmController extends _$NoteOnChainConfirmController {
  static const int _gasUnits = 200000;

  @override
  NoteOnChainConfirmUiState build(NoteOnChainConfirmArgs args) {
    Future.microtask(_loadGasQuoteForSelectedSpeed);
    return NoteOnChainConfirmUiState.initial(args);
  }

  Future<void> _loadGasQuoteForSelectedSpeed() async {
    final chain = state.args.chain;
    final speed = state.args.gasSpeed ?? GasSpeed.normal;
    final from = state.args.fromAddress.trim();
    var nonceStr = '--';

    String? rpcUrl;
    try {
      rpcUrl = await resolveEffectivePrimaryNetworkUrl(
        chain,
        rpcUsageScenario: 'gas_fee_preview_eip1559',
      );
    } catch (_) {
      rpcUrl = null;
    }

    Eip1559FeeContext feeCtx;
    if (rpcUrl != null && rpcUrl.isNotEmpty) {
      try {
        feeCtx = await GasFeeCalculator.fetchEip1559FeeContextFromRpcUrl(
          rpcUrl,
        );
      } catch (_) {
        feeCtx = Eip1559FeeContext(
          baseFeeWei: BigInt.from(
            (_noteOnChainFallbackBaseGwei(chain.id) * 1e9).round(),
          ),
          suggestedPriorityFeeWei: BigInt.zero,
        );
      }
      if (from.isNotEmpty) {
        try {
          final n =
              await GasFeeCalculator.fetchPendingTransactionNonceFromRpcUrl(
            rpcUrl,
            from,
          );
          if (n != null) nonceStr = n.toString();
        } catch (_) {}
      }
    } else {
      feeCtx = Eip1559FeeContext(
        baseFeeWei: BigInt.from(
          (_noteOnChainFallbackBaseGwei(chain.id) * 1e9).round(),
        ),
        suggestedPriorityFeeWei: BigInt.zero,
      );
    }
    try {
      final q = GasFeeCalculator.quoteForSpeed(
        feeCtx.baseFeeWei,
        feeCtx.suggestedPriorityFeeWei,
        speed,
      );
      final maxFee = q.maxFeePerGas;
      final gwei = maxFee.toDouble() / 1e9;
      final gweiStr = gwei.toStringAsFixed(gwei < 1 ? 4 : 2);
      final costWei = maxFee * BigInt.from(_gasUnits);
      final nativeD = costWei.toDouble() / 1e18;
      final nativeStr = nativeD.toStringAsFixed(6);
      final limitStr = NumberFormat('#,###').format(_gasUnits);
      state = state.copyWith(
        isGasQuoteLoading: false,
        quotedGasPrice: gweiStr,
        quotedGasLimit: limitStr,
        quotedTotalGasFee: nativeStr,
        displayNonce: nonceStr,
      );
    } catch (_) {
      state = state.copyWith(
        isGasQuoteLoading: false,
        displayNonce: nonceStr,
      );
    }
  }

  void toggleShowAdvanced() {
    state = state.copyWith(showAdvanced: !state.showAdvanced);
  }

  void toggleShowChainDetails() {
    state = state.copyWith(showChainDetails: !state.showChainDetails);
  }

  void toggleShowNoteHash() {
    state = state.copyWith(showNoteHash: !state.showNoteHash);
  }
}
