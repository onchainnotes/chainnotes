import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:chain_notes/common/config/blockscout_pro_config.dart';
import 'package:chain_notes/common/config/etherscan_config.dart';
import 'package:chain_notes/features/home/data/config/nft_config.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';

class EvmTxListItem {
  const EvmTxListItem({
    required this.hash,
    required this.isOutgoing,
    required this.statusSuccess,
    required this.amountDisplay,
    required this.from,
    required this.to,
    required this.toAddress,
    required this.timestampMs,
    this.gasUsedDisplay,
    this.gasFeeDisplay,
    this.blockNumber,
  });

  final String hash;
  final bool isOutgoing;
  final bool statusSuccess;
  final String amountDisplay;
  final String from;
  final String to;

  final String toAddress;
  final int timestampMs;
  final String? gasUsedDisplay;
  final String? gasFeeDisplay;
  final int? blockNumber;
}

class EvmTransactionHistoryService {
  EvmTransactionHistoryService._();

  static final EvmTransactionHistoryService instance =
      EvmTransactionHistoryService._();

  static const String _etherscanV2Base = 'https://api.etherscan.io/v2/api';

  /// https://docs.etherscan.io/etherscan-v2/getting-started/supported-chains

  static const Set<int> _etherscanV2NotOnFreeTier = {
    56,
    97,
    8453,
    84532,
    10,
    11155420,
    43114,
    43113,
  };

  Future<List<EvmTxListItem>> fetchTransactions({
    required Chain chain,
    required String evmAddress,
    int limit = 50,
  }) async {
    final normalized = _normalizeEvmAddress(evmAddress);
    if (normalized == null || !normalized.startsWith('0x')) {
      return [];
    }

    final noteContract = NftConfig.getContractAddress(chain.chainId);
    if (noteContract == null) {
      return [];
    }

    final walletLower = normalized.toLowerCase();
    final decimals = chain.mainTokenDecimals;
    final contractLower = noteContract.toLowerCase();

    final fetchLimit = (limit * 5).clamp(80, 200);

    final uris = _candidateTxListUris(chain, normalized, fetchLimit);
    if (uris.isEmpty) {
      throw Exception('当前网络未配置可用的区块浏览器接口');
    }
    for (final uri in uris) {
      final list = await _fetchTxListFromUri(
        uri,
        walletLower,
        decimals,
        contractLower: contractLower,
      );
      if (list != null) {
        return list.take(limit).toList();
      }
    }
    final cid = chain.chainId;
    if (cid != null &&
        _etherscanV2NotOnFreeTier.contains(cid) &&
        BlockscoutProConfig.apiKey.isEmpty) {
      throw Exception(
        '当前网络（chainId=$cid）常见于 Etherscan API 免费计划不支持（与是否单独申请 '
        'BscScan Key 无关）。可选：① 升级 Etherscan 计费计划（仍用 ETHERSCAN_API_KEY）；'
        '② https://dev.blockscout.com 申请 Blockscout PRO Key，'
        '配置 blockscout_pro_config.dart 或 BLOCKSCOUT_PRO_API_KEY。'
        '若已为付费计划仍失败，请检查网络或 API 配额。',
      );
    }
    throw Exception(
      '无法拉取交易列表，请检查网络；'
      '若 Key 失效可在 https://etherscan.io/apidashboard 更新，'
      '或通过 lib/common/config/etherscan_config.dart / '
      '--dart-define=ETHERSCAN_API_KEY 配置',
    );
  }

  String? _normalizeEvmAddress(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    if (t.startsWith('0x') || t.startsWith('0X')) return t;
    return '0x$t';
  }

