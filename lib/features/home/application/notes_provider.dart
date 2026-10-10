import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chain_notes/features/home/data/config/nft_config.dart';
import 'package:chain_notes/features/home/data/datasource/realm/note_realm_manager.dart';
import 'package:chain_notes/features/home/data/service/notes_chain_sync_service.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_provider.g.dart';

final notesSyncingProvider = StateProvider<bool>((ref) => false);

@riverpod
class Notes extends _$Notes {

  int _bgSyncGen = 0;

  @override
  Future<List<Note>> build() async {
    try {
      final bgGen = ++_bgSyncGen;
      final walletId = await loadCurrentAggregatedWalletId();
      final local = NoteRealmManager.instance.loadRecentByWallet(
        aggregatedWalletId: walletId,
        recentDays: 30,
        limit: 100,
      );

      if (local.isNotEmpty) {
        Future(() => _syncFromChainAndUpdate(walletId, local, bgGen));
        return local;
      }
      return await _syncFromChainAndReturn(
        walletId,
        local,
        logChainSyncSteps: true,
      );
    } catch (e) {
      return [];
    }
  }

  Future<void> _syncFromChainAndUpdate(
    int? walletId,
    List<Note> local,
    int bgGen,
  ) async {
    try {
      ref.read(notesSyncingProvider.notifier).state = true;
    } catch (_) {}

    try {
      final merged = await _syncFromChainAndReturn(
        walletId,
        local,
        logChainSyncSteps: false,
      );
      if (bgGen != _bgSyncGen) return;
      try {
        state = AsyncData(merged);
      } catch (_) {}
    } catch (e, st) {
      assert(() {
        debugPrint('[Notes] 后台链上同步失败（已忽略）: $e\n$st');
        return true;
      }());
    } finally {
      try {
        ref.read(notesSyncingProvider.notifier).state = false;
      } catch (_) {}
    }
  }

  Future<List<Note>> _syncFromChainAndReturn(
    int? walletId,
    List<Note> local, {
    bool logChainSyncSteps = false,
  }) async {
    void log(String msg) {
      if (!logChainSyncSteps) return;
      // ignore: avoid_print
      print('[首页链上同步] $msg');
    }

    try {
      log('步骤1 开始：本地笔记条数=${local.length}，aggregatedWalletId=$walletId');

      final addr = await loadCurrentWalletAddress();
      if (addr == null || addr.isEmpty) {
        log('步骤2 结束：未加载到当前钱包地址，保持本地列表');
        return local;
      }
      log('步骤2 已解析钱包地址 addr=$addr');

      final chainIdsWithContract = NftConfig.chainIdsWithContract;
      if (chainIdsWithContract.isEmpty) {
        log('步骤3 结束：NftConfig 未配置任何带合约的 chainId，保持本地列表');
        return local;
      }
      log('步骤3 将遍历链 chainId 列表=$chainIdsWithContract');

      final futures = <Future<List<Note>>>[];

      for (final chainId in chainIdsWithContract) {
        futures.add(() async {
          try {
            log('步骤4[$chainId] 开始处理该链');
            final chain = ChainFromDemo.findByChainId(chainId);
            if (chain == null || !chainHasResolvableEndpoint(chain)) {
              log('步骤4[$chainId] 跳过：ChainFromDemo 无链配置或无可解析 RPC');
              return const <Note>[];
            }

            final displayInfo = await loadCurrentWalletDisplayInfo(addr, chainId);
            final ownerAddress = displayInfo.protocolAddress ?? addr;
            if (ownerAddress.isEmpty) {
              log('步骤4[$chainId] 跳过：ownerAddress 为空');
              return const <Note>[];
            }
            log('步骤4[$chainId] 合约侧查询地址 owner=$ownerAddress');

            final notes = await NotesChainSyncService.instance
                .fetchOnChainNotesWithContent(
                  chain: chain,
                  ownerAddress: ownerAddress,
                  chainId: chainId,
                  aggregatedWalletId: walletId,
                  logSteps: logChainSyncSteps,
                );

            log('步骤4[$chainId] 本链解析笔记条数=${notes.length}');
            return notes;
          } catch (e, st) {

            if (logChainSyncSteps) {
              // ignore: avoid_print
              print('[首页链上同步] 步骤4[$chainId] 异常（继续其它链）: $e\n$st');
            }
            return const <Note>[];
          }
        }());
      }

      final results = await Future.wait(futures);
      final allOnChainNotes = <Note>[];
      for (final list in results) {
        allOnChainNotes.addAll(list);
      }

      log('步骤5 全链合计链上笔记条数=${allOnChainNotes.length}');
      if (allOnChainNotes.isEmpty) {
        log('步骤6 结束：链上无笔记，返回原本地列表');
        return local;
      }

      final realm = NoteRealmManager.instance;
      for (final note in allOnChainNotes) {
        final cid = note.chainId ?? 11155111;
        realm.saveNote(note, cid, aggregatedWalletId: walletId);
      }
      log('步骤6 已写入 Realm，条数=${allOnChainNotes.length}');

      ref.invalidate(realmHasAnyNotesProvider);
      final reloaded = realm.loadRecentByWallet(
        aggregatedWalletId: walletId,
        recentDays: 30,
        limit: 100,
      );
      log('步骤7 完成：重新加载本地列表 success=true，条数=${reloaded.length}');
      return reloaded;
    } catch (e, st) {
      if (logChainSyncSteps) {
        // ignore: avoid_print
        print('[首页链上同步] 同步流程异常，返回原本地列表: $e\n$st');
      }
      return local;
    }
  }

