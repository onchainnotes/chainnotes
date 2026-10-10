import 'dart:convert';

import 'package:chain_notes/common/storage/realm_storage_constants.dart';
import 'package:chain_notes/features/home/data/datasource/realm/note_realm_models.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

class NoteRealmManager {
  NoteRealmManager._();

  static NoteRealmManager? _instance;
  static NoteRealmManager get instance => _instance ??= NoteRealmManager._();

  Configuration? _config;
  Realm? _realm;

  Future<Configuration> _getConfig() async {
    if (_config != null) return _config!;
    final dir = await getApplicationDocumentsDirectory();
    _config = Configuration.local(
      [NoteRealm.schema],
      path: '${dir.path}/${RealmStorageConstants.noteRealmFileName}',
      schemaVersion: RealmStorageConstants.noteRealmSchemaVersion,
    );
    return _config!;
  }

  Realm _openSync() {
    if (_realm != null && !_realm!.isClosed) return _realm!;
    throw StateError('Realm not initialized. Call open() first.');
  }

  Future<Realm> open() async {
    if (_realm != null && !_realm!.isClosed) return _realm!;
    final config = await _getConfig();
    _realm = Realm(config);
    return _realm!;
  }

  Realm openSync() {
    if (_realm != null && !_realm!.isClosed) return _realm!;
    throw StateError('NoteRealmManager not opened. Call open() first.');
  }

  void close() {
    _realm?.close();
    _realm = null;
  }

  static NoteRealm _toRealm(Note note, int chainId, int? aggregatedWalletId) {
    final cid = note.chainId ?? chainId;
    final walletId = note.aggregatedWalletId ?? aggregatedWalletId;
    return NoteRealm(
      note.id,
      note.title,
      note.content,
      note.updatedAt,
      note.onChain,
      note.type.index,
      cid,
      createdAt: note.createdAt,
      imageUrlsJson: jsonEncode(note.imageUrls),
      blockchainHash: note.blockchainHash,
      aggregatedWalletId: walletId,
      contentHash: note.contentHash,
      author: note.author,
    );
  }

  static Note _fromRealm(NoteRealm r) {
    List<String> imageUrls = [];
    try {
      final list = jsonDecode(r.imageUrlsJson) as List<dynamic>?;
      if (list != null) {
        imageUrls = list.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return Note(
      id: r.id,
      title: r.title,
      content: r.content,
      updatedAt: r.updatedAt,
      createdAt: r.createdAt,
      imageUrls: imageUrls,
      onChain: r.onChain,
      type: NoteType.values[r.type],
      blockchainHash: r.blockchainHash,
      chainId: r.chainId,
      aggregatedWalletId: r.aggregatedWalletId,
      contentHash: r.contentHash,
      author: r.author,
    );
  }

  List<Note> loadByChainId(int chainId) {
    final realm = _openSync();
    return realm
        .all<NoteRealm>()
        .query('chainId == $chainId')
        .toList()
        .map(_fromRealm)
        .toList()
      ..sort((a, b) => b.createdAtOrUpdated.compareTo(a.createdAtOrUpdated));
  }

  List<Note> loadByWallet({int? aggregatedWalletId}) {
    final realm = _openSync();
    final query = aggregatedWalletId != null
        ? 'aggregatedWalletId == $aggregatedWalletId'
        : 'aggregatedWalletId == null';
    return realm
        .all<NoteRealm>()
        .query(query)
        .toList()
        .map(_fromRealm)
        .toList()
      ..sort((a, b) => b.createdAtOrUpdated.compareTo(a.createdAtOrUpdated));
  }

  static const int _recentDays = 30;
  static const int _recentLimit = 100;

  List<Note> loadRecentByChainId(
    int chainId, {
    int recentDays = _recentDays,
    int limit = _recentLimit,
  }) {
    final cutoffMs = DateTime.now()
        .subtract(Duration(days: recentDays))
        .millisecondsSinceEpoch;
    final realm = _openSync();
    final list = realm
        .all<NoteRealm>()
        .query('chainId == $chainId AND updatedAt >= $cutoffMs')
        .toList();
    final notes = list.map(_fromRealm).toList()
      ..sort((a, b) => b.createdAtOrUpdated.compareTo(a.createdAtOrUpdated));
    return notes.take(limit).toList();
  }

  List<Note> loadRecentByWallet({
    int? aggregatedWalletId,
    int recentDays = _recentDays,
    int limit = _recentLimit,
  }) {
    final cutoffMs = DateTime.now()
        .subtract(Duration(days: recentDays))
        .millisecondsSinceEpoch;
    final realm = _openSync();
    final query = aggregatedWalletId != null
        ? 'updatedAt >= $cutoffMs AND aggregatedWalletId == $aggregatedWalletId'
        : 'updatedAt >= $cutoffMs AND aggregatedWalletId == null';
    final list = realm.all<NoteRealm>().query(query).toList();
    final notes = list.map(_fromRealm).toList()
      ..sort((a, b) => b.createdAtOrUpdated.compareTo(a.createdAtOrUpdated));
    return notes.take(limit).toList();
  }

  bool hasAnyNotesForChain(int chainId) {
    final realm = _openSync();
    return realm.all<NoteRealm>().query('chainId == $chainId').isNotEmpty;
  }

  bool hasAnyNotes() {
    final realm = _openSync();
    return realm.all<NoteRealm>().isNotEmpty;
  }

  void saveNote(Note note, int chainId, {int? aggregatedWalletId}) {
    final realm = _openSync();
    realm.write(() {
      final existing = realm.find<NoteRealm>(note.id);
      final r = _toRealm(note, chainId, aggregatedWalletId);
      if (existing != null) {
        existing.title = r.title;
        existing.content = r.content;
        existing.updatedAt = r.updatedAt;
        existing.createdAt = r.createdAt;
        existing.imageUrlsJson = r.imageUrlsJson;
        existing.onChain = r.onChain;
        existing.type = r.type;
        existing.blockchainHash = r.blockchainHash;
        existing.aggregatedWalletId = r.aggregatedWalletId;
        existing.contentHash = r.contentHash;
        existing.author = r.author;
      } else {
        realm.add(r);
      }
    });
  }

  void deleteNotesByWalletId(int aggregatedWalletId) {
    final realm = _openSync();
    realm.write(() {
      final list = realm
          .all<NoteRealm>()
          .query('aggregatedWalletId == $aggregatedWalletId')
          .toList();
      realm.deleteMany(list);
    });
  }

  void deleteNote(String id) {
    final realm = _openSync();
    realm.write(() {
      final r = realm.find<NoteRealm>(id);
      if (r != null) realm.delete(r);
    });
  }

  void deleteAll() {
    final realm = _openSync();
    realm.write(() {
      realm.deleteAll<NoteRealm>();
    });
  }
}
