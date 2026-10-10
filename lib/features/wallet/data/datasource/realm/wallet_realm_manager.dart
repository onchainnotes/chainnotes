import 'package:chain_notes/common/storage/realm_storage_constants.dart';
import 'package:chain_notes/features/wallet/data/datasource/realm/wallet_realm_models.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain_type.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';
import 'package:realm/realm.dart';

class WalletRealmManager {
  WalletRealmManager({String? path}) : _path = path {
    _config = Configuration.local(
      [
        ProtocolRealm.schema,
        WalletRealm.schema,
        AggregatedWalletRealm.schema,
      ],
      path: _path,
      schemaVersion: RealmStorageConstants.walletRealmSchemaVersion,
    );
  }

  final String? _path;
  late final Configuration _config;
  Realm? _realm;

  bool get isOpen => _realm != null && !_realm!.isClosed;

  Realm open() {
    if (_realm != null && !_realm!.isClosed) return _realm!;
    _realm = Realm(_config);
    return _realm!;
  }

  void close() {
    _realm?.close();
    _realm = null;
  }

  static ProtocolRealm _toProtocolRealm(Protocol entity) {
    return ProtocolRealm(
      ObjectId(),
      entity.publicKeyHex,
      entity.address,
      entity.derivationPath,
      entity.walletCoreCoinType,
      entity.protocolType,
    );
  }

  static WalletRealm _toWalletRealm(Wallet entity) {
    final protocols = entity.protocolAccounts.map(_toProtocolRealm).toList();
    return WalletRealm(
      entity.id,
      entity.address,
      entity.type.index,
      entity.chainType.index,
      entity.createdAt,
      name: entity.name,
      updatedAt: entity.updatedAt,
      walletId: entity.walletId,
      accountId: entity.accountId,
      totalAmountUsd: entity.totalAmountUsd,
      walletCoreCoinType: entity.walletCoreCoinType,
      defaultPublicKey: entity.defaultPublicKey,
      defaultAddress: entity.defaultAddress,
      derivationPath: entity.derivationPath,
      protocolAccounts: protocols,
    );
  }

  static bool _effectiveHadBackup(WalletType type, bool stored) {
    return switch (type) {
      WalletType.created => stored,
      WalletType.importedMnemonic => true,
      WalletType.importedPrivateKey => true,
    };
  }

  static AggregatedWalletRealm _toAggregatedWalletRealm(
    AggregatedWallet entity, {
    ObjectId? existingId,
  }) {
    final walletRealms = entity.wallets.map(_toWalletRealm).toList();
    final id = existingId ?? ObjectId();
    return AggregatedWalletRealm(
      id,
      entity.walletType.index,
      dbId: entity.id,
      wallets: walletRealms,
      currentWalletId: entity.currentWalletId,
      updatedAt: entity.updatedAt,
      walletIndex: entity.walletIndex,
      walletName: entity.walletName,
      encryptCore: entity.encryptCore,
      hadBackup: _effectiveHadBackup(entity.walletType, entity.hadBackup),
      totalAmountUsd: entity.totalAmountUsd,
      derivationIndex: entity.derivationIndex,
    );
  }

  static Protocol _fromProtocolRealm(ProtocolRealm r) {
    return Protocol(
      publicKeyHex: r.publicKeyHex,
      address: r.address,
      derivationPath: r.derivationPath,
      walletCoreCoinType: r.walletCoreCoinType,
      protocolType: r.protocolType,
    );
  }

  static Wallet _fromWalletRealm(WalletRealm r) {
    final protocols = r.protocolAccounts.map(_fromProtocolRealm).toList();
    return Wallet(
      id: r.id,
      address: r.address,
      type: WalletType.values[r.type],
      name: r.name,
      chainType: ChainType.values[r.chainType],
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
      walletId: r.walletId,
      accountId: r.accountId,
      totalAmountUsd: r.totalAmountUsd,
      walletCoreCoinType: r.walletCoreCoinType,
      defaultPublicKey: r.defaultPublicKey,
      defaultAddress: r.defaultAddress,
      derivationPath: r.derivationPath,
      protocolAccounts: protocols,
    );
  }

