import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chain_notes/common/utils/evm_rpc_latency.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/settings/domain/network_rpc_defaults.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chain_selector_provider.g.dart';

@Riverpod(keepAlive: true)
List<Chain> chainSelectorMainnetChains(Ref ref) {
  return ChainFromDemo.mainnetChains;
}

@Riverpod(keepAlive: true)
List<Chain> chainSelectorTestnetChains(Ref ref) {
  return ChainFromDemo.testnetChains;
}

@riverpod
Future<int?> chainSelectorRpcLatency(Ref ref, String chainId) async {
  final chain = chainByNetworkSettingsId(chainId);
  if (chain == null) return null;
  final url = await resolveEffectivePrimaryNetworkUrl(chain);
  final u = url?.trim();
  if (u == null || u.isEmpty) return null;
  return measureEvmJsonRpcLatencyMs(
    u,
    timeout: const Duration(seconds: 6),
  );
}

bool chainSelectorIsAllChainsRowSelected({
  required bool showAllChainsOption,
  required int? currentChainId,
}) {
  return showAllChainsOption && currentChainId == null;
}

bool chainSelectorIsChainRowSelected({
  required Chain chain,
  required Chain? currentChain,
  required int? currentChainId,
  required bool showAllChainsOption,
}) {
  if (showAllChainsOption) {
    return currentChainId != null && currentChain?.chainId == chain.chainId;
  }
  return currentChain?.id == chain.id;
}
