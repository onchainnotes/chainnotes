import 'package:flutter/foundation.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:chain_notes/features/wallet/data/crypto/wallet_crypto_service.dart';
import 'package:chain_notes/shared/preference_keys.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:chain_notes/common/datasource/chain_datas.dart';
import 'package:chain_notes/features/home/data/datasource/realm/note_realm_manager.dart';
import 'package:chain_notes/features/wallet/data/datasource/realm/wallet_realm_manager.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain_type.dart';
import 'package:chain_notes/features/wallet/domain/entity/import_wallet_result.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class WalletUtils {
  WalletUtils._();

  static WalletRealmManager? _realmManager;

  static WalletRealmManager _getRealmManager() {
    _realmManager ??= WalletRealmManager();
    return _realmManager!;
  }

  static WalletRealmManager getRealmManager() {
    return _getRealmManager();
  }

  static String? _preferredCurrentWalletId(List<Wallet> wallets) {
    for (final w in wallets) {
      if (w.chainType == ChainType.evm) return w.id;
    }
    return wallets.isNotEmpty ? wallets.first.id : null;
  }

  static bool hasWalletInRealm() {
    final list = _getRealmManager().loadAllAggregatedWallets();
    return list.isNotEmpty;
  }

  static String nextDefaultCreatedWalletName(AppLocalizations l10n) {
    final count = _getRealmManager().loadAllAggregatedWallets().length;
    if (count == 0) return l10n.walletDefaultCreatedNameFirst;
    return l10n.walletDefaultCreatedNameNumbered(count + 1);
  }

  static String nextDefaultPrivateKeyWalletName(AppLocalizations l10n) {
    final count = _getRealmManager()
        .loadAllAggregatedWallets()
        .where((agg) => agg.walletType == WalletType.importedPrivateKey)
        .length;
    if (count == 0) return l10n.walletDefaultPrivateKeyNameFirst;
    return l10n.walletDefaultPrivateKeyNameNumbered(count + 1);
  }

  static void deleteWalletByDbId(int dbId) {
    try {
      NoteRealmManager.instance.deleteNotesByWalletId(dbId);
    } catch (_) {}
    _getRealmManager().deleteAggregatedWalletByDbId(dbId);
  }

  static bool _addrsEqual(String a, String b) {
    if (a == b) return true;
    if (a.startsWith('0x') && b.startsWith('0x')) {
      return a.toLowerCase() == b.toLowerCase();
    }
    return false;
  }

  static void deleteWalletByAddress(String address) {
    final manager = _getRealmManager();
    final list = manager.loadAllAggregatedWallets();
    for (final agg in list) {
      final found = agg.wallets.any((w) {
        if (_addrsEqual(w.address, address)) return true;
        return w.protocolAccounts.any((p) => _addrsEqual(p.address, address));
      });
      if (found && agg.id != null) {
        deleteWalletByDbId(agg.id!);
        return;
      }
    }
  }

  static void deleteAllWallets() {
    try {
      NoteRealmManager.instance.deleteAll();
    } catch (_) {}
    final manager = _getRealmManager();
    final list = manager.loadAllAggregatedWallets();
    for (final agg in list) {
      if (agg.id != null) {
        manager.deleteAggregatedWalletByDbId(agg.id!);
      }
    }
  }

  static Future<void> clearAllWalletData() async {

    try {
      await NoteRealmManager.instance.open();
      NoteRealmManager.instance.deleteAll();
    } catch (_) {}

    final manager = _getRealmManager();
    final list = manager.loadAllAggregatedWallets();
    for (final agg in list) {
      if (agg.id != null) {
        manager.deleteAggregatedWalletByDbId(agg.id!);
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PreferenceKeys.wallets);
    await prefs.remove(PreferenceKeys.currentWallet);
    await prefs.remove(PreferenceKeys.walletPrivateKey);
    await prefs.remove(PreferenceKeys.currentChainId);
    await prefs.remove(PreferenceKeys.walletMnemonic);
    await prefs.remove(PreferenceKeys.onboardingCompleted);
    await prefs.remove(PreferenceKeys.boundEmail);

    final storage = SecureStorageService.instance;
    await storage.deleteDataKey();
    await storage.deleteWalletPasswordHash();
  }

  static Future<AggregatedWallet?> generateWallet({
    required List<int> dataKey,
    required String walletName,
    bool saveToRealm = true,
  }) async {
    try {

      final hdWallet = HDWallet(strength: 128);
      final mnemonic = hdWallet.mnemonic();

      final crypto = WalletCryptoServiceImpl.instance;
      final encryptedMnemonic = await crypto.encryptMnemonic(
        dataKey: dataKey,
        mnemonic: mnemonic,
      );
      final encryptCore = encryptedMnemonic.toJsonString();

      final chainDataMap = ChainDatas.demoChainInfoList as Map<String, dynamic>;
      final dataMap = chainDataMap['data'] as Map<String, dynamic>;
      final chainList = dataMap['list'] as List<dynamic>;

      final protocols = <Protocol>[];
      final wallets = <Wallet>[];
      final now = DateTime.now().millisecondsSinceEpoch;

      final walletsByChainType = <String, List<Protocol>>{};

      for (final chainInfo in chainList) {
        final walletCoreCoinType = chainInfo['wallet_core_coin_type'] as int;
        final chainType = chainInfo['chain_type'] as String;
        final chainId = chainInfo['chain_id'] as int;

        try {

          final address = hdWallet.getAddressForCoin(walletCoreCoinType);

          final privateKey = hdWallet.getKeyForCoin(walletCoreCoinType);

          final curve = _getCurveForCoinType(walletCoreCoinType);

          final publicKey = privateKey.getPublicKey(curve);
          final publicKeyBytes = publicKey.data();
          final publicKeyHex = publicKeyBytes
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join();

          final derivationPathPtr = TWCoinType.TWCoinTypeDerivationPath(
            walletCoreCoinType,
          );
          final derivationPath = TWStringImpl.toDartString(derivationPathPtr);
          TWStringImpl.delete(derivationPathPtr);

          final protocol = Protocol(
            publicKeyHex: publicKeyHex,
            address: address,
            derivationPath: derivationPath,
            walletCoreCoinType: walletCoreCoinType,
            protocolType: chainId,
          );

          if (!walletsByChainType.containsKey(chainType)) {
            walletsByChainType[chainType] = [];
          }
          walletsByChainType[chainType]!.add(protocol);

          protocols.add(protocol);
        } catch (e) {

          continue;
        }
      }

      for (final entry in walletsByChainType.entries) {
        final chainTypeStr = entry.key;
        final chainProtocols = entry.value;

        final chainType = _getChainTypeFromString(chainTypeStr);

        final primaryProtocol = chainProtocols.first;

        final walletId =
            'wallet_${primaryProtocol.address.substring(0, 10)}_$now';

        final wallet = Wallet(
          id: walletId,
          address: primaryProtocol.address,
          type: WalletType.created,
          chainType: chainType,
          createdAt: now,
          walletCoreCoinType: primaryProtocol.walletCoreCoinType,
          defaultPublicKey: primaryProtocol.publicKeyHex,
          defaultAddress: primaryProtocol.address,
          derivationPath: primaryProtocol.derivationPath,
          protocolAccounts: chainProtocols,
        );

        wallets.add(wallet);
      }

      if (wallets.isEmpty) {
        debugPrint(
          'WalletUtils.generateWallet: 未发现任何链钱包（可能 TrustWalletCore '
          '未正确加载，或 ChainDatas 与 coin 派生全部失败；iOS 需同时放入 '
          'WalletCore.xcframework 与 SwiftProtobuf.xcframework）',
        );
        hdWallet.delete();
        return null;
      }

      final aggregatedWallet = AggregatedWallet(
        wallets: wallets,
        currentWalletId: _preferredCurrentWalletId(wallets),
        walletType: WalletType.created,
        walletName: walletName,
        encryptCore: encryptCore,

        derivationIndex: 0,
      );

      if (saveToRealm) {
        try {
          final realmManager = _getRealmManager();
          realmManager.saveAggregatedWallet(aggregatedWallet);
        } catch (e) {

          rethrow;
        }
      }

      hdWallet.delete();

      return aggregatedWallet;
    } catch (e, st) {
      debugPrint('WalletUtils.generateWallet failed: $e');
      debugPrint('$st');
      return null;
    }
  }

  static Set<String> _collectAllWalletAddresses() {
    final addrs = <String>{};
    final list = _getRealmManager().loadAllAggregatedWallets();
    for (final agg in list) {
      for (final w in agg.wallets) {
        addrs.add(w.address.toLowerCase());
        for (final p in w.protocolAccounts) {
          addrs.add(p.address.toLowerCase());
        }
      }
    }
    return addrs;
  }

  static bool _addrOverlaps(Set<String> existing, String addr) {
    final lower = addr.toLowerCase();
    if (addr.startsWith('0x')) return existing.contains(lower);
    return existing.contains(addr);
  }

  static Future<ImportWalletResult> importWallet({
    required String mnemonic,
    required List<int> dataKey,
    required String walletName,
    bool saveToRealm = true,
  }) async {
    final normalizedMnemonic = _normalizeMnemonicBip39(mnemonic);
    if (!Mnemonic.isValid(normalizedMnemonic)) {
      return const ImportWalletInvalidMnemonic();
    }
    try {
      final hdWallet = HDWallet.createWithMnemonic(normalizedMnemonic);
      try {
        final existingAddrs = _collectAllWalletAddresses();
        final chainDataMap =
            ChainDatas.demoChainInfoList as Map<String, dynamic>;
        final dataMap = chainDataMap['data'] as Map<String, dynamic>;
        final chainList = dataMap['list'] as List<dynamic>;

        for (final chainInfo in chainList) {
          final walletCoreCoinType = chainInfo['wallet_core_coin_type'] as int;
          try {
            final address = hdWallet.getAddressForCoin(walletCoreCoinType);
            if (_addrOverlaps(existingAddrs, address)) {
              return const ImportWalletDuplicate();
            }
          } catch (_) {
            continue;
          }
        }
        final crypto = WalletCryptoServiceImpl.instance;
        final encryptedMnemonic = await crypto.encryptMnemonic(
          dataKey: dataKey,
          mnemonic: normalizedMnemonic,
        );
        final encryptCore = encryptedMnemonic.toJsonString();

        final now = DateTime.now().millisecondsSinceEpoch;
        final walletsByChainType = <String, List<Protocol>>{};

        for (final chainInfo in chainList) {
          final walletCoreCoinType = chainInfo['wallet_core_coin_type'] as int;
          final chainType = chainInfo['chain_type'] as String;
          final chainId = chainInfo['chain_id'] as int;
          try {
            final address = hdWallet.getAddressForCoin(walletCoreCoinType);
            final privateKey = hdWallet.getKeyForCoin(walletCoreCoinType);
            final curve = _getCurveForCoinType(walletCoreCoinType);
            final publicKey = privateKey.getPublicKey(curve);
            final publicKeyBytes = publicKey.data();
            final publicKeyHex = publicKeyBytes
                .map((b) => b.toRadixString(16).padLeft(2, '0'))
                .join();
            final derivationPathPtr = TWCoinType.TWCoinTypeDerivationPath(
              walletCoreCoinType,
            );
            final derivationPath = TWStringImpl.toDartString(derivationPathPtr);
            TWStringImpl.delete(derivationPathPtr);

            final protocol = Protocol(
              publicKeyHex: publicKeyHex,
              address: address,
              derivationPath: derivationPath,
              walletCoreCoinType: walletCoreCoinType,
              protocolType: chainId,
            );
            if (!walletsByChainType.containsKey(chainType)) {
              walletsByChainType[chainType] = [];
            }
            walletsByChainType[chainType]!.add(protocol);
          } catch (_) {
            continue;
          }
        }

        final wallets = <Wallet>[];
        for (final entry in walletsByChainType.entries) {
          final chainTypeStr = entry.key;
          final chainProtocols = entry.value;
          final chainType = _getChainTypeFromString(chainTypeStr);
          final primaryProtocol = chainProtocols.first;
          final walletId =
              'wallet_${primaryProtocol.address.substring(0, 10)}_$now';

          wallets.add(
            Wallet(
              id: walletId,
              address: primaryProtocol.address,
              type: WalletType.importedMnemonic,
              chainType: chainType,
              createdAt: now,
              updatedAt: now,
              walletCoreCoinType: primaryProtocol.walletCoreCoinType,
              defaultPublicKey: primaryProtocol.publicKeyHex,
              defaultAddress: primaryProtocol.address,
              derivationPath: primaryProtocol.derivationPath,
              protocolAccounts: chainProtocols,
            ),
          );
        }

        final aggregatedWallet = AggregatedWallet(
          wallets: wallets,
          currentWalletId: _preferredCurrentWalletId(wallets),
          walletType: WalletType.importedMnemonic,
          walletName: walletName,
          encryptCore: encryptCore,
          hadBackup: true,
          derivationIndex: 0,
        );

        if (saveToRealm) {
          final realmManager = _getRealmManager();
          realmManager.saveAggregatedWallet(aggregatedWallet);
        }

        return ImportWalletSuccess(aggregatedWallet);
      } finally {
        hdWallet.delete();
      }
    } catch (e) {
      return const ImportWalletInvalidMnemonic();
    }
  }

  static Future<ImportWalletResult> importPrivateKeyWallet({
    required String privateKeyHexInput,
    required List<int> dataKey,
    required String walletName,
    bool saveToRealm = true,
  }) async {
    FlutterTrustWalletCore.init();
    var hex = privateKeyHexInput.trim();
    if (hex.startsWith('0x')) hex = hex.substring(2);
    if (hex.length != 64) {
      return const ImportWalletInvalidPrivateKey();
    }
    final bytes = hexToBytes(hex);
    if (bytes.length != 32) {
      return const ImportWalletInvalidPrivateKey();
    }

    final evmAddress = getEvmAddressFromPrivateKey(privateKeyHexInput);
    if (evmAddress == null) {
      return const ImportWalletInvalidPrivateKey();
    }
    if (_addrOverlaps(_collectAllWalletAddresses(), evmAddress)) {
      return const ImportWalletDuplicate();
    }

    final crypto = WalletCryptoServiceImpl.instance;
    final encrypted = await crypto.encryptPrivateKeyHex(
      dataKey: dataKey,
      privateKeyHexNo0x: hex,
    );
    final encryptCore = encrypted.toJsonString();

    final chainDataMap = ChainDatas.demoChainInfoList as Map<String, dynamic>;
    final dataMap = chainDataMap['data'] as Map<String, dynamic>;
    final chainList = dataMap['list'] as List<dynamic>;
    var protocolType = 1;
    const walletCoreCoinType = TWCoinType.TWCoinTypeEthereum;
    for (final chainInfo in chainList) {
      if (chainInfo['wallet_core_coin_type'] as int == walletCoreCoinType) {
        protocolType = chainInfo['chain_id'] as int;
        break;
      }
    }

    final pk = PrivateKey.createWithData(Uint8List.fromList(bytes));
    try {
      final curve = _getCurveForCoinType(walletCoreCoinType);
      final publicKey = pk.getPublicKey(curve);
      final publicKeyBytes = publicKey.data();
      final publicKeyHex = publicKeyBytes
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
      final derivationPathPtr = TWCoinType.TWCoinTypeDerivationPath(
        walletCoreCoinType,
      );
      final derivationPath = TWStringImpl.toDartString(derivationPathPtr);
      TWStringImpl.delete(derivationPathPtr);

      final protocol = Protocol(
        publicKeyHex: publicKeyHex,
        address: evmAddress,
        derivationPath: derivationPath,
        walletCoreCoinType: walletCoreCoinType,
        protocolType: protocolType,
      );

      final now = DateTime.now().millisecondsSinceEpoch;
      final idPrefix = evmAddress.length >= 10
          ? evmAddress.substring(0, 10)
          : evmAddress;
      final walletId = 'wallet_${idPrefix}_$now';
      final wallet = Wallet(
        id: walletId,
        address: evmAddress,
        type: WalletType.importedPrivateKey,
        chainType: ChainType.evm,
        createdAt: now,
        updatedAt: now,
        walletCoreCoinType: walletCoreCoinType,
        defaultPublicKey: publicKeyHex,
        defaultAddress: evmAddress,
        derivationPath: derivationPath,
        protocolAccounts: [protocol],
      );

      final aggregatedWallet = AggregatedWallet(
        wallets: [wallet],
        currentWalletId: walletId,
        walletType: WalletType.importedPrivateKey,
        walletName: walletName,
        encryptCore: encryptCore,
        hadBackup: true,
        derivationIndex: 0,
      );

      if (saveToRealm) {
        _getRealmManager().saveAggregatedWallet(aggregatedWallet);
      }
      return ImportWalletSuccess(aggregatedWallet);
    } finally {
      pk.delete();
    }
  }

  static String? getEvmAddressFromPrivateKey(String privateKeyHex) {
    try {
      FlutterTrustWalletCore.init();
      var hex = privateKeyHex.trim();
      if (hex.startsWith('0x')) hex = hex.substring(2);
      if (hex.length != 64) return null;
      final bytes = hexToBytes(hex);
      if (bytes.length != 32) return null;
      final pk = PrivateKey.createWithData(Uint8List.fromList(bytes));
      try {
        final pubKey = pk.getPublicKey(TWCurve.TWCurveSECP256k1, false);
        try {
          final addr = AnyAddress.createWithPublicKey(
            pubKey,
            TWCoinType.TWCoinTypeEthereum,
          );
          try {
            return addr.description();
          } finally {
            addr.delete();
          }
        } finally {
          pubKey.delete();
        }
      } finally {
        pk.delete();
      }
    } catch (_) {
      return null;
    }
  }

  static List<int> hexToBytes(String hex) {
    final result = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      result.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return result;
  }

  static bool hasAddressInExistingWallets(String address) {
    final existing = _collectAllWalletAddresses();
    return _addrOverlaps(existing, address);
  }

  static int _getCurveForCoinType(int walletCoreCoinType) {

    if (walletCoreCoinType == TWCoinType.TWCoinTypeSolana) {
      return TWCurve.TWCurveED25519;
    } else {
      return TWCurve.TWCurveSECP256k1;
    }
  }

  static ChainType _getChainTypeFromString(String chainTypeStr) {
    if (chainTypeStr == 'Ethereum') {
      return ChainType.evm;
    } else if (chainTypeStr == 'Bitcoin') {
      return ChainType.btc;
    } else {
      return ChainType.other;
    }
  }

  static String _normalizeMnemonicBip39(String mnemonic) {
    if (mnemonic.isEmpty) return mnemonic;
    return unorm.nfkd(
      mnemonic.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' '),
    );
  }
}
