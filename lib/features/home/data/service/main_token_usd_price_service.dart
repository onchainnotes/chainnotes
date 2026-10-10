import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';

class _CacheEntry {
  _CacheEntry(this.priceUsd, this.fetchedAt);

  final double priceUsd;
  final DateTime fetchedAt;
}

class MainTokenUsdPriceService {
  MainTokenUsdPriceService._();

  static final MainTokenUsdPriceService instance = MainTokenUsdPriceService._();

  static const Duration _ttl = Duration(hours: 1);

  final Map<String, _CacheEntry> _cache = {};

  static String? coinGeckoIdForChain(Chain chain) {
    final id = chain.chainId;
    if (id == null) return _coinGeckoIdByName(chain);
    switch (id) {
      case 1:
      case 11155111: // Sepolia
      case 17000: // Holesky
      case 42161: // Arbitrum One
      case 42170: // Arbitrum Nova
      case 10: // Optimism
      case 11155420: // OP Sepolia
      case 8453: // Base
      case 84532: // Base Sepolia
        return 'ethereum';
      case 56: // BSC
      case 97: // BSC Testnet
        return 'binancecoin';
      case 137: // Polygon PoS
      case 80001: // Mumbai
      case 80002: // Amoy
        return 'polygon-ecosystem-token';
      case 43114: // Avalanche C-Chain
      case 43113: // Fuji
        return 'avalanche-2';
      default:
        return _coinGeckoIdByName(chain);
    }
  }

  static String? _coinGeckoIdByName(Chain chain) {
    final n = chain.name.toLowerCase();
    final t = chain.id.toLowerCase();
    if (n.contains('bsc') ||
        n.contains('bnb') ||
        t.contains('bsc') ||
        t.contains('smart chain')) {
      return 'binancecoin';
    }
    if (n.contains('polygon') ||
        n.contains('matic') ||
        t.contains('polygon') ||
        t.contains('amoy')) {
      return 'polygon-ecosystem-token';
    }
    if (n.contains('avalanche') || t.contains('avalanche') || t.contains('fuji')) {
      return 'avalanche-2';
    }
    if (n.contains('arbitrum') ||
        n.contains('optimism') ||
        n.contains('base') ||
        n.contains('ethereum') ||
        n.contains('sepolia') ||
        n.contains('holesky')) {
      return 'ethereum';
    }
    return null;
  }

  static String? _coinYepFromSymbol(String coinGeckoId) {
    switch (coinGeckoId) {
      case 'ethereum':
        return 'ETH';
      case 'binancecoin':
        return 'BNB';
      case 'polygon-ecosystem-token':
        return 'MATIC';
      case 'avalanche-2':
        return 'AVAX';
      default:
        return null;
    }
  }

  Future<double?> _fetchUsdFromCoinYep(String coinGeckoId) async {
    final from = _coinYepFromSymbol(coinGeckoId);
    if (from == null) return null;
    final uri = Uri.https('coinyep.com', '/api/v1/', {
      'from': from,
      'to': 'USD',
    });
    try {
      final response = await http
          .get(
            uri,
            headers: const {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return null;
      final map = jsonDecode(response.body) as Map<String, dynamic>?;
      if (map == null) return null;
      final raw = map['price'];
      if (raw is num) return raw.toDouble();
      if (raw is String) return double.tryParse(raw);
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<double?> getUsdUnitPrice(String coinGeckoId) async {
    final now = DateTime.now();
    final hit = _cache[coinGeckoId];
    if (hit != null && now.difference(hit.fetchedAt) < _ttl) {
      return hit.priceUsd;
    }

    double? coingeckoUsd;
    final cgUri = Uri.https('api.coingecko.com', '/api/v3/simple/price', {
      'ids': coinGeckoId,
      'vs_currencies': 'usd',
    });
    try {
      final response = await http
          .get(
            cgUri,
            headers: const {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final map = jsonDecode(response.body) as Map<String, dynamic>?;
        if (map != null) {
          final inner = map[coinGeckoId] as Map<String, dynamic>?;
          final usd = inner?['usd'];
          if (usd is num) {
            coingeckoUsd = usd.toDouble();
          }
        }
      }
    } catch (_) {
      coingeckoUsd = null;
    }

    final resolved = coingeckoUsd ?? await _fetchUsdFromCoinYep(coinGeckoId);
    if (resolved != null) {
      _cache[coinGeckoId] = _CacheEntry(resolved, now);
      return resolved;
    }
    return hit?.priceUsd;
  }

  Future<double?> getUsdUnitPriceForChain(Chain? chain) async {
    if (chain == null) return null;
    if (chain.isTestnet) return null;
    final gid = coinGeckoIdForChain(chain);
    if (gid == null) return null;
    return getUsdUnitPrice(gid);
  }
}
