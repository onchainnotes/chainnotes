import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:chain_notes/common/storage/preference_keys.dart';
import 'package:chain_notes/common/utils/evm_rpc_latency.dart';
import 'package:chain_notes/features/home/application/chain_selector_provider.dart';
import 'package:chain_notes/features/home/application/home_page_provider.dart';
import 'package:chain_notes/features/settings/application/network_settings_provider.dart';
import 'package:chain_notes/features/settings/domain/network_merged_nodes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

export '../domain/network_merged_nodes.dart';

part 'network_detail_provider.g.dart';

@immutable
class NetworkDetailViewState {
  const NetworkDetailViewState({
    required this.nodes,
    this.testingNodeId,
  });

  final List<RpcNodeUi> nodes;
  final String? testingNodeId;

  RpcNodeUi? get activeNode {
    for (final n in nodes) {
      if (n.isActive) return n;
    }
    return null;
  }

  NetworkDetailViewState copyWith({
    List<RpcNodeUi>? nodes,
    String? testingNodeId,
    bool clearTestingNodeId = false,
  }) {
    return NetworkDetailViewState(
      nodes: nodes ?? this.nodes,
      testingNodeId: clearTestingNodeId
          ? null
          : (testingNodeId ?? this.testingNodeId),
    );
  }
}

Future<({bool ok, int? ms})> _measureRpcLatency(
  String url, {
  String? debugScenario,
}) async {
  if (debugScenario != null) {
    debugPrint(
      '[RPC] 场景=$debugScenario | 实际使用=$url | 探活:eth_blockNumber',
    );
  }
  final ms = await measureEvmJsonRpcLatencyMs(url);
  return (ok: ms != null, ms: ms);
}

Future<List<RpcNodeUi>> _nodesWithInitialProbe(List<RpcNodeUi> nodes) async {
  return Future.wait(
    nodes.map((n) async {
      final u = n.url.trim();
      if (u.isEmpty) {
        return n.copyWith(
          probeStatus: RpcProbeStatus.offline,
          clearLatency: true,
        );
      }
      final measure = await _measureRpcLatency(u);
      return n.copyWith(
        probeStatus:
            measure.ok ? RpcProbeStatus.online : RpcProbeStatus.offline,
        latencyMs: measure.ms,
        clearLatency: !measure.ok,
      );
    }),
  );
}

RpcNodeUi? _findNode(List<RpcNodeUi> nodes, String id) {
  for (final n in nodes) {
    if (n.id == id) return n;
  }
  return null;
}

Future<void> _persistNetworkNodes(
  String chainId,
  List<RpcNodeUi> allNodes,
) async {
  final prefs = await SharedPreferences.getInstance();
  final key = PreferenceKeys.networkNodesKey(chainId);
  RpcNodeUi? active;
  for (final n in allNodes) {
    if (n.isActive) {
      active = n;
      break;
    }
  }
  final defaults = buildPresetDefaultsForChain(chainId);
  final firstDefaultId = defaults.isNotEmpty ? defaults.first.id : null;

  final customs = allNodes.where((n) => !n.isDefault).map((m) {
    return <String, dynamic>{
      'id': m.id,
      'name': m.name,
      'url': m.url,
    };
  }).toList();

  final onlyFirstDefault = customs.isEmpty &&
      active != null &&
      firstDefaultId != null &&
      active.id == firstDefaultId;
  if (onlyFirstDefault) {
    await prefs.remove(key);
    return;
  }
  if (customs.isEmpty && active == null) {
    await prefs.remove(key);
    return;
  }

  await prefs.setString(
    key,
    jsonEncode(<String, dynamic>{
      'v': 1,
      'activeId': active?.id,
      'customs': customs,
    }),
  );
}

const kNetworkDetailErrInvalidRpcUrl = 'invalid_rpc_url';
const kNetworkDetailErrNodeDuplicate = 'node_duplicate';

