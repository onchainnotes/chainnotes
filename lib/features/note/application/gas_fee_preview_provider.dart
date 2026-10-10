import 'package:flutter/foundation.dart';
import 'package:chain_notes/features/home/data/service/gas_fee_calculator.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/home/data/service/gas_speed.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gas_fee_preview_provider.g.dart';

const double kGasFeeEthUsdEstimate = 2500;

@immutable
class GasFeeOption {
  const GasFeeOption({
    required this.speed,
    required this.nativeAmount,
    required this.gweiMax,
  });

  final GasSpeed speed;

  final double nativeAmount;

  final double gweiMax;
}

@immutable
class GasFeePreviewArgs {
  const GasFeePreviewArgs({
    required this.chain,
    required this.noteId,
    required this.noteSizeBytes,
  });

  final Chain chain;
  final String noteId;
  final int noteSizeBytes;

  @override
  bool operator ==(Object other) {
    return other is GasFeePreviewArgs &&
        other.noteId == noteId &&
        other.noteSizeBytes == noteSizeBytes &&
        other.chain.id == chain.id;
  }

  @override
  int get hashCode => Object.hash(noteId, noteSizeBytes, chain.id);
}

@immutable
class GasFeePreviewState {
  const GasFeePreviewState({
    required this.args,
    required this.selectedSpeed,
    required this.isLoading,
    required this.options,
  });

  final GasFeePreviewArgs args;
  final GasSpeed selectedSpeed;
  final bool isLoading;
  final List<GasFeeOption> options;

  Chain get chain => args.chain;
  int get noteSizeBytes => args.noteSizeBytes;

  GasFeeOption? get selectedOption {
    for (final o in options) {
      if (o.speed == selectedSpeed) return o;
    }
    return options.isEmpty ? null : options.first;
  }

  factory GasFeePreviewState.initial(GasFeePreviewArgs args) {
    return GasFeePreviewState(
      args: args,
      selectedSpeed: GasSpeed.normal,
      isLoading: true,
      options: const [],
    );
  }

  GasFeePreviewState copyWith({
    GasSpeed? selectedSpeed,
    bool? isLoading,
    List<GasFeeOption>? options,
  }) {
    return GasFeePreviewState(
      args: args,
      selectedSpeed: selectedSpeed ?? this.selectedSpeed,
      isLoading: isLoading ?? this.isLoading,
      options: options ?? this.options,
    );
  }
}

@riverpod
class GasFeePreview extends _$GasFeePreview {
  @override
  GasFeePreviewState build(GasFeePreviewArgs args) {
    Future.microtask(_loadOptions);
    return GasFeePreviewState.initial(args);
  }

  double _baseGwei(String chainId) {
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

  List<GasFeeOption> _generateOptions(
    Chain chain,
    Eip1559FeeContext feeCtx, {
    int gasUnits = 200000,
  }) {
    GasFeeOption one(GasSpeed speed) {
      final q = GasFeeCalculator.quoteForSpeed(
        feeCtx.baseFeeWei,
        feeCtx.suggestedPriorityFeeWei,
        speed,
      );
      final maxFee = q.maxFeePerGas;
      final gwei = maxFee.toDouble() / 1e9;
      final costWei = maxFee * BigInt.from(gasUnits);
      final nativeD = costWei.toDouble() / 1e18;
      return GasFeeOption(
        speed: speed,
        nativeAmount: nativeD,
        gweiMax: gwei,
      );
    }

    return [
      one(GasSpeed.slow),
      one(GasSpeed.normal),
      one(GasSpeed.fast),
    ];
  }

  Future<void> _loadOptions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    Eip1559FeeContext feeCtx;
    try {
      final url = await resolveEffectivePrimaryNetworkUrl(
        state.args.chain,
        rpcUsageScenario: 'gas_fee_preview_eip1559',
      );
      if (url != null && url.isNotEmpty) {
        feeCtx = await GasFeeCalculator.fetchEip1559FeeContextFromRpcUrl(url);
      } else {
        feeCtx = Eip1559FeeContext(
          baseFeeWei: BigInt.from((_baseGwei(state.args.chain.id) * 1e9).round()),
          suggestedPriorityFeeWei: BigInt.zero,
        );
      }
    } catch (_) {
      feeCtx = Eip1559FeeContext(
        baseFeeWei: BigInt.from((_baseGwei(state.args.chain.id) * 1e9).round()),
        suggestedPriorityFeeWei: BigInt.zero,
      );
    }
    try {
      state = state.copyWith(
        isLoading: false,
        options: _generateOptions(state.args.chain, feeCtx),
      );
    } catch (_) {}
  }

  void setSpeed(GasSpeed speed) {
    state = state.copyWith(selectedSpeed: speed);
  }
}
