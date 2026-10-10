import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';

class MainTokenBalanceService {
  MainTokenBalanceService._();

  static final MainTokenBalanceService instance = MainTokenBalanceService._();

  Future<String?> getMainTokenBalance({
    required Chain chain,
    required String address,
  }) async {
    final endpoint = await resolveEffectivePrimaryNetworkUrl(
      chain,
      rpcUsageScenario: '主币余额',
    );
    if (endpoint == null || endpoint.isEmpty) return null;

    if (isTronChain(chain)) {
      return _tronGetBalance(endpoint, address, chain.mainTokenDecimals);
    }

    final rpcUrl = endpoint;

    final normalizedAddress = address.startsWith('0x') ? address : '0x$address';
    final decimals = chain.mainTokenDecimals;

    try {
      final weiHex = await _ethGetBalance(rpcUrl, normalizedAddress);
      if (weiHex == null) return null;

      final wei = BigInt.tryParse(weiHex);
      if (wei == null) return null;

      return _weiToDecimal(wei, decimals);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _tronGetBalance(
    String apiBaseUrl,
    String address,
    int decimals,
  ) async {
    try {
      final uri = Uri.parse(
        apiBaseUrl.endsWith('/')
            ? '${apiBaseUrl}wallet/getaccount'
            : '$apiBaseUrl/wallet/getaccount',
      );
      final body = jsonEncode({
        'address': address,
        'visible': true,
      });

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>?;
      if (json == null) return null;

      final balance = json['balance'];
      if (balance == null) return '0';

      final sun = BigInt.tryParse(balance.toString());
      if (sun == null) return '0';

      return _weiToDecimal(sun, decimals);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _ethGetBalance(String rpcUrl, String address) async {
    final uri = Uri.parse(rpcUrl);
    final body = jsonEncode({
      'jsonrpc': '2.0',
      'method': 'eth_getBalance',
      'params': [address, 'latest'],
      'id': 1,
    });

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body) as Map<String, dynamic>?;
    if (json == null) return null;

    final result = json['result'];
    if (result == null) return null;

    final hex = result as String?;
    if (hex == null || hex.isEmpty) return null;

    final cleanHex = hex.startsWith('0x') ? hex.substring(2) : hex;
    return BigInt.parse(cleanHex, radix: 16).toString();
  }

  String _weiToDecimal(BigInt wei, int decimals) {
    if (decimals <= 0) return wei.toString();
    final divisor = BigInt.from(10).pow(decimals);
    final intPart = wei ~/ divisor;
    final fracPart = wei % divisor;
    if (fracPart == BigInt.zero) {
      return intPart.toString();
    }
    var fracStr =
        fracPart.toString().padLeft(decimals, '0').replaceAll(RegExp(r'0+$'), '');
    if (fracStr.isEmpty) return intPart.toString();
    return '$intPart.$fracStr';
  }
}
