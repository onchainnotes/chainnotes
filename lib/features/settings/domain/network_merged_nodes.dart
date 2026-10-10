import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:chain_notes/common/storage/preference_keys.dart';
import 'package:chain_notes/features/settings/domain/network_rpc_defaults.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RpcProbeStatus {
  online,
  offline,
  testing,
}

@immutable
class RpcNodeUi {
  const RpcNodeUi({
    required this.id,
    required this.name,
    required this.url,
    required this.isDefault,
    required this.isActive,
    this.probeStatus = RpcProbeStatus.online,
    this.latencyMs,
    this.displayUrlForUi,
  });

  final String id;
  final String name;

  final String url;

  final String? displayUrlForUi;

  final bool isDefault;
  final bool isActive;
  final RpcProbeStatus probeStatus;
  final int? latencyMs;

  RpcNodeUi copyWith({
    String? id,
    String? name,
    String? url,
    String? displayUrlForUi,
    bool? isDefault,
    bool? isActive,
    RpcProbeStatus? probeStatus,
    int? latencyMs,
    bool clearLatency = false,
    bool clearDisplayUrlForUi = false,
  }) {
    return RpcNodeUi(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      displayUrlForUi: clearDisplayUrlForUi
          ? null
          : (displayUrlForUi ?? this.displayUrlForUi),
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      probeStatus: probeStatus ?? this.probeStatus,
      latencyMs: clearLatency ? null : (latencyMs ?? this.latencyMs),
    );
  }
}

String rpcUrlForDisplayAndCopy(RpcNodeUi node) =>
    node.displayUrlForUi ?? node.url;

List<RpcNodeUi> buildPresetDefaultsForChain(String chainId) {
  final endpoints = ChainFromDemo.demoRpcEndpointsOrderedForChainId(chainId);
  if (endpoints.isNotEmpty) {
    return List<RpcNodeUi>.generate(
      endpoints.length,
      (i) => RpcNodeUi(
        id: 'default-$i',
        name: i == 0 ? '默认节点' : '节点 ${i + 1}',
        url: endpoints[i].requestUrl,
        displayUrlForUi: endpoints[i].displayUrlForUi,
        isDefault: true,
        isActive: i == 0,
        probeStatus: RpcProbeStatus.online,
        latencyMs: null,
      ),
    );
  }
  final chain = chainByNetworkSettingsId(chainId);
  final url = chain?.rpcUrl?.trim();
  if (url != null && url.isNotEmpty) {
    final redacted = ChainFromDemo.redactSensitiveQueryParamsInRpcUrl(url);
    return [
      RpcNodeUi(
        id: 'default-0',
        name: '默认节点',
        url: url,
        displayUrlForUi: redacted,
        isDefault: true,
        isActive: true,
        probeStatus: RpcProbeStatus.online,
        latencyMs: null,
      ),
    ];
  }
  return [];
}

List<RpcNodeUi> parseCustomRpcNodesFromPrefsRaw(String? raw) {
  if (raw == null || raw.isEmpty) return [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    final out = <RpcNodeUi>[];
    for (final e in decoded) {
      if (e is String) {
        final url = e.trim();
        if (url.isEmpty) continue;
        final id = 'custom-${url.hashCode}';
        out.add(
          RpcNodeUi(
            id: id,
            name: '自定义节点',
            url: url,
            isDefault: false,
            isActive: false,
            probeStatus: RpcProbeStatus.online,
            latencyMs: null,
          ),
        );
      } else if (e is Map) {
        final id = e['id']?.toString() ??
            'custom-${DateTime.now().microsecondsSinceEpoch}';
        final name = e['name']?.toString().trim();
        final url = e['url']?.toString().trim();
        if (url == null || url.isEmpty) continue;
        out.add(
          RpcNodeUi(
            id: id,
            name: (name != null && name.isNotEmpty) ? name : '自定义节点',
            url: url,
            isDefault: false,
            isActive: e['isActive'] == true,
            probeStatus: RpcProbeStatus.online,
            latencyMs: null,
          ),
        );
      }
    }
    return out;
  } catch (_) {
    return [];
  }
}

