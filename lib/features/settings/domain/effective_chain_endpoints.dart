import 'package:flutter/foundation.dart';
import 'package:chain_notes/features/settings/domain/network_merged_nodes.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';

bool isTronChain(Chain chain) =>
    chain.name == 'Tron' ||
    chain.id == 'tron' ||
    chain.id.startsWith('tron');

bool chainHasResolvableEndpoint(Chain chain) {
  if (chain.rpcUrl?.trim().isNotEmpty == true) return true;
  if (chain.restfulUrl?.trim().isNotEmpty == true) return true;
  return ChainFromDemo.rpcAddressesOrderedForChainId(chain.id).isNotEmpty;
}

Future<String?> resolveEffectivePrimaryNetworkUrl(
  Chain chain, {
  String? rpcUsageScenario,
}) async {
  final merged = await loadMergedRpcNodesForChain(chain.id);
  RpcNodeUi? activeNode;
  for (final n in merged) {
    if (n.isActive) {
      activeNode = n;
      break;
    }
  }

  final activeUrl = activeNode?.url.trim();
  final selectedRpcLog = activeNode != null
      ? (activeUrl != null && activeUrl.isNotEmpty
          ? '${activeNode.id} | $activeUrl'
          : '${activeNode.id} | (URL为空)')
      : (merged.isEmpty ? '(无节点列表)' : '(合并结果无 isActive)');

  String? used;
  if (activeUrl != null && activeUrl.isNotEmpty) {
    used = activeUrl;
  }
  if (used == null || used.isEmpty) {
    if (merged.isNotEmpty) {
      final u = merged.first.url.trim();
      if (u.isNotEmpty) used = u;
    }
  }
  if (used == null || used.isEmpty) {
    if (isTronChain(chain)) {
      final r = chain.restfulUrl?.trim();
      if (r != null && r.isNotEmpty) used = r;
    }
  }
  if (used == null || used.isEmpty) {
    final fallback = chain.rpcUrl?.trim();
    if (fallback != null && fallback.isNotEmpty) used = fallback;
  }

  if (rpcUsageScenario != null && rpcUsageScenario.isNotEmpty) {
    debugPrint(
      '[RPC] 场景=$rpcUsageScenario | chain=${chain.id} | 默认选中=$selectedRpcLog | 实际使用=${used ?? '—'}',
    );
  }
  return used;
}
