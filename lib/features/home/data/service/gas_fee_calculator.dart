import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:chain_notes/features/home/data/service/gas_speed.dart';

class Eip1559FeeQuote {
  const Eip1559FeeQuote({
    required this.maxPriorityFeePerGas,
    required this.maxFeePerGas,
  });

  final BigInt maxPriorityFeePerGas;
  final BigInt maxFeePerGas;
}

class Eip1559FeeContext {
  const Eip1559FeeContext({
    required this.baseFeeWei,
    required this.suggestedPriorityFeeWei,
  });

  final BigInt baseFeeWei;

  final BigInt suggestedPriorityFeeWei;
}

class GasFeeCalculator {
  GasFeeCalculator._();

  static final BigInt _weiPerGwei = BigInt.from(1000000000);

  static final BigInt _minPriorityFloorWei = BigInt.from(30) * _weiPerGwei;

  static BigInt _tierPriorityBonusWei(GasSpeed speed) {
    switch (speed) {
      case GasSpeed.slow:
        return BigInt.from(3) * _weiPerGwei;
      case GasSpeed.normal:
        return BigInt.from(8) * _weiPerGwei;
      case GasSpeed.fast:
        return BigInt.from(20) * _weiPerGwei;
    }
  }

  static (int num, int den) _multiplierRational(GasSpeed speed) {
    switch (speed) {
      case GasSpeed.slow:
        return (11, 10);
      case GasSpeed.normal:
        return (125, 100);
      case GasSpeed.fast:
        return (15, 10);
    }
  }

  /// `maxFeePerGas = baseFeeWei * multiplier（1.1 / 1.25 / 1.5）+ maxPriorityFeePerGas`
  static Eip1559FeeQuote quoteForSpeed(
    BigInt baseFeeWei,
    BigInt suggestedPriorityFeeWei,
    GasSpeed speed,
  ) {
    var priority = suggestedPriorityFeeWei;
    if (priority < _minPriorityFloorWei) {
      priority = _minPriorityFloorWei;
    }
    priority += _tierPriorityBonusWei(speed);

    final (n, d) = _multiplierRational(speed);
    final scaled = (baseFeeWei * BigInt.from(n)) ~/ BigInt.from(d);
    var maxFee = scaled + priority;
    if (maxFee < priority) maxFee = priority;
    return Eip1559FeeQuote(
      maxPriorityFeePerGas: priority,
      maxFeePerGas: maxFee,
    );
  }

  static BigInt? _parseHexBigInt(dynamic v) {
    if (v == null) return null;
    final s = v.toString();
    if (s.isEmpty) return null;
    try {
      return BigInt.parse(
        s.startsWith('0x') ? s.substring(2) : s,
        radix: 16,
      );
    } catch (_) {
      return null;
    }
  }

  static Eip1559FeeContext? _parseFeeHistoryResult(dynamic fh) {
    if (fh is! Map<String, dynamic>) return null;
    final list = fh['baseFeePerGas'];
    if (list is! List<dynamic> || list.isEmpty) return null;
    final base = _parseHexBigInt(list.last);
    if (base == null || base <= BigInt.zero) return null;

    var suggested = BigInt.zero;
    final rewards = fh['reward'];
    if (rewards is List<dynamic> && rewards.isNotEmpty) {
      final lastBlock = rewards.last;
      if (lastBlock is List<dynamic>) {
        for (final r in lastBlock) {
          final w = _parseHexBigInt(r);
          if (w != null && w > suggested) suggested = w;
        }
      }
    }
    return Eip1559FeeContext(
      baseFeeWei: base,
      suggestedPriorityFeeWei: suggested,
    );
  }

