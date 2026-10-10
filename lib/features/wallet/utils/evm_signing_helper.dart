import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:chain_notes/features/wallet/data/crypto/encrypted_data.dart';
import 'package:chain_notes/features/wallet/data/crypto/wallet_crypto_service.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';

class EvmSigningHelper {
  EvmSigningHelper._();

  /// Trust Wallet Ethereum coin type
  static const int _evmCoinType = 60;

  static Future<List<int>?> _decryptDataKeyWithMasterKey(
    String masterKeyBase64,
  ) async {
    try {
      final crypto = WalletCryptoServiceImpl.instance;
      final storage = SecureStorageService.instance;
      final masterKeyBytes = base64Decode(masterKeyBase64);
      final masterKey = SecretKey(masterKeyBytes);
      final encryptedDataKey = await storage.getEncryptedDataKey();
      if (encryptedDataKey == null) return null;
      return crypto.decryptDataKey(
        masterKey: masterKey,
        encryptedDataKey: encryptedDataKey,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<String?> getDecryptedMnemonic({
    required String masterKeyBase64,
    required String? currentAddress,
    String? evmAddressHint,
  }) async {
    final addressesToTry = <String>{
      if (currentAddress != null && currentAddress.isNotEmpty) currentAddress,
      if (evmAddressHint != null && evmAddressHint.isNotEmpty) evmAddressHint,
    };
    if (addressesToTry.isEmpty) return null;

    try {
      final crypto = WalletCryptoServiceImpl.instance;
      final dataKey = await _decryptDataKeyWithMasterKey(masterKeyBase64);
      if (dataKey == null) {
        debugPrint('EvmSigningHelper: 未找到加密的 DataKey 或解密失败');
        return null;
      }

      final manager = WalletUtils.getRealmManager();
      final aggregatedList = manager.loadAllAggregatedWallets();
      if (aggregatedList.isEmpty) {
        debugPrint('EvmSigningHelper: Realm 中无聚合钱包');
        return null;
      }

      final matchingAggs = aggregatedList
          .where(
            (agg) =>
                _aggContainsAnyAddress(agg, addressesToTry) &&
                (agg.encryptCore != null && agg.encryptCore!.isNotEmpty) &&
                agg.walletType != WalletType.importedPrivateKey,
          )
          .toList();
      if (matchingAggs.isEmpty) {
        debugPrint('EvmSigningHelper: 未找到与 $addressesToTry 匹配且含助记词的钱包');
        return null;
      }

      Object? lastError;
      for (final targetAgg in matchingAggs) {
        try {
          final encryptedMnemonic =
              EncryptedData.fromJsonString(targetAgg.encryptCore!);
          final mnemonic = await crypto.decryptMnemonic(
            dataKey: dataKey,
            encryptedMnemonic: encryptedMnemonic,
          );
          return _normalizeMnemonicBip39(mnemonic);
        } catch (e) {
          lastError = e;
          debugPrint(
            'EvmSigningHelper: 该钱包助记词解密失败，尝试下一个: $e',
          );
        }
      }
      debugPrint(
        'EvmSigningHelper: 所有匹配钱包助记词解密均失败，最后错误: $lastError',
      );
      return null;
    } catch (e, st) {
      debugPrint('EvmSigningHelper getDecryptedMnemonic 异常: $e');
      debugPrint('堆栈: $st');
      return null;
    }
  }

  static Future<List<int>?> getEvmPrivateKey({
    required String masterKeyBase64,
    required String? currentAddress,
    String? evmAddressHint,
  }) async {
    FlutterTrustWalletCore.init();

    try {
      final addressesToTry = <String>{
        if (currentAddress != null && currentAddress.isNotEmpty) currentAddress,
        if (evmAddressHint != null && evmAddressHint.isNotEmpty) evmAddressHint,
      };
      if (addressesToTry.isEmpty) return null;

      final dataKey = await _decryptDataKeyWithMasterKey(masterKeyBase64);
      if (dataKey == null) return null;

      final crypto = WalletCryptoServiceImpl.instance;
      final aggregatedList =
          WalletUtils.getRealmManager().loadAllAggregatedWallets();
      for (final agg in aggregatedList) {
        if (agg.walletType != WalletType.importedPrivateKey) continue;
        if (agg.encryptCore == null || agg.encryptCore!.isEmpty) continue;
        if (!_aggContainsAnyAddress(agg, addressesToTry)) continue;
        try {
          final enc = EncryptedData.fromJsonString(agg.encryptCore!);
          var hex = await crypto.decryptPrivateKeyHex(
            dataKey: dataKey,
            encrypted: enc,
          );
          hex = hex.trim();
          if (hex.startsWith('0x')) hex = hex.substring(2);
          if (hex.length != 64) continue;
          return WalletUtils.hexToBytes(hex);
        } catch (e) {
          debugPrint('EvmSigningHelper: 私钥钱包 decrypt 失败: $e');
        }
      }

      final mnemonic = await getDecryptedMnemonic(
        masterKeyBase64: masterKeyBase64,
        currentAddress: currentAddress,
        evmAddressHint: evmAddressHint,
      );
      if (mnemonic == null || mnemonic.isEmpty) {
        return null;
      }

      final hdWallet = HDWallet.createWithMnemonic(mnemonic);
      try {
        final pk = hdWallet.getKeyForCoin(_evmCoinType);
        final bytes = pk.data();
        pk.delete();
        return bytes;
      } finally {
        hdWallet.delete();
      }
    } catch (e, st) {
      debugPrint('EvmSigningHelper 异常: $e');
      debugPrint('堆栈: $st');
      return null;
    }
  }

  static bool _addrEquals(String a, String b) {
    if (a == b) return true;
    if (a.startsWith('0x') && b.startsWith('0x')) {
      return a.toLowerCase() == b.toLowerCase();
    }
    return false;
  }

  static String _normalizeMnemonicBip39(String mnemonic) {
    if (mnemonic.isEmpty) return mnemonic;
    return unorm.nfkd(
      mnemonic.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' '),
    );
  }

  static bool _aggContainsAnyAddress(
    AggregatedWallet agg,
    Set<String> addresses,
  ) {
    for (final addr in addresses) {
      final rep = agg.currentWallet?.address ??
          (agg.wallets.isNotEmpty ? agg.wallets.first.address : null);
      if (rep != null && _addrEquals(rep, addr)) return true;
      for (final w in agg.wallets) {
        if (_addrEquals(w.address, addr)) return true;
        for (final p in w.protocolAccounts) {
          if (_addrEquals(p.address, addr)) return true;
        }
      }
    }
    return false;
  }
}