  void updateNote(String id, Map<String, dynamic> updates) {
    final list = state.value ?? [];
    final idx = list.indexWhere((n) => n.id == id);
    List<Note> newList;
    if (idx >= 0) {
      final n = list[idx];
      newList = [
        ...list.sublist(0, idx),
        _applyUpdates(n, updates),
        ...list.sublist(idx + 1),
      ];
    } else {
      final now = DateTime.now().millisecondsSinceEpoch;
      final note = Note(
        id: id,
        title: updates['title'] as String? ?? '',
        content: updates['content'] as String? ?? '',
        updatedAt: updates['updatedAt'] as int? ?? now,
        createdAt: now,
        imageUrls: (updates['imageUrls'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        onChain: updates['onChain'] as bool? ?? false,
        type: updates['type'] as NoteType? ?? NoteType.draft,
        blockchainHash: updates['blockchainHash'] as String?,
        chainId: updates['chainId'] as int?,
        contentHash: updates['contentHash'] as String?,
        author: updates['author'] as String?,
        tokenUri: updates['tokenUri'] as String?,
        contentUri: updates['contentUri'] as String?,
      );
      newList = [note, ...list];
    }
    state = AsyncData(newList);
  }

  void removeNoteFromList(String id) {
    final list = state.value ?? const <Note>[];
    final newList = list.where((n) => n.id != id).toList();
    state = AsyncData(newList);
  }

  Note _applyUpdates(Note n, Map<String, dynamic> updates) {
    return n.copyWith(
      title: updates['title'] as String?,
      content: updates['content'] as String?,
      imageUrls: updates['imageUrls'] != null
          ? (updates['imageUrls'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
      updatedAt: updates['updatedAt'] as int?,
      onChain: updates['onChain'] as bool?,
      type: updates['type'] as NoteType?,
      blockchainHash: updates['blockchainHash'] as String?,
      chainId: updates['chainId'] as int?,
      aggregatedWalletId: updates['aggregatedWalletId'] as int?,
      contentHash: updates['contentHash'] as String?,
      author: updates['author'] as String?,
      tokenUri: updates['tokenUri'] as String?,
      contentUri: updates['contentUri'] as String?,
    );
  }

  Note? getNote(String id) {
    final list = state.value ?? [];
    try {
      return list.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }
}

final realmHasAnyNotesProvider = Provider<bool>((ref) {
  try {
    return NoteRealmManager.instance.hasAnyNotes();
  } catch (_) {
    return false;
  }
});

final realmHasNotesForCurrentWalletProvider = FutureProvider<bool>((ref) async {
  try {

    if (WalletUtils.hasWalletInRealm() == false) return false;
    final walletId = await loadCurrentAggregatedWalletId();
    final list = NoteRealmManager.instance.loadByWallet(aggregatedWalletId: walletId);
    return list.isNotEmpty;
  } catch (_) {
    return false;
  }
});
