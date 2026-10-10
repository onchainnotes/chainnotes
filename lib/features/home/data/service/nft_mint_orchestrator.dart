import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:http/http.dart' as http;
import 'package:chain_notes/features/home/data/config/nft_config.dart';
import 'package:chain_notes/features/home/data/service/erc721_mint_service.dart';
import 'package:chain_notes/features/home/data/service/gas_fee_calculator.dart';
import 'package:chain_notes/features/home/data/service/gas_speed.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:web3dart/web3dart.dart';

import 'package:flutter_trust_wallet_core/protobuf/Ethereum.pb.dart' as eth;

class NftMintOrchestrator {
  NftMintOrchestrator._();

  static final NftMintOrchestrator instance = NftMintOrchestrator._();

  Future<({String txHash, BigInt tokenId})> mint({
    required List<int> privateKeyBytes,
    required Note note,
    required Chain chain,
    required String toAddress,
    GasSpeed gasSpeed = GasSpeed.normal,
    String? contractAddress,
    String? tokenUri,
    String? contentUri,
  }) async {
    final rpcUrl = await resolveEffectivePrimaryNetworkUrl(
      chain,
      rpcUsageScenario: 'NFT 铸造 mint',
    );
    if (rpcUrl == null || rpcUrl.isEmpty) {
      throw Exception('链未配置 RPC');
    }

    final contract =
        contractAddress ?? NftConfig.getContractAddress(chain.chainId);
    if (contract == null || contract.isEmpty) {
      throw Exception('未配置 NFT 合约地址，请在 NftConfig 中设置');
    }

    final calldata = Erc721MintService.instance.buildMintCalldataForNote(
      tokenUri: tokenUri,
      contentUri: contentUri,
    );
    if (calldata == null || calldata.isEmpty) {
      throw Exception('构建铸造数据失败');
    }

    final from = EthereumAddress.fromHex(
      toAddress.startsWith('0x') ? toAddress : '0x$toAddress',
    ).hex;

    await _probeOnChainNoteContract(
      rpcUrl: rpcUrl,
      contract: contract,
      ownerAddress: from,
    );

    try {
      await _rpcCall(rpcUrl, 'eth_call', [
        {
          'from': from,
          'to': contract,
          'data': calldata,
          'value': '0x0',
          'gas': '0x2dc6c0', // 3,000,000
        },
        'latest',
      ]);
    } catch (e) {

      // ignore: avoid_print
      print(
        'mintNote 预检告警（继续发送交易）: rpc=$rpcUrl contract=$contract '
        'tokenUriLen=${tokenUri?.length ?? 0} contentUriLen=${contentUri?.length ?? 0} detail=$e',
      );
    }

    final nonce = await _getNonce(rpcUrl, from);
    var gasLimit = await _estimateGas(rpcUrl, from, contract, calldata);

    gasLimit = (gasLimit * BigInt.from(120) ~/ BigInt.from(100)) + BigInt.from(50000);
    if (gasLimit < BigInt.from(350000)) gasLimit = BigInt.from(350000);
    if (gasLimit > BigInt.from(5000000)) gasLimit = BigInt.from(5000000);
    final feeCtx = await GasFeeCalculator.fetchEip1559FeeContext(
      (m, p) => _rpcCall(rpcUrl, m, p),
    );
    final feeQuote = GasFeeCalculator.quoteForSpeed(
      feeCtx.baseFeeWei,
      feeCtx.suggestedPriorityFeeWei,
      gasSpeed,
    );

    final chainId = chain.chainId ?? 1;
    final chainIdBytes = _uint256ToBytes(BigInt.from(chainId));
    final nonceBytes = _uint256ToBytes(nonce);
    final gasLimitBytes = _uint256ToBytes(gasLimit);
    final maxFeeBytes = _uint256ToBytes(feeQuote.maxFeePerGas);
    final maxPriorityBytes =
        _uint256ToBytes(feeQuote.maxPriorityFeePerGas);

    final dataBytes = _hexToBytes(calldata);

    final tx = eth.Transaction(
      contractGeneric: eth.Transaction_ContractGeneric(
        amount: _uint256ToBytes(BigInt.zero),
        data: dataBytes,
      ),
    );

    final input = eth.SigningInput(
      chainId: chainIdBytes,
      nonce: nonceBytes,
      txMode: eth.TransactionMode.Enveloped,
      gasLimit: gasLimitBytes,
      maxFeePerGas: maxFeeBytes,
      maxInclusionFeePerGas: maxPriorityBytes,
      toAddress: contract,
      privateKey: privateKeyBytes,
      transaction: tx,
    );

    final inputBytes = input.writeToBuffer();
    final outputBytes = AnySigner.sign(
      inputBytes,
      TWCoinType.TWCoinTypeEthereum,
    );

    final output = eth.SigningOutput.fromBuffer(outputBytes);
    if (!output.hasEncoded() || output.encoded.isEmpty) {
      throw Exception('安全验证失败');
    }

    final rawHex =
        '0x${output.encoded.map((b) => b.toRadixString(16).padLeft(2, '0')).join('')}';
    final txHash = await _sendRawTransaction(rpcUrl, rawHex);
    final tokenId = await _waitForMintedTokenId(
      rpcUrl: rpcUrl,
      txHash: txHash,
      contract: contract,
      toAddress: from,
    );
    final fullTxHash = _fullTransactionHashForLog(txHash);
    // ignore: avoid_print
    print(
      '[上链成功] success=true status=confirmed transactionHash=$fullTxHash '
      'tokenId=$tokenId chainId=$chainId contract=$contract',
    );
    return (txHash: txHash, tokenId: tokenId);
  }