  List<Uri> _candidateTxListUris(Chain chain, String address, int offset) {
    final baseParams = <String, String>{
      'module': 'account',
      'action': 'txlist',
      'address': address,
      'startblock': '0',
      'endblock': '99999999',
      'page': '1',
      'offset': '$offset',
      'sort': 'desc',
    };
    final withKey = Map<String, String>.from(baseParams);
    final apiKey = EtherscanConfig.apiKey;
    if (apiKey.isNotEmpty) {
      withKey['apikey'] = apiKey;
    }

    final seen = <String>{};
    final List<Uri> out = [];

    void add(String base, Map<String, String> query) {
      final u = Uri.parse(base).replace(queryParameters: query);
      if (seen.add(u.toString())) {
        out.add(u);
      }
    }

    void addEtherscanV2(int chainId, Map<String, String> query) {
      final q = Map<String, String>.from(query);
      q['chainid'] = '$chainId';
      if (apiKey.isNotEmpty) {
        q['apikey'] = apiKey;
      }
      add(_etherscanV2Base, q);
    }

    final bsProKey = BlockscoutProConfig.apiKey;
    final earlyCid = chain.chainId;
    if (bsProKey.isNotEmpty &&
        earlyCid != null &&
        _etherscanV2NotOnFreeTier.contains(earlyCid)) {
      final q = Map<String, String>.from(baseParams);
      q['chain_id'] = '$earlyCid';
      q['apikey'] = bsProKey;
      add('https://api.blockscout.com/v2/api', q);
    }

    final exp = chain.explorerUrl?.trim();
    if (exp != null && exp.isNotEmpty) {
      final norm = exp.replaceAll(RegExp(r'/+$'), '');
      final expUri = Uri.tryParse(
        norm.startsWith('http') ? norm : 'https://$norm',
      );
      final host = expUri?.host.toLowerCase() ?? '';
      if (host.contains('blockscout.com') || host.contains('blockscout.org')) {
        add('$norm/api', baseParams);
      }
      final v2Cid =
          chain.chainId ?? _chainIdFromEtherscanStyleExplorerHost(host);
      if (v2Cid != null && _isEtherscanStyleExplorerHost(host)) {
        addEtherscanV2(
          v2Cid,
          apiKey.isNotEmpty ? withKey : baseParams,
        );
      }
    }

    final cid = chain.chainId;
    if (cid != null) {
      final q = apiKey.isNotEmpty ? withKey : baseParams;
      switch (cid) {
        case 1:
          add('https://eth.blockscout.com/api', baseParams);
          addEtherscanV2(1, q);
          break;
        case 11155111:
          add('https://eth-sepolia.blockscout.com/api', baseParams);
          addEtherscanV2(11155111, q);
          break;
        case 56:
          addEtherscanV2(56, q);
          break;
        case 97:
          addEtherscanV2(97, q);
          break;
        case 137:
          add('https://polygon.blockscout.com/api', baseParams);
          addEtherscanV2(137, q);
          break;
        case 42161:
          addEtherscanV2(42161, q);
          break;
        case 10:

          add('https://optimism.blockscout.com/api', baseParams);
          addEtherscanV2(10, q);
          break;
        case 80002:
          addEtherscanV2(80002, q);
          break;
        default:
          addEtherscanV2(cid, q);
      }
    }

    return _reorderTxlistUrisPreferEtherscanV2(
      out,
      chain.chainId,
      apiKey.isNotEmpty,
    );
  }

  List<Uri> _reorderTxlistUrisPreferEtherscanV2(
    List<Uri> uris,
    int? chainId,
    bool etherscanApiKeyOk,
  ) {
    if (chainId == null || uris.length < 2) return uris;

    final prioritizeV2 = chainId == 137 ||
        (etherscanApiKeyOk && {1, 11155111, 10}.contains(chainId));
    if (!prioritizeV2) return uris;

    bool isEtherscanV2Txlist(Uri u) {
      return u.host == 'api.etherscan.io' &&
          u.path.contains('v2') &&
          u.queryParameters['module'] == 'account' &&
          u.queryParameters['action'] == 'txlist';
    }

    bool isPublicBlockscoutTxlist(Uri u) {
      final h = u.host.toLowerCase();
      if (h == 'api.blockscout.com') return false;
      return (h.endsWith('.blockscout.com') || h.contains('blockscout.org')) &&
          u.queryParameters['module'] == 'account' &&
          u.queryParameters['action'] == 'txlist';
    }

    final v2 = <Uri>[];
    final blockscout = <Uri>[];
    final rest = <Uri>[];
    for (final u in uris) {
      if (isEtherscanV2Txlist(u)) {
        v2.add(u);
      } else if (isPublicBlockscoutTxlist(u)) {
        blockscout.add(u);
      } else {
        rest.add(u);
      }
    }
    if (v2.isEmpty || blockscout.isEmpty) return uris;
    return [...v2, ...rest, ...blockscout];
  }

  bool _isEtherscanStyleExplorerHost(String host) {
    if (host.isEmpty) return false;
    return host == 'etherscan.io' ||
        host.endsWith('.etherscan.io') ||
        host.contains('bscscan.com') ||
        host.contains('polygonscan.com') ||
        host.contains('arbiscan.io') ||
        host == 'optimistic.etherscan.io';
  }

