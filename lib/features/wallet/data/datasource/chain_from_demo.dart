import 'package:flutter/foundation.dart';
import 'package:chain_notes/common/datasource/chain_datas.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';

@immutable
class DemoRpcEndpoint {
  const DemoRpcEndpoint({
    required this.requestUrl,
    this.displayUrlForUi,
  });

  final String requestUrl;
  final String? displayUrlForUi;
}

class ChainFromDemo {
  ChainFromDemo._();

  static const _colorMap = <String, int>{
    'Bitcoin': 0xFFF7931A,
    'Ethereum': 0xFF627EEA,
    'Tron': 0xFFEF0027,
    'BSC': 0xFFF3BA2F,
    'Solana': 0xFF14F195,
    'Polygon': 0xFF8247E5,
    'Litecoin': 0xFF345D9D,
    'Dogecoin': 0xFFC2A633,
    'Arbitrum': 0xFF28A0F0,
    'Optimism': 0xFFFF0420,
    'Avalanche': 0xFFE84142,
    'AB Core Testnet': 0xFF10b981,
    'Holesky': 0xFF6B7280,
    'Sepolia': 0xFF6B7280,
    'Mumbai': 0xFF8247E5,
    'Tron-Nile': 0xFFEF0027,
    'BSC Testnet': 0xFFF3BA2F,
    'Solana Devnet': 0xFF14F195,
  };

  static const _iconMap = <String, String>{
    'Bitcoin': '₿',
    'Ethereum': '⟠',
    'Tron': '◆',
    'Solana': '◎',
    'BSC': '◆',
    'Polygon': '⬡',
    'Litecoin': 'Ł',
    'Dogecoin': 'Ð',
    'Arbitrum': '◎',
    'Optimism': '◉',
    'Avalanche': '▲',
  };

  static const _blockTimeMap = <String, String>{
    'Bitcoin': '~10min',
    'Ethereum': '~12s',
    'Tron': '~3s',
    'Solana': '~400ms',
    'BSC': '~3s',
    'Polygon': '~2s',
    'Litecoin': '~2.5min',
    'Dogecoin': '~1min',
    'Arbitrum': '~0.25s',
    'Optimism': '~2s',
    'Avalanche': '~2s',
    'Holesky': '~12s',
    'Sepolia': '~12s',
    'Mumbai': '~2s',
    'Tron-Nile': '~3s',
    'BSC Testnet': '~3s',
    'Solana Devnet': '~400ms',
    'AB Core Testnet': '~12s',
  };

  static const _sensitiveRpcQueryKeys = <String>{
    'dkey',
    'apikey',
    'api_key',
    'key',
    'token',
    'secret',
    'auth',
    'password',
  };

  static String? redactSensitiveQueryParamsInRpcUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (!uri.hasQuery) return null;
      final params = Map<String, String>.from(uri.queryParameters);
      var changed = false;
      for (final e in params.entries.toList()) {
        if (_sensitiveRpcQueryKeys.contains(e.key.toLowerCase()) &&
            e.value.isNotEmpty) {
          params[e.key] = '***';
          changed = true;
        }
      }
      if (!changed) return null;
      return uri.replace(queryParameters: params).toString();
    } catch (_) {
      return null;
    }
  }

  static DemoRpcEndpoint? parseDemoRpcAddressEntry(dynamic e) {
    if (e == null) return null;
    if (e is String) {
      final u = e.trim();
      if (u.isEmpty) return null;
      final redacted = redactSensitiveQueryParamsInRpcUrl(u);
      return DemoRpcEndpoint(requestUrl: u, displayUrlForUi: redacted);
    }
    if (e is Map) {
      final m = Map<String, dynamic>.from(e);
      final base =
          (m['url'] ?? m['rpc'] ?? m['address'])?.toString().trim() ?? '';
      if (base.isEmpty) return null;
      final key = m['key']?.toString().trim() ?? '';
      if (key.isNotEmpty) {
        var keyName =
            (m['key_name'] ?? m['key_param'] ?? 'dkey').toString().trim();
        if (keyName.isEmpty) keyName = 'dkey';
        final sep = base.contains('?') ? '&' : '?';
        final enc = Uri.encodeQueryComponent(key);
        final request = '$base$sep$keyName=$enc';
        final display = '$base$sep$keyName=***';
        return DemoRpcEndpoint(requestUrl: request, displayUrlForUi: display);
      }
      final redacted = redactSensitiveQueryParamsInRpcUrl(base);
      return DemoRpcEndpoint(requestUrl: base, displayUrlForUi: redacted);
    }
    return null;
  }

  static Chain _fromMap(Map<String, dynamic> m) {
    final chainName = m['chain_name'] as String? ?? '';
    final chainType = m['chain_type'] as String? ?? '';
    final networkType = m['network_type'] as String? ?? 'mainnet';
    final isTestnet = networkType == 'testnet';
    final chainId = m['chain_id'] as int?;
    final evmChainId = m['evm_chain_id'];
    final symbol = m['main_token_symbol'] as String? ?? '';
    final decimals = m['main_token_decimals'] as int? ?? 18;
    final chainLogo = m['chain_logo'] as String?;
    final explorerUrl = m['explorer_url'] as String?;

    String? rpcUrl;
    String? restfulUrl;
    List<String> faucetUrls = [];
    final endpoints = m['endpoints'] as Map<String, dynamic>?;
    if (endpoints != null) {
      final rpcList = endpoints['rpc_addresses'] as List<dynamic>?;
      if (rpcList != null && rpcList.isNotEmpty) {
        final urls = <String>[];
        for (final item in rpcList) {
          final ep = parseDemoRpcAddressEntry(item);
          if (ep != null) urls.add(ep.requestUrl);
        }
        if (urls.isNotEmpty) rpcUrl = _pickBestRpcUrl(urls);
      }
      final restList = endpoints['restful_addresses'] as List<dynamic>?;
      if (restList != null && restList.isNotEmpty) {
        restfulUrl = restList.first as String?;
      }
      final faucetList = endpoints['faucet_urls'] as List<dynamic>?;
      if (faucetList != null) {
        faucetUrls = faucetList.map((e) => e.toString()).toList();
      }
    }
    final topFaucetList = m['faucet_urls'] as List<dynamic>?;
    if (topFaucetList != null && topFaucetList.isNotEmpty) {
      faucetUrls = topFaucetList.map((e) => e.toString()).toList();
    }

    final id = chainName
        .toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll('.', '');
    final color =
        _colorMap[chainName] ?? _colorMap[chainType] ?? 0xFF6B7280;
    final icon = _iconMap[chainType] ??
        _iconMap[chainName] ??
        (chainName.isNotEmpty ? chainName[0] : '?');
    final blockTime =
        _blockTimeMap[chainName] ?? _blockTimeMap[chainType] ?? '~12s';
    final displayChainId =
        (evmChainId != null && evmChainId is int) ? evmChainId : chainId;

    return Chain(
      id: id,
      name: chainName,
      symbol: symbol,
      colorValue: color,
      displayName: chainName,
      chainId: displayChainId,
      icon: icon,
      isTestnet: isTestnet,
      avgGasCost: isTestnet ? 'testnet' : 'medium',
      blockTime: blockTime,
      description: null,
      rpcUrl: rpcUrl,
      restfulUrl: restfulUrl,
      mainTokenDecimals: decimals,
      chainLogo: chainLogo,
      explorerUrl: explorerUrl,
      faucetUrls: faucetUrls,
    );
  }

  static String? _pickBestRpcUrl(List<String> urls) {
    final candidates = urls
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (candidates.isEmpty) return null;

    int score(String url) {
      var s = 0;
      final u = url.toLowerCase();
      if (u.startsWith('https://')) s += 20;
      if (u.startsWith('http://')) s += 10;

      if (u.contains('ankr.com')) s += 50;
      if (u.contains('alchemy.com')) s += 45;
      if (u.contains('pocket.network')) s += 40;
      if (u.contains('llamarpc.com')) s += 30;

      if (u.contains('data-seed-prebsc')) s -= 30;
      if (u.contains('binance.org')) s -= 10;

      return s;
    }

    candidates.sort((a, b) => score(b).compareTo(score(a)));
    return candidates.first;
  }

  static List<Chain> get mainnetChains {
    final data = ChainDatas.demoChainInfoList['data'] as Map<String, dynamic>?;
    if (data == null) return [];
    final list = data['list'] as List<dynamic>? ?? [];
    return list
        .cast<Map<String, dynamic>>()
        .where((m) => (m['network_type'] as String? ?? '') == 'mainnet')
        .map(_fromMap)
        .toList();
  }

  static List<Chain> get testnetChains {
    final data = ChainDatas.demoChainInfoList['data'] as Map<String, dynamic>?;
    if (data == null) return [];
    final list = data['list'] as List<dynamic>? ?? [];
    return list
        .cast<Map<String, dynamic>>()
        .where((m) => (m['network_type'] as String? ?? '') == 'testnet')
        .map(_fromMap)
        .toList();
  }

  static List<Chain> get allChains => [...mainnetChains, ...testnetChains];

  static Chain? findByChainId(int chainId) {
    for (final c in allChains) {
      if (c.chainId == chainId) return c;
    }
    return null;
  }

  static String chainIdFromDemoMap(Map<String, dynamic> m) {
    final chainName = m['chain_name'] as String? ?? '';
    return chainName
        .toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll('.', '');
  }

  static Map<String, dynamic>? rawDemoEntryForChainId(String chainId) {
    final data = ChainDatas.demoChainInfoList['data'] as Map<String, dynamic>?;
    if (data == null) return null;
    final list = data['list'] as List<dynamic>? ?? [];
    for (final e in list) {
      if (e is! Map<String, dynamic>) continue;
      if (chainIdFromDemoMap(e) == chainId) return e;
    }
    return null;
  }

  static List<DemoRpcEndpoint> demoRpcEndpointsOrderedForChainId(String chainId) {
    final m = rawDemoEntryForChainId(chainId);
    if (m == null) return [];
    final endpoints = m['endpoints'] as Map<String, dynamic>?;
    if (endpoints == null) return [];
    final rpcList = endpoints['rpc_addresses'] as List<dynamic>?;
    if (rpcList == null) return [];
    final out = <DemoRpcEndpoint>[];
    for (final item in rpcList) {
      final ep = parseDemoRpcAddressEntry(item);
      if (ep != null) out.add(ep);
    }
    return out;
  }

  static List<String> rpcAddressesOrderedForChainId(String chainId) {
    return demoRpcEndpointsOrderedForChainId(chainId)
        .map((e) => e.requestUrl)
        .toList();
  }
}
