// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_realm_models.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class ProtocolRealm extends _ProtocolRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  ProtocolRealm(
    ObjectId id,
    String publicKeyHex,
    String address,
    String derivationPath,
    int walletCoreCoinType,
    int protocolType,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'publicKeyHex', publicKeyHex);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'derivationPath', derivationPath);
    RealmObjectBase.set(this, 'walletCoreCoinType', walletCoreCoinType);
    RealmObjectBase.set(this, 'protocolType', protocolType);
  }

  ProtocolRealm._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get publicKeyHex =>
      RealmObjectBase.get<String>(this, 'publicKeyHex') as String;
  @override
  set publicKeyHex(String value) =>
      RealmObjectBase.set(this, 'publicKeyHex', value);

  @override
  String get address => RealmObjectBase.get<String>(this, 'address') as String;
  @override
  set address(String value) => RealmObjectBase.set(this, 'address', value);

  @override
  String get derivationPath =>
      RealmObjectBase.get<String>(this, 'derivationPath') as String;
  @override
  set derivationPath(String value) =>
      RealmObjectBase.set(this, 'derivationPath', value);

  @override
  int get walletCoreCoinType =>
      RealmObjectBase.get<int>(this, 'walletCoreCoinType') as int;
  @override
  set walletCoreCoinType(int value) =>
      RealmObjectBase.set(this, 'walletCoreCoinType', value);

  @override
  int get protocolType => RealmObjectBase.get<int>(this, 'protocolType') as int;
  @override
  set protocolType(int value) =>
      RealmObjectBase.set(this, 'protocolType', value);

  @override
  Stream<RealmObjectChanges<ProtocolRealm>> get changes =>
      RealmObjectBase.getChanges<ProtocolRealm>(this);

  @override
  Stream<RealmObjectChanges<ProtocolRealm>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<ProtocolRealm>(this, keyPaths);

  @override
  ProtocolRealm freeze() => RealmObjectBase.freezeObject<ProtocolRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'publicKeyHex': publicKeyHex.toEJson(),
      'address': address.toEJson(),
      'derivationPath': derivationPath.toEJson(),
      'walletCoreCoinType': walletCoreCoinType.toEJson(),
      'protocolType': protocolType.toEJson(),
    };
  }

  static EJsonValue _toEJson(ProtocolRealm value) => value.toEJson();
  static ProtocolRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'publicKeyHex': EJsonValue publicKeyHex,
        'address': EJsonValue address,
        'derivationPath': EJsonValue derivationPath,
        'walletCoreCoinType': EJsonValue walletCoreCoinType,
        'protocolType': EJsonValue protocolType,
      } =>
        ProtocolRealm(
          fromEJson(id),
          fromEJson(publicKeyHex),
          fromEJson(address),
          fromEJson(derivationPath),
          fromEJson(walletCoreCoinType),
          fromEJson(protocolType),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ProtocolRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      ProtocolRealm,
      'ProtocolRealm',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('publicKeyHex', RealmPropertyType.string),
        SchemaProperty('address', RealmPropertyType.string),
        SchemaProperty('derivationPath', RealmPropertyType.string),
        SchemaProperty('walletCoreCoinType', RealmPropertyType.int),
        SchemaProperty('protocolType', RealmPropertyType.int),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class WalletRealm extends _WalletRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  WalletRealm(
    String id,
    String address,
    int type,
    int chainType,
    int createdAt, {
    String? name,
    int? updatedAt,
    int? walletId,
    String? accountId,
    double totalAmountUsd = 0.0,
    int? walletCoreCoinType,
    String? defaultPublicKey,
    String? defaultAddress,
    String? derivationPath,
    Iterable<ProtocolRealm> protocolAccounts = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<WalletRealm>({
        'totalAmountUsd': 0.0,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'chainType', chainType);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'walletId', walletId);
    RealmObjectBase.set(this, 'accountId', accountId);
    RealmObjectBase.set(this, 'totalAmountUsd', totalAmountUsd);
    RealmObjectBase.set(this, 'walletCoreCoinType', walletCoreCoinType);
    RealmObjectBase.set(this, 'defaultPublicKey', defaultPublicKey);
    RealmObjectBase.set(this, 'defaultAddress', defaultAddress);
    RealmObjectBase.set(this, 'derivationPath', derivationPath);
    RealmObjectBase.set<RealmList<ProtocolRealm>>(
      this,
      'protocolAccounts',
      RealmList<ProtocolRealm>(protocolAccounts),
    );
  }

  WalletRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get address => RealmObjectBase.get<String>(this, 'address') as String;
  @override
  set address(String value) => RealmObjectBase.set(this, 'address', value);

  @override
  int get type => RealmObjectBase.get<int>(this, 'type') as int;
  @override
  set type(int value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int get chainType => RealmObjectBase.get<int>(this, 'chainType') as int;
  @override
  set chainType(int value) => RealmObjectBase.set(this, 'chainType', value);

  @override
  int get createdAt => RealmObjectBase.get<int>(this, 'createdAt') as int;
  @override
  set createdAt(int value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  int? get updatedAt => RealmObjectBase.get<int>(this, 'updatedAt') as int?;
  @override
  set updatedAt(int? value) => RealmObjectBase.set(this, 'updatedAt', value);

  @override
  int? get walletId => RealmObjectBase.get<int>(this, 'walletId') as int?;
  @override
  set walletId(int? value) => RealmObjectBase.set(this, 'walletId', value);

  @override
  String? get accountId =>
      RealmObjectBase.get<String>(this, 'accountId') as String?;
  @override
  set accountId(String? value) => RealmObjectBase.set(this, 'accountId', value);

  @override
  double get totalAmountUsd =>
      RealmObjectBase.get<double>(this, 'totalAmountUsd') as double;
  @override
  set totalAmountUsd(double value) =>
      RealmObjectBase.set(this, 'totalAmountUsd', value);

  @override
  int? get walletCoreCoinType =>
      RealmObjectBase.get<int>(this, 'walletCoreCoinType') as int?;
  @override
  set walletCoreCoinType(int? value) =>
      RealmObjectBase.set(this, 'walletCoreCoinType', value);

  @override
  String? get defaultPublicKey =>
      RealmObjectBase.get<String>(this, 'defaultPublicKey') as String?;
  @override
  set defaultPublicKey(String? value) =>
      RealmObjectBase.set(this, 'defaultPublicKey', value);

  @override
  String? get defaultAddress =>
      RealmObjectBase.get<String>(this, 'defaultAddress') as String?;
  @override
  set defaultAddress(String? value) =>
      RealmObjectBase.set(this, 'defaultAddress', value);

  @override
  String? get derivationPath =>
      RealmObjectBase.get<String>(this, 'derivationPath') as String?;
  @override
  set derivationPath(String? value) =>
      RealmObjectBase.set(this, 'derivationPath', value);

  @override
  RealmList<ProtocolRealm> get protocolAccounts =>
      RealmObjectBase.get<ProtocolRealm>(this, 'protocolAccounts')
          as RealmList<ProtocolRealm>;
  @override
  set protocolAccounts(covariant RealmList<ProtocolRealm> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<WalletRealm>> get changes =>
      RealmObjectBase.getChanges<WalletRealm>(this);

  @override
  Stream<RealmObjectChanges<WalletRealm>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<WalletRealm>(this, keyPaths);

  @override
  WalletRealm freeze() => RealmObjectBase.freezeObject<WalletRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'address': address.toEJson(),
      'type': type.toEJson(),
      'name': name.toEJson(),
      'chainType': chainType.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'walletId': walletId.toEJson(),
      'accountId': accountId.toEJson(),
      'totalAmountUsd': totalAmountUsd.toEJson(),
      'walletCoreCoinType': walletCoreCoinType.toEJson(),
      'defaultPublicKey': defaultPublicKey.toEJson(),
      'defaultAddress': defaultAddress.toEJson(),
      'derivationPath': derivationPath.toEJson(),
      'protocolAccounts': protocolAccounts.toEJson(),
    };
  }

  static EJsonValue _toEJson(WalletRealm value) => value.toEJson();
  static WalletRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'address': EJsonValue address,
        'type': EJsonValue type,
        'chainType': EJsonValue chainType,
        'createdAt': EJsonValue createdAt,
      } =>
        WalletRealm(
          fromEJson(id),
          fromEJson(address),
          fromEJson(type),
          fromEJson(chainType),
          fromEJson(createdAt),
          name: fromEJson(ejson['name']),
          updatedAt: fromEJson(ejson['updatedAt']),
          walletId: fromEJson(ejson['walletId']),
          accountId: fromEJson(ejson['accountId']),
          totalAmountUsd: fromEJson(ejson['totalAmountUsd'], defaultValue: 0.0),
          walletCoreCoinType: fromEJson(ejson['walletCoreCoinType']),
          defaultPublicKey: fromEJson(ejson['defaultPublicKey']),
          defaultAddress: fromEJson(ejson['defaultAddress']),
          derivationPath: fromEJson(ejson['derivationPath']),
          protocolAccounts: fromEJson(
            ejson['protocolAccounts'],
            defaultValue: const [],
          ),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(WalletRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      WalletRealm,
      'WalletRealm',
      [
        SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
        SchemaProperty('address', RealmPropertyType.string),
        SchemaProperty('type', RealmPropertyType.int),
        SchemaProperty('name', RealmPropertyType.string, optional: true),
        SchemaProperty('chainType', RealmPropertyType.int),
        SchemaProperty('createdAt', RealmPropertyType.int),
        SchemaProperty('updatedAt', RealmPropertyType.int, optional: true),
        SchemaProperty('walletId', RealmPropertyType.int, optional: true),
        SchemaProperty('accountId', RealmPropertyType.string, optional: true),
        SchemaProperty('totalAmountUsd', RealmPropertyType.double),
        SchemaProperty(
          'walletCoreCoinType',
          RealmPropertyType.int,
          optional: true,
        ),
        SchemaProperty(
          'defaultPublicKey',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'defaultAddress',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'derivationPath',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty(
          'protocolAccounts',
          RealmPropertyType.object,
          linkTarget: 'ProtocolRealm',
          collectionType: RealmCollectionType.list,
        ),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class AggregatedWalletRealm extends _AggregatedWalletRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  AggregatedWalletRealm(
    ObjectId id,
    int walletType, {
    int? dbId,
    Iterable<WalletRealm> wallets = const [],
    String? currentWalletId,
    int? updatedAt,
    int? walletIndex,
    String? walletName,
    String? encryptCore,
    bool hadBackup = false,
    double totalAmountUsd = 0.0,
    int derivationIndex = 0,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<AggregatedWalletRealm>({
        'hadBackup': false,
        'totalAmountUsd': 0.0,
        'derivationIndex': 0,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'dbId', dbId);
    RealmObjectBase.set<RealmList<WalletRealm>>(
      this,
      'wallets',
      RealmList<WalletRealm>(wallets),
    );
    RealmObjectBase.set(this, 'currentWalletId', currentWalletId);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'walletIndex', walletIndex);
    RealmObjectBase.set(this, 'walletName', walletName);
    RealmObjectBase.set(this, 'walletType', walletType);
    RealmObjectBase.set(this, 'encryptCore', encryptCore);
    RealmObjectBase.set(this, 'hadBackup', hadBackup);
    RealmObjectBase.set(this, 'totalAmountUsd', totalAmountUsd);
    RealmObjectBase.set(this, 'derivationIndex', derivationIndex);
  }

  AggregatedWalletRealm._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  int? get dbId => RealmObjectBase.get<int>(this, 'dbId') as int?;
  @override
  set dbId(int? value) => RealmObjectBase.set(this, 'dbId', value);

  @override
  RealmList<WalletRealm> get wallets =>
      RealmObjectBase.get<WalletRealm>(this, 'wallets')
          as RealmList<WalletRealm>;
  @override
  set wallets(covariant RealmList<WalletRealm> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get currentWalletId =>
      RealmObjectBase.get<String>(this, 'currentWalletId') as String?;
  @override
  set currentWalletId(String? value) =>
      RealmObjectBase.set(this, 'currentWalletId', value);

  @override
  int? get updatedAt => RealmObjectBase.get<int>(this, 'updatedAt') as int?;
  @override
  set updatedAt(int? value) => RealmObjectBase.set(this, 'updatedAt', value);

  @override
  int? get walletIndex => RealmObjectBase.get<int>(this, 'walletIndex') as int?;
  @override
  set walletIndex(int? value) =>
      RealmObjectBase.set(this, 'walletIndex', value);

  @override
  String? get walletName =>
      RealmObjectBase.get<String>(this, 'walletName') as String?;
  @override
  set walletName(String? value) =>
      RealmObjectBase.set(this, 'walletName', value);

  @override
  int get walletType => RealmObjectBase.get<int>(this, 'walletType') as int;
  @override
  set walletType(int value) => RealmObjectBase.set(this, 'walletType', value);

  @override
  String? get encryptCore =>
      RealmObjectBase.get<String>(this, 'encryptCore') as String?;
  @override
  set encryptCore(String? value) =>
      RealmObjectBase.set(this, 'encryptCore', value);

  @override
  bool get hadBackup => RealmObjectBase.get<bool>(this, 'hadBackup') as bool;
  @override
  set hadBackup(bool value) => RealmObjectBase.set(this, 'hadBackup', value);

  @override
  double get totalAmountUsd =>
      RealmObjectBase.get<double>(this, 'totalAmountUsd') as double;
  @override
  set totalAmountUsd(double value) =>
      RealmObjectBase.set(this, 'totalAmountUsd', value);

  @override
  int get derivationIndex =>
      RealmObjectBase.get<int>(this, 'derivationIndex') as int;
  @override
  set derivationIndex(int value) =>
      RealmObjectBase.set(this, 'derivationIndex', value);

  @override
  Stream<RealmObjectChanges<AggregatedWalletRealm>> get changes =>
      RealmObjectBase.getChanges<AggregatedWalletRealm>(this);

  @override
  Stream<RealmObjectChanges<AggregatedWalletRealm>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<AggregatedWalletRealm>(this, keyPaths);

  @override
  AggregatedWalletRealm freeze() =>
      RealmObjectBase.freezeObject<AggregatedWalletRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'dbId': dbId.toEJson(),
      'wallets': wallets.toEJson(),
      'currentWalletId': currentWalletId.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'walletIndex': walletIndex.toEJson(),
      'walletName': walletName.toEJson(),
      'walletType': walletType.toEJson(),
      'encryptCore': encryptCore.toEJson(),
      'hadBackup': hadBackup.toEJson(),
      'totalAmountUsd': totalAmountUsd.toEJson(),
      'derivationIndex': derivationIndex.toEJson(),
    };
  }

  static EJsonValue _toEJson(AggregatedWalletRealm value) => value.toEJson();
  static AggregatedWalletRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'walletType': EJsonValue walletType} =>
        AggregatedWalletRealm(
          fromEJson(id),
          fromEJson(walletType),
          dbId: fromEJson(ejson['dbId']),
          wallets: fromEJson(ejson['wallets'], defaultValue: const []),
          currentWalletId: fromEJson(ejson['currentWalletId']),
          updatedAt: fromEJson(ejson['updatedAt']),
          walletIndex: fromEJson(ejson['walletIndex']),
          walletName: fromEJson(ejson['walletName']),
          encryptCore: fromEJson(ejson['encryptCore']),
          hadBackup: fromEJson(ejson['hadBackup'], defaultValue: false),
          totalAmountUsd: fromEJson(ejson['totalAmountUsd'], defaultValue: 0.0),
          derivationIndex: fromEJson(ejson['derivationIndex'], defaultValue: 0),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AggregatedWalletRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      AggregatedWalletRealm,
      'AggregatedWalletRealm',
      [
        SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
        SchemaProperty('dbId', RealmPropertyType.int, optional: true),
        SchemaProperty(
          'wallets',
          RealmPropertyType.object,
          linkTarget: 'WalletRealm',
          collectionType: RealmCollectionType.list,
        ),
        SchemaProperty(
          'currentWalletId',
          RealmPropertyType.string,
          optional: true,
        ),
        SchemaProperty('updatedAt', RealmPropertyType.int, optional: true),
        SchemaProperty('walletIndex', RealmPropertyType.int, optional: true),
        SchemaProperty('walletName', RealmPropertyType.string, optional: true),
        SchemaProperty('walletType', RealmPropertyType.int),
        SchemaProperty('encryptCore', RealmPropertyType.string, optional: true),
        SchemaProperty('hadBackup', RealmPropertyType.bool),
        SchemaProperty('totalAmountUsd', RealmPropertyType.double),
        SchemaProperty('derivationIndex', RealmPropertyType.int),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