List<RpcNodeUi> mergeDefaultAndCustomRpcNodes(
  List<RpcNodeUi> defaults,
  List<RpcNodeUi> customs,
) {
  final activeCustoms = customs.where((n) => n.isActive).toList();
  if (activeCustoms.isNotEmpty) {
    final keepId = activeCustoms.first.id;
    final d = defaults.map((n) => n.copyWith(isActive: false)).toList();
    final c =
        customs.map((n) => n.copyWith(isActive: n.id == keepId)).toList();
    return [...d, ...c];
  }
  if (defaults.isEmpty) return customs;
  final firstDefaultId = defaults.first.id;
  final d = defaults
      .map((n) => n.copyWith(isActive: n.id == firstDefaultId))
      .toList();
  final c = customs.map((n) => n.copyWith(isActive: false)).toList();
  return [...d, ...c];
}

class _NetworkNodesPrefsData {
  const _NetworkNodesPrefsData({required this.customs, this.activeNodeId});

  final List<RpcNodeUi> customs;
  final String? activeNodeId;
}

List<RpcNodeUi> _customNodesOnlyFromJsonList(dynamic customsJson) {
  if (customsJson == null) return [];
  if (customsJson is! List) return [];
  final out = <RpcNodeUi>[];
  for (final e in customsJson) {
    if (e is String) {
      final url = e.trim();
      if (url.isEmpty) continue;
      out.add(
        RpcNodeUi(
          id: 'custom-${url.hashCode}',
          name: '自定义节点',
          url: url,
          isDefault: false,
          isActive: false,
          probeStatus: RpcProbeStatus.online,
          latencyMs: null,
        ),
      );
    } else if (e is Map) {
      final id = e['id']?.toString() ??
          'custom-${DateTime.now().microsecondsSinceEpoch}';
      final name = e['name']?.toString().trim();
      final url = e['url']?.toString().trim();
      if (url == null || url.isEmpty) continue;
      out.add(
        RpcNodeUi(
          id: id,
          name: (name != null && name.isNotEmpty) ? name : '自定义节点',
          url: url,
          isDefault: false,
          isActive: false,
          probeStatus: RpcProbeStatus.online,
          latencyMs: null,
        ),
      );
    }
  }
  return out;
}

_NetworkNodesPrefsData _readNetworkNodesPrefs(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return const _NetworkNodesPrefsData(customs: []);
  }
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map) {
      final m = Map<String, dynamic>.from(decoded);
      final activeId = m['activeId'] as String?;
      final customs = _customNodesOnlyFromJsonList(m['customs']);
      return _NetworkNodesPrefsData(customs: customs, activeNodeId: activeId);
    }
    if (decoded is List) {
      return _NetworkNodesPrefsData(
        customs: parseCustomRpcNodesFromPrefsRaw(raw),
        activeNodeId: null,
      );
    }
  } catch (_) {}
  return const _NetworkNodesPrefsData(customs: []);
}

Future<List<RpcNodeUi>> loadMergedRpcNodesForChain(String chainId) async {
  final prefs = await SharedPreferences.getInstance();
  final defaults = buildPresetDefaultsForChain(chainId);
  final raw = prefs.getString(PreferenceKeys.networkNodesKey(chainId));
  final pdata = _readNetworkNodesPrefs(raw);
  var merged = mergeDefaultAndCustomRpcNodes(defaults, pdata.customs);
  if (pdata.activeNodeId != null) {
    final id = pdata.activeNodeId!;
    if (merged.any((n) => n.id == id)) {
      merged =
          merged.map((n) => n.copyWith(isActive: n.id == id)).toList();
    }
  }
  return merged;
}