  static String _fullTransactionHashForLog(String hash) {
    final h = hash.trim().toLowerCase();
    final body = h.startsWith('0x') ? h.substring(2) : h;
    if (body.length != 64 || !RegExp(r'^[0-9a-f]{64}$').hasMatch(body)) {
      return h.startsWith('0x') ? h : '0x$h';
    }
    return '0x$body';
  }

  static const String _transferTopic0 =
      '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef';

  Future<BigInt> _waitForMintedTokenId({
    required String rpcUrl,
    required String txHash,
    required String contract,
    required String toAddress,
  }) async {

    for (var i = 0; i < 60; i++) {
      dynamic receipt;
      try {
        receipt = await _rpcCall(
          rpcUrl,
          'eth_getTransactionReceipt',
          [txHash],
          timeout: const Duration(seconds: 20),
          retryTimes: 1,
        );
      } catch (_) {

        await Future.delayed(const Duration(seconds: 2));
        continue;
      }
      if (receipt is Map<String, dynamic>) {
        final status = receipt['status']?.toString();
        if (status == '0x0') {
          final h = _fullTransactionHashForLog(txHash);
          throw Exception(
            '交易执行失败（收据 status=0，可能为合约 revert 或 Gas 不足）。'
            '请在浏览器用交易哈希核对：$h',
          );
        }
        if (status == '0x1') {
          final logs = (receipt['logs'] as List<dynamic>?) ?? const [];
          final tokenId = _extractTokenIdFromTransferLogs(
            logs: logs,
            contract: contract,
            toAddress: toAddress,
          );
          if (tokenId != null) return tokenId;

          throw Exception('交易已确认，但未解析到 tokenId');
        }
      }
      await Future.delayed(const Duration(seconds: 2));
    }
    throw Exception('等待交易确认超时');
  }

  BigInt? _extractTokenIdFromTransferLogs({
    required List<dynamic> logs,
    required String contract,
    required String toAddress,
  }) {
    final normalizedContract = contract.toLowerCase();
    final normalizedTo = toAddress.toLowerCase();
    for (final l in logs) {
      if (l is! Map) continue;
      final addr = (l['address']?.toString() ?? '').toLowerCase();
      if (addr != normalizedContract) continue;
      final topics = (l['topics'] as List<dynamic>?) ?? const [];
      if (topics.isEmpty) continue;
      final topic0 = topics[0].toString().toLowerCase();
      if (topic0 != _transferTopic0) continue;
      // topics[2] = to (indexed address), topics[3] = tokenId
      if (topics.length < 4) continue;
      final toTopic = topics[2].toString().toLowerCase();

      final toAddr = '0x${toTopic.substring(toTopic.length - 40)}';
      if (toAddr.toLowerCase() != normalizedTo) continue;
      final tokenIdTopic = topics[3].toString();
      final hex = tokenIdTopic.startsWith('0x')
          ? tokenIdTopic.substring(2)
          : tokenIdTopic;
      return BigInt.parse(hex, radix: 16);
    }
    return null;
  }

  Future<BigInt> _getNonce(String rpcUrl, String address) async {
    final result = await _rpcCall(rpcUrl, 'eth_getTransactionCount', [
      address,
      'pending',
    ]);
    final hex = result as String?;
    if (hex == null || hex.isEmpty) return BigInt.zero;
    return BigInt.parse(hex.startsWith('0x') ? hex.substring(2) : hex, radix: 16);
  }