  static AggregatedWallet _fromAggregatedWalletRealm(AggregatedWalletRealm r) {
    final wallets = r.wallets.map(_fromWalletRealm).toList();
    final walletType = WalletType.values[r.walletType];
    return AggregatedWallet(
      wallets: wallets,
      currentWalletId: r.currentWalletId,
      updatedAt: r.updatedAt,
      id: r.dbId,
      walletIndex: r.walletIndex,
      walletName: r.walletName,
      walletType: walletType,
      encryptCore: r.encryptCore,
      hadBackup: _effectiveHadBackup(walletType, r.hadBackup),
      totalAmountUsd: r.totalAmountUsd,
      derivationIndex: r.derivationIndex,
    );
  }

  // --- CRUD ---

  void saveAggregatedWallet(AggregatedWallet entity) {
    final realm = open();
    realm.write(() {
      AggregatedWalletRealm? existing;
      if (entity.id != null) {
        existing = realm
            .all<AggregatedWalletRealm>()
            .query('dbId == ${entity.id}')
            .firstOrNull;
      }
      if (existing != null) {
        existing.currentWalletId = entity.currentWalletId;
        existing.updatedAt = entity.updatedAt;
        existing.walletIndex = entity.walletIndex;
        existing.walletName = entity.walletName;
        existing.walletType = entity.walletType.index;
        existing.encryptCore = entity.encryptCore;
        existing.hadBackup =
            _effectiveHadBackup(entity.walletType, entity.hadBackup);
        existing.totalAmountUsd = entity.totalAmountUsd;
        existing.derivationIndex = entity.derivationIndex;

        final oldWallets = existing.wallets.toList();
        existing.wallets.clear();
        for (final ow in oldWallets) {
          realm.delete(ow);
        }
        for (final w in entity.wallets) {
          final wr = _toWalletRealm(w);
          realm.add(wr);
          existing.wallets.add(wr);
        }
      } else {
        final agg = _toAggregatedWalletRealm(entity);

        final maxDbId = realm.all<AggregatedWalletRealm>().fold<int?>(
          null,
          (prev, r) => r.dbId != null && (prev == null || (r.dbId ?? 0) > prev)
              ? r.dbId
              : prev,
        );
        agg.dbId = (maxDbId ?? 0) + 1;
        for (final wr in agg.wallets) {
          realm.add(wr);
        }
        realm.add(agg);
      }
    });
  }

  List<AggregatedWallet> loadAllAggregatedWallets() {
    final realm = open();
    return realm
        .all<AggregatedWalletRealm>()
        .map(_fromAggregatedWalletRealm)
        .toList();
  }

  AggregatedWallet? loadAggregatedWalletByDbId(int dbId) {
    final realm = open();
    final r = realm
        .all<AggregatedWalletRealm>()
        .query('dbId == $dbId')
        .firstOrNull;
    return r == null ? null : _fromAggregatedWalletRealm(r);
  }

  AggregatedWallet? loadAggregatedWalletByObjectId(ObjectId id) {
    final realm = open();
    final r = realm.find<AggregatedWalletRealm>(id);
    return r == null ? null : _fromAggregatedWalletRealm(r);
  }

  void deleteAggregatedWalletByDbId(int dbId) {
    final realm = open();
    realm.write(() {
      final r = realm
          .all<AggregatedWalletRealm>()
          .query('dbId == $dbId')
          .firstOrNull;
      if (r != null) realm.delete(r);
    });
  }

  void deleteAggregatedWalletByObjectId(ObjectId id) {
    final realm = open();
    realm.write(() {
      final r = realm.find<AggregatedWalletRealm>(id);
      if (r != null) realm.delete(r);
    });
  }
}
