import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:chain_notes/features/settings/domain/network_merged_nodes.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_settings_provider.g.dart';

enum NetworkNodeStatus {
  online,
  offline,
  custom,
}

@immutable
class NetworkSettingsRow {
  const NetworkSettingsRow({
    required this.chain,
    required this.status,
    required this.nodeCount,
  });

  final Chain chain;
  final NetworkNodeStatus status;

  final int nodeCount;
}

@immutable
class NetworkSettingsGrouped {
  const NetworkSettingsGrouped({
    required this.mainnetRows,
    required this.testnetRows,
  });

  final List<NetworkSettingsRow> mainnetRows;
  final List<NetworkSettingsRow> testnetRows;
}

const List<String> kPreferredNetworkSettingIds = [
  'ethereum',
  'bsc',
  'polygon',
  'arbitrum',
  'optimism',
  'avalanche',
  'fantom',
  'base',
];

List<Chain> networkSettingsChainsOrdered() {
  final main = ChainFromDemo.mainnetChains;
  final byId = {for (final c in main) c.id: c};
  final out = <Chain>[];
  for (final id in kPreferredNetworkSettingIds) {
    final c = byId[id];
    if (c != null) out.add(c);
  }
  for (final c in main) {
    if (!out.any((e) => e.id == c.id)) {
      out.add(c);
    }
  }
  return out;
}

const List<String> kPreferredTestnetSettingIds = [
  'sepolia',
  'amoy',
  'bsc-testnet',
];

List<Chain> networkSettingsTestnetChainsOrdered() {
  final test = ChainFromDemo.testnetChains;
  final byId = {for (final c in test) c.id: c};
  final out = <Chain>[];
  for (final id in kPreferredTestnetSettingIds) {
    final c = byId[id];
    if (c != null) out.add(c);
  }
  for (final c in test) {
    if (!out.any((e) => e.id == c.id)) {
      out.add(c);
    }
  }
  return out;
}

Future<List<NetworkSettingsRow>> _networkSettingsRowsForChains(
  List<Chain> chains,
) async {
  final rows = <NetworkSettingsRow>[];
  for (final c in chains) {
    final nodes = await loadMergedRpcNodesForChain(c.id);
    final hasCustom = nodes.any((n) => !n.isDefault);
    RpcNodeUi? activeForLog;
    String? probeTarget;
    for (final n in nodes) {
      if (n.isActive) {
        activeForLog = n;
        probeTarget = n.url;
        break;
      }
    }
    probeTarget ??= nodes.isNotEmpty ? nodes.first.url : null;
    final selectedRpcLog = activeForLog != null
        ? '${activeForLog.id} | ${activeForLog.url}'
        : (nodes.isEmpty ? '(无节点)' : '(无isActive) | ${nodes.first.url}');
    debugPrint(
      '[RPC] 场景=网络设置列表 | chain=${c.id} | 默认选中=$selectedRpcLog | '
      '实际使用=${probeTarget ?? '—'}'
      '${hasCustom ? ' | 探活:跳过(含自定义节点)' : ' | 探活:eth_blockNumber→本URL'}',
    );
    final status = hasCustom
        ? NetworkNodeStatus.custom
        : await probeChainRpcReachable(probeTarget);
    rows.add(
      NetworkSettingsRow(
        chain: c,
        status: status,
        nodeCount: nodes.length,
      ),
    );
  }
  return rows;
}

Future<NetworkNodeStatus> probeChainRpcReachable(String? rpcUrl) async {
  if (rpcUrl == null || rpcUrl.isEmpty) {
    return NetworkNodeStatus.offline;
  }
  try {
    final response = await http
        .post(
          Uri.parse(rpcUrl),
          headers: const {'Content-Type': 'application/json'},
          body:
              '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}',
        )
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200 &&
        response.body.contains('result') &&
        !response.body.contains('error')) {
      return NetworkNodeStatus.online;
    }
  } catch (_) {}
  return NetworkNodeStatus.offline;
}

@Riverpod(keepAlive: true)
Future<NetworkSettingsGrouped> networkSettingsRows(
  NetworkSettingsRowsRef ref,
) async {
  final mainnet = await _networkSettingsRowsForChains(
    networkSettingsChainsOrdered(),
  );
  final testnet = await _networkSettingsRowsForChains(
    networkSettingsTestnetChainsOrdered(),
  );
  return NetworkSettingsGrouped(
    mainnetRows: mainnet,
    testnetRows: testnet,
  );
}