@Riverpod(keepAlive: false)
class NetworkDetailController extends _$NetworkDetailController {
  @override
  Future<NetworkDetailViewState> build(String chainId) async {
    final loaded = await loadMergedRpcNodesForChain(chainId);
    final nodes = await _nodesWithInitialProbe(loaded);
    return NetworkDetailViewState(nodes: nodes);
  }

  Future<void> addCustomNode({
    required String name,
    required String url,
  }) async {
    final trimmedName = name.trim();
    final trimmedUrl = url.trim();
    if (trimmedName.isEmpty || trimmedUrl.isEmpty) return;
    final uri = Uri.tryParse(trimmedUrl);
    if (uri == null ||
        uri.scheme.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw FormatException(kNetworkDetailErrInvalidRpcUrl);
    }

    final stateAsync = await future;
    final existing = stateAsync.nodes.map((n) => n.url).toSet();
    if (existing.contains(trimmedUrl)) {
      throw StateError(kNetworkDetailErrNodeDuplicate);
    }

    await Future<void>.delayed(const Duration(milliseconds: 400));

    final measure = await _measureRpcLatency(
      trimmedUrl,
      debugScenario: '网络详情-添加节点',
    );
    final newNode = RpcNodeUi(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: trimmedName,
      url: trimmedUrl,
      isDefault: false,
      isActive: false,
      probeStatus:
          measure.ok ? RpcProbeStatus.online : RpcProbeStatus.offline,
      latencyMs: measure.ms,
    );

    final updated = [...stateAsync.nodes, newNode];
    state = AsyncData(NetworkDetailViewState(nodes: updated));
    await _persistNetworkNodes(chainId, updated);
    ref.invalidate(networkSettingsRowsProvider);
    ref.invalidate(homePageUiProvider);
    ref.invalidate(chainSelectorRpcLatencyProvider(chainId));
  }

  Future<void> deleteNode(String nodeId) async {
    final stateAsync = await future;
    final target = _findNode(stateAsync.nodes, nodeId);
    if (target == null || target.isDefault) return;
    if (target.isActive) return;

    final updated = stateAsync.nodes.where((n) => n.id != nodeId).toList();
    state = AsyncData(NetworkDetailViewState(nodes: updated));
    await _persistNetworkNodes(chainId, updated);
    ref.invalidate(networkSettingsRowsProvider);
    ref.invalidate(homePageUiProvider);
    ref.invalidate(chainSelectorRpcLatencyProvider(chainId));
  }

  Future<void> setActiveNode(String nodeId) async {
    final stateAsync = await future;
    final updated = stateAsync.nodes
        .map((n) => n.copyWith(isActive: n.id == nodeId))
        .toList();
    state = AsyncData(NetworkDetailViewState(nodes: updated));
    await _persistNetworkNodes(chainId, updated);
    ref.invalidate(networkSettingsRowsProvider);
    ref.invalidate(homePageUiProvider);
    ref.invalidate(chainSelectorRpcLatencyProvider(chainId));
  }

  Future<void> testNode(String nodeId) async {
    final stateAsync = await future;
    state = AsyncData(stateAsync.copyWith(testingNodeId: nodeId));

    final target = _findNode(stateAsync.nodes, nodeId);
    if (target == null) {
      final cur = await future;
      state = AsyncData(cur.copyWith(clearTestingNodeId: true));
      return;
    }

    final measure = await _measureRpcLatency(
      target.url,
      debugScenario: '网络详情-手动测试',
    );

    final cur = await future;
    final nodes = cur.nodes
        .map(
          (n) => n.id == nodeId
              ? n.copyWith(
                  probeStatus: measure.ok
                      ? RpcProbeStatus.online
                      : RpcProbeStatus.offline,
                  latencyMs: measure.ms,
                  clearLatency: !measure.ok,
                )
              : n,
        )
        .toList();
    state = AsyncData(
      NetworkDetailViewState(nodes: nodes).copyWith(clearTestingNodeId: true),
    );
  }

  bool canDelete(String nodeId) {
    if (state case AsyncData(:final value)) {
      final n = _findNode(value.nodes, nodeId);
      if (n == null || n.isDefault) return false;
      if (n.isActive) return false;
      return true;
    }
    return false;
  }
}
