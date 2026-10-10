import 'package:realm/realm.dart';

part 'wallet_realm_models.realm.dart';

@RealmModel()
class _ProtocolRealm {
  @PrimaryKey()
  late ObjectId id;
  late String publicKeyHex;
  late String address;
  late String derivationPath;
  late int walletCoreCoinType;
  late int protocolType;
}

@RealmModel()
class _WalletRealm {
  @PrimaryKey()
  late String id;
  late String address;
  late int type;
  String? name;
  late int chainType;
  late int createdAt;
  int? updatedAt;
  int? walletId;
  String? accountId;
  double totalAmountUsd = 0.0;
  int? walletCoreCoinType;
  String? defaultPublicKey;
  String? defaultAddress;
  String? derivationPath;
  List<_ProtocolRealm> protocolAccounts = [];
}

@RealmModel()
class _AggregatedWalletRealm {
  @PrimaryKey()
  late ObjectId id;

  int? dbId;
  List<_WalletRealm> wallets = [];
  String? currentWalletId;
  int? updatedAt;
  int? walletIndex;
  String? walletName;
  late int walletType;
  String? encryptCore;
  bool hadBackup = false;
  double totalAmountUsd = 0.0;
  int derivationIndex = 0;
}