  Future<BigInt> _estimateGas(
    String rpcUrl,
    String from,
    String to,
    String calldata,
  ) async {
    try {
      final result = await _rpcCall(rpcUrl, 'eth_estimateGas', [
        {
          'from': from,
          'to': to,
          'data': calldata,
          'value': '0x0',
        },
      ]);
      final hex = result as String?;
      if (hex == null || hex.isEmpty) return BigInt.from(200000);
      return BigInt.parse(
        hex.startsWith('0x') ? hex.substring(2) : hex,
        radix: 16,
      );
    } catch (_) {
      return BigInt.from(200000);
    }
  }

  Future<void> _probeOnChainNoteContract({
    required String rpcUrl,
    required String contract,
    required String ownerAddress,
  }) async {

    final code = await _rpcCall(rpcUrl, 'eth_getCode', [contract, 'latest']);
    final codeHex = code?.toString() ?? '';
    if (codeHex.isEmpty || codeHex == '0x') {
      throw Exception(
        '当前合约地址不是已部署合约地址（目标地址无字节码）。\n'
        'rpc: $rpcUrl\n'
        'contract: $contract\n'
      );
    }

    try {
      final fn = EthereumAbiFunction.createWithString('getNotesOfOwner(address)');
      try {
        fn.addParamAddress(_addressToBytes(ownerAddress), false);
        final encoded = EthereumAbi.encode(fn);
        final calldata =
            '0x${encoded.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
        final probeFrom = EthereumAddress.fromHex(
          ownerAddress.startsWith('0x') ? ownerAddress : '0x$ownerAddress',
        ).hex;
        await _rpcCall(rpcUrl, 'eth_call', [
          {'from': probeFrom, 'to': contract, 'data': calldata},
          'latest',
        ]);
      } finally {
        fn.delete();
      }
    } catch (e) {
      // ignore: avoid_print
      print('合约探测告警（继续发送交易）: getNotesOfOwner 调用失败 detail=$e');
    }
  }

  static Uint8List _addressToBytes(String address) {
    final s = address.startsWith('0x') ? address.substring(2) : address;
    if (s.length != 40) {
      throw ArgumentError('Invalid address length: $address');
    }
    return Uint8List.fromList([
      for (int i = 0; i < 40; i += 2) int.parse(s.substring(i, i + 2), radix: 16),
    ]);
  }

  Future<String> _sendRawTransaction(String rpcUrl, String signedHex) async {
    final result = await _rpcCall(
      rpcUrl,
      'eth_sendRawTransaction',
      [signedHex],
      timeout: const Duration(seconds: 45),
      retryTimes: 1,
    );
    final hash = result as String?;
    if (hash == null || hash.isEmpty) {
      throw Exception('发送交易失败');
    }
    return hash;
  }

  Future<dynamic> _rpcCall(
    String rpcUrl,
    String method,
    List<dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
    int retryTimes = 0,
  }) async {
    final uri = Uri.parse(rpcUrl);
    final body = jsonEncode({
      'jsonrpc': '2.0',
      'method': method,
      'params': params,
      'id': 1,
    });
    Object? lastError;
    for (var attempt = 0; attempt <= retryTimes; attempt++) {
      try {
        final response = await http
            .post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: body,
            )
            .timeout(timeout);

        if (response.statusCode != 200) {
          throw Exception('RPC 请求失败: ${response.statusCode}');
        }

        final json = jsonDecode(response.body) as Map<String, dynamic>?;
        if (json == null) throw Exception('RPC 响应解析失败');

        final error = json['error'];
        if (error != null) {
          final msg = (error is Map && error['message'] != null)
              ? error['message'].toString()
              : error.toString();
          throw Exception('RPC 错误: $msg');
        }
        return json['result'];
      } on TimeoutException catch (e) {
        lastError = e;
        if (attempt < retryTimes) {
          await Future.delayed(const Duration(milliseconds: 600));
          continue;
        }
      } catch (e) {
        lastError = e;
        if (attempt < retryTimes) {
          await Future.delayed(const Duration(milliseconds: 600));
          continue;
        }
      }
    }
    throw Exception('RPC 调用失败($method): $lastError');
  }

  List<int> _uint256ToBytes(BigInt value) {
    if (value < BigInt.zero) value = BigInt.zero;
    var hex = value.toRadixString(16);
    if (hex.length % 2 == 1) hex = '0$hex';
    hex = hex.padLeft(64, '0');
    if (hex.length > 64) hex = hex.substring(hex.length - 64);
    return [
      for (int i = 0; i < 64; i += 2) int.parse(hex.substring(i, i + 2), radix: 16)
    ];
  }

  List<int> _hexToBytes(String hex) {
    final s = hex.startsWith('0x') ? hex.substring(2) : hex;
    return [
      for (int i = 0; i < s.length; i += 2) int.parse(s.substring(i, i + 2), radix: 16)
    ];
  }
}