  int? _chainIdFromEtherscanStyleExplorerHost(String host) {
    if (host == 'etherscan.io' || host == 'www.etherscan.io') return 1;
    if (host == 'sepolia.etherscan.io') return 11155111;
    if (host == 'bscscan.com' || host == 'www.bscscan.com') return 56;
    if (host == 'testnet.bscscan.com') return 97;
    if (host == 'polygonscan.com' || host == 'www.polygonscan.com') {
      return 137;
    }
    if (host == 'amoy.polygonscan.com') return 80002;
    if (host == 'arbiscan.io' || host == 'www.arbiscan.io') return 42161;
    if (host == 'optimistic.etherscan.io') return 10;
    return null;
  }

  static bool _txInteractsWithNoteContract({
    required String from,
    required String toAddress,
    required String contractLower,
  }) {
    if (contractLower.isEmpty) return false;
    final f = from.trim().toLowerCase();
    final t = toAddress.trim().toLowerCase();
    return f == contractLower || (t.isNotEmpty && t == contractLower);
  }

  Future<List<EvmTxListItem>?> _fetchTxListFromUri(
    Uri uri,
    String walletLower,
    int decimals, {
    required String contractLower,
  }) async {
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 25));
      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return null;

      final message = decoded['message']?.toString().toLowerCase() ?? '';
      final result = decoded['result'];

      if (result is String) {
        final r = result.toLowerCase();
        if (message.contains('no transactions') ||
            r.contains('no transactions')) {
          return [];
        }
        return null;
      }

      if (result is! List<dynamic>) {
        return null;
      }

      final items = <EvmTxListItem>[];
      for (final raw in result) {
        if (raw is! Map) {
          continue;
        }
        final m = Map<String, dynamic>.from(raw);
        final item = _parseRow(m, walletLower, decimals);
        if (item != null &&
            _txInteractsWithNoteContract(
              from: item.from,
              toAddress: item.toAddress,
              contractLower: contractLower,
            )) {
          items.add(item);
        }
      }
      return items;
    } catch (_) {
      return null;
    }
  }

  EvmTxListItem? _parseRow(
    Map<String, dynamic> m,
    String walletLower,
    int decimals,
  ) {
    final hash = m['hash']?.toString() ?? '';
    if (hash.isEmpty) return null;

    final fromRaw = m['from']?.toString() ?? '';
    final from = fromRaw.toLowerCase();
    final rawTo = m['to']?.toString() ?? '';
    final displayTo = rawTo.isEmpty ? '合约创建' : rawTo;

    final outgoing = from == walletLower;

    final valueWei = BigInt.tryParse(m['value']?.toString() ?? '0') ?? BigInt.zero;
    final amountDisplay = _weiToDecimal(valueWei, decimals);

    final ts = int.tryParse(m['timeStamp']?.toString() ?? '0') ?? 0;
    final timestampMs = ts > 0 ? ts * 1000 : 0;

    final blockNumber = int.tryParse(m['blockNumber']?.toString() ?? '');

    final gasUsed = BigInt.tryParse(m['gasUsed']?.toString() ?? '0') ?? BigInt.zero;
    final gasPrice =
        BigInt.tryParse(m['gasPrice']?.toString() ?? '0') ?? BigInt.zero;
    final feeWei = gasUsed * gasPrice;
    final gasUsedDisplay = gasUsed > BigInt.zero ? gasUsed.toString() : null;
    final gasFeeDisplay =
        feeWei > BigInt.zero ? _weiToDecimal(feeWei, decimals) : null;

    final isError = m['isError']?.toString() == '1';
    final receiptFail = m['txreceipt_status']?.toString() == '0';
    final statusSuccess = !isError && !receiptFail;

    return EvmTxListItem(
      hash: hash,
      isOutgoing: outgoing,
      statusSuccess: statusSuccess,
      amountDisplay: amountDisplay,
      from: fromRaw,
      to: displayTo,
      toAddress: rawTo,
      timestampMs: timestampMs,
      gasUsedDisplay: gasUsedDisplay,
      gasFeeDisplay: gasFeeDisplay,
      blockNumber: blockNumber,
    );
  }

  String _weiToDecimal(BigInt wei, int decimals) {
    if (decimals <= 0) return wei.toString();
    final divisor = BigInt.from(10).pow(decimals);
    final intPart = wei ~/ divisor;
    final fracPart = wei % divisor;
    if (fracPart == BigInt.zero) {
      return intPart.toString();
    }
    var fracStr = fracPart
        .toString()
        .padLeft(decimals, '0')
        .replaceAll(RegExp(r'0+$'), '');
    if (fracStr.isEmpty) return intPart.toString();
    return '$intPart.$fracStr';
  }
}
