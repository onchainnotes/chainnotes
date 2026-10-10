import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:chain_notes/features/home/data/abi/on_chain_note_nft_product_abi.dart';
import 'package:chain_notes/features/home/data/config/nft_config.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/note/data/service/ipfs_service.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:web3dart/web3dart.dart';

class NotesChainSyncService {
  NotesChainSyncService._();

  static final NotesChainSyncService instance = NotesChainSyncService._();

  Future<List<Note>> fetchOnChainNotesWithContent({
    required Chain chain,
    required String ownerAddress,
    required int chainId,
    int? aggregatedWalletId,
    bool logSteps = false,
  }) async {
    void step(String msg) {
      if (!logSteps) return;
      // ignore: avoid_print
      print('[链上笔记拉取] chainId=$chainId $msg');
    }

    step('步骤A 开始 owner=$ownerAddress aggregatedWalletId=$aggregatedWalletId');

    final rpcUrl = await resolveEffectivePrimaryNetworkUrl(
      chain,
      rpcUsageScenario: '链上笔记同步 getNotesOfOwner',
    );
    final contractAddr = NftConfig.getContractAddress(chain.chainId);
    if (rpcUrl == null || contractAddr == null) {
      step('步骤B 结束：rpc 或合约未配置 rpcUrl=$rpcUrl contract=$contractAddr');
      return [];
    }
    step('步骤B 已取 rpcUrl=$rpcUrl contract=$contractAddr');

    step('步骤C 发起 getNotesOfOwner(address)（Web3Client.call + sender=owner）');
    final res = await _getNotesOfOwner(
      rpcUrl: rpcUrl,
      contractHex: contractAddr,
      ownerAddress: ownerAddress,
      logSteps: logSteps,
    );
    step(
      '步骤D getNotesOfOwner 解码完成 token 数=${res.ids.length} '
      '(若为空则无需拉 IPFS)',
    );
    if (res.ids.isEmpty) {
      step('步骤E 结束：该地址在本链无笔记 NFT');
      return [];
    }

    final notes = <Note>[];
    for (var i = 0; i < res.ids.length; i++) {
      final tokenId = res.ids[i].toString();

      final storageId = '${chainId}_$tokenId';
      final tokenUri = res.tokenUris[i];
      final contentUri = res.contentUris[i];
      final createdAtMs = res.createdAts[i] * 1000;
      step(
        '步骤F[${i + 1}/${res.ids.length}] tokenId=$tokenId '
        'tokenUri=${tokenUri.length > 80 ? "${tokenUri.substring(0, 80)}..." : tokenUri} '
        'contentUri=${contentUri.length > 80 ? "${contentUri.substring(0, 80)}..." : contentUri}',
      );
      try {
        step('步骤F[${i + 1}] 拉取 nft.json（tokenURI）');
        final nftJson = await IpfsService.instance.fetchJsonFromUri(tokenUri);
        step('步骤F[${i + 1}] nft.json OK keys=${nftJson?.keys.join(",") ?? "null"}');

        step('步骤F[${i + 1}] 拉取 note.json（contentURI）');
        final contentJson = await IpfsService.instance.fetchJsonFromUri(contentUri);
        step('步骤F[${i + 1}] note.json OK keys=${contentJson?.keys.join(",") ?? "null"}');

        final title =
            (contentJson?['title'] as String?) ?? (nftJson?['name'] as String?) ?? '链上笔记 #$tokenId';
        final content = (contentJson?['content'] as String?) ?? '';
        final images = (contentJson?['images'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            <String>[];

        notes.add(
          Note(
            id: storageId,
            title: title,
            content: content,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
            createdAt: createdAtMs,
            imageUrls: images,
            onChain: true,
            type: NoteType.onchain,
            chainId: chainId,
            aggregatedWalletId: aggregatedWalletId,
            tokenUri: tokenUri,
            contentUri: contentUri,
          ),
        );
        step(
          '步骤F[${i + 1}] 组装 Note 成功 success=true titleLen=${title.length} '
          'contentLen=${content.length} images=${images.length}',
        );
      } catch (e, st) {
        step('步骤F[${i + 1}] 元数据/IPFS 失败，使用占位 Note: $e');
        if (logSteps) {
          // ignore: avoid_print
          print('$st');
        }
        notes.add(
          Note(
            id: storageId,
            title: '链上笔记 #$tokenId',
            content: '',
            updatedAt: DateTime.now().millisecondsSinceEpoch,
            createdAt: createdAtMs,
            imageUrls: const [],
            onChain: true,
            type: NoteType.onchain,
            chainId: chainId,
            aggregatedWalletId: aggregatedWalletId,
            tokenUri: tokenUri,
            contentUri: contentUri,
          ),
        );
      }
    }
    step('步骤G 完成：本链共返回 ${notes.length} 条 Note');
    return notes;
  }

  static EthereumAddress _ethAddress(String address) {
    final t = address.trim();
    return EthereumAddress.fromHex(t.startsWith('0x') ? t : '0x$t');
  }

  static ({List<BigInt> ids, List<String> tokenUris, List<String> contentUris, List<int> createdAts})
      _parseGetNotesOfOwnerOutputs(List<dynamic> raw) {
    if (raw.length != 4) {
      throw StateError('getNotesOfOwner 应返回 4 个输出，实际 ${raw.length}');
    }
    final ids = _coerceBigIntList(raw[0]);
    final tokenUris = _coerceStringList(raw[1]);
    final contentUris = _coerceStringList(raw[2]);
    final createdAts = _coerceBigIntList(raw[3]).map((e) => e.toInt()).toList();

    if (!(ids.length == tokenUris.length &&
        ids.length == contentUris.length &&
        ids.length == createdAts.length)) {
      throw StateError(
        '四数组长度不一致 ids=${ids.length} tokenUris=${tokenUris.length} '
        'contentUris=${contentUris.length} createdAts=${createdAts.length}',
      );
    }

    return (
      ids: ids,
      tokenUris: tokenUris,
      contentUris: contentUris,
      createdAts: createdAts
    );
  }

  static List<BigInt> _coerceBigIntList(dynamic v) {
    if (v is! List) {
      throw StateError('期望 List 得到 ${v.runtimeType}');
    }
    return v.map<BigInt>((dynamic e) {
      if (e is BigInt) return e;
      if (e is int) return BigInt.from(e);
      throw StateError('uint256 元素类型 ${e.runtimeType}');
    }).toList();
  }

  static List<String> _coerceStringList(dynamic v) {
    if (v is! List) {
      throw StateError('期望 List 得到 ${v.runtimeType}');
    }
    return v.map<String>((dynamic e) {
      if (e is String) return e;
      throw StateError('string 元素类型 ${e.runtimeType}');
    }).toList();
  }

  static String _bytesToHex0x(List<int> bytes) {
    return '0x${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
  }

  Future<({List<BigInt> ids, List<String> tokenUris, List<String> contentUris, List<int> createdAts})>
      _getNotesOfOwner({
    required String rpcUrl,
    required String contractHex,
    required String ownerAddress,
    bool logSteps = false,
  }) async {
    final sender = _ethAddress(ownerAddress);
    final contract = _ethAddress(contractHex);

    const rpcTimeout = Duration(seconds: 25);
    final httpClient = http.Client();
    final client = Web3Client(rpcUrl, httpClient);
    try {
      final abi = ContractAbi.fromJson(
        kOnChainNoteNftProductAbiJson,
        'OnChainNoteNFTProduct',
      );
      final deployed = DeployedContract(abi, contract);
      final function = deployed.function('getNotesOfOwner');

      final calldata = function.encodeCall([sender]);
      if (logSteps) {
        final hex = _bytesToHex0x(calldata);
        final sel = hex.length >= 10 ? hex.substring(0, 10).toLowerCase() : hex;
        // ignore: avoid_print
        print(
          '[链上笔记拉取] getNotesOfOwner Web3Client.call to=${contract.hex} owner=${sender.hex}',
        );
        // ignore: avoid_print
        print('[链上笔记拉取] getNotesOfOwner data=$hex');
        // ignore: avoid_print
        print(
          '[链上笔记拉取] getNotesOfOwner functionSelector=$sel '
          'dataLength=${hex.length} (chars, 含0x)',
        );
      }

      final raw = await client
          .call(
            sender: sender,
            contract: deployed,
            function: function,
            params: [sender],
          )
          .timeout(rpcTimeout);

      return _parseGetNotesOfOwnerOutputs(raw);
    } on TimeoutException catch (_) {

      if (logSteps) {
        // ignore: avoid_print
        print(
          '[链上笔记拉取] getNotesOfOwner RPC 超时（${rpcTimeout.inSeconds}s） '
          'contract=${contract.hex} owner=${sender.hex}',
        );
      }
      return (
        ids: <BigInt>[],
        tokenUris: <String>[],
        contentUris: <String>[],
        createdAts: <int>[]
      );
    } catch (e, st) {
      // ignore: avoid_print
      print(
        '[链上笔记拉取] getNotesOfOwner 调用或解码失败 contract=${contract.hex} '
        'owner=${sender.hex} detail=$e\n$st',
      );
      return (
        ids: <BigInt>[],
        tokenUris: <String>[],
        contentUris: <String>[],
        createdAts: <int>[]
      );
    } finally {
      await client.dispose();
      httpClient.close();
    }
  }
}