  static Future<Eip1559FeeContext> fetchEip1559FeeContext(
    Future<dynamic> Function(String method, List<dynamic> params) rpc,
  ) async {
    try {
      final fh = await rpc('eth_feeHistory', [
        '0xa',
        'latest',
        <dynamic>[25, 50, 75],
      ]);
      final parsed = _parseFeeHistoryResult(fh);
      if (parsed != null) return parsed;
    } catch (_) {}

    try {
      final gp = await rpc('eth_gasPrice', <dynamic>[]);
      final bi = _parseHexBigInt(gp);
      if (bi != null && bi > BigInt.zero) {
        return Eip1559FeeContext(
          baseFeeWei: bi,
          suggestedPriorityFeeWei: BigInt.zero,
        );
      }
    } catch (_) {}

    return Eip1559FeeContext(
      baseFeeWei: BigInt.from(20) * _weiPerGwei,
      suggestedPriorityFeeWei: BigInt.zero,
    );
  }

  static Future<BigInt> fetchBaseFeeWei(
    Future<dynamic> Function(String method, List<dynamic> params) rpc,
  ) async {
    final ctx = await fetchEip1559FeeContext(rpc);
    return ctx.baseFeeWei;
  }

  static Future<dynamic> _singleJsonRpc(
    String rpcUrl,
    String method,
    List<dynamic> params, {
    required Duration timeout,
  }) async {
    final uri = Uri.parse(rpcUrl);
    final body = jsonEncode({
      'jsonrpc': '2.0',
      'method': method,
      'params': params,
      'id': 1,
    });
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      throw Exception('RPC HTTP ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>?;
    if (json == null) throw Exception('RPC 解析失败');
    final err = json['error'];
    if (err != null) {
      final msg = err is Map && err['message'] != null
          ? err['message'].toString()
          : err.toString();
      throw Exception(msg);
    }
    return json['result'];
  }

  static Future<Eip1559FeeContext> fetchEip1559FeeContextFromRpcUrl(
    String rpcUrl, {
    Duration timeout = const Duration(seconds: 25),
  }) async {
    Future<dynamic> call(String method, List<dynamic> params) =>
        _singleJsonRpc(rpcUrl, method, params, timeout: timeout);
    return fetchEip1559FeeContext(call);
  }

  static BigInt? _parseJsonRpcQuantity(dynamic result) {
    if (result == null) return null;
    if (result is BigInt) return result;
    if (result is int) return BigInt.from(result);
    if (result is num) return BigInt.from(result.round());
    final s = result.toString().trim();
    if (s.isEmpty) return null;
    if (s.startsWith('0x') || s.startsWith('0X')) {
      try {
        return BigInt.parse(s.substring(2), radix: 16);
      } catch (_) {
        return null;
      }
    }
    if (RegExp(r'^[0-9]+$').hasMatch(s)) {
      try {
        return BigInt.parse(s, radix: 10);
      } catch (_) {
        return null;
      }
    }
    try {
      return BigInt.parse(s, radix: 16);
    } catch (_) {
      return null;
    }
  }

  static Future<BigInt?> fetchPendingTransactionNonceFromRpcUrl(
    String rpcUrl,
    String address, {
    Duration timeout = const Duration(seconds: 25),
  }) async {
    final normalized =
        address.startsWith('0x') || address.startsWith('0X')
            ? address
            : '0x$address';

    Future<BigInt?> one(String blockTag) async {
      final result = await _singleJsonRpc(
        rpcUrl,
        'eth_getTransactionCount',
        <dynamic>[normalized, blockTag],
        timeout: timeout,
      );
      return _parseJsonRpcQuantity(result);
    }

    try {
      final n = await one('pending');
      if (n != null) return n;
    } catch (_) {}
    try {
      return await one('latest');
    } catch (_) {
      return null;
    }
  }

  static Future<BigInt> fetchBaseFeeWeiFromRpcUrl(
    String rpcUrl, {
    Duration timeout = const Duration(seconds: 25),
  }) async {
    final ctx = await fetchEip1559FeeContextFromRpcUrl(
      rpcUrl,
      timeout: timeout,
    );
    return ctx.baseFeeWei;
  }
}
