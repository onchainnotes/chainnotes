import 'dart:math';
import 'package:chain_notes/features/wallet/data/crypto/encrypted_data.dart';
import 'package:chain_notes/features/wallet/data/crypto/wallet_crypto_service.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';

class WalletCryptoExample {
  final _crypto = WalletCryptoServiceImpl.instance;
  final _storage = SecureStorageService.instance;

  Future<void> initializeWalletEncryption({
    required String userPassword,
    required String mnemonic,
  }) async {

    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final dataKey = List<int>.generate(32, (_) => random.nextInt(256));

    final masterKey = await _crypto.deriveMasterKey(
      password: userPassword,
      salt: salt,
    );

    final encryptedDataKey = await _crypto.encryptDataKey(
      masterKey: masterKey,
      dataKey: dataKey,
    );

    await _storage.saveDataKey(encryptedDataKey: encryptedDataKey, salt: salt);

    final encryptedMnemonic = await _crypto.encryptMnemonic(
      dataKey: dataKey,
      mnemonic: mnemonic,
    );

    print('Encrypted mnemonic ready for storage');
  }

  Future<String> decryptWalletData({
    required String userPassword,
    required EncryptedData encryptedMnemonic,
  }) async {

    final salt = await _storage.getDataKeySalt();
    if (salt == null) {
      throw Exception('DataKey salt not found');
    }

    final masterKey = await _crypto.deriveMasterKey(
      password: userPassword,
      salt: salt,
    );

    final encryptedDataKey = await _storage.getEncryptedDataKey();
    if (encryptedDataKey == null) {
      throw Exception('Encrypted DataKey not found');
    }

    final dataKey = await _crypto.decryptDataKey(
      masterKey: masterKey,
      encryptedDataKey: encryptedDataKey,
    );

    final mnemonic = await _crypto.decryptMnemonic(
      dataKey: dataKey,
      encryptedMnemonic: encryptedMnemonic,
    );

    return mnemonic;
  }

  Future<bool> isWalletEncryptionInitialized() async {
    return await _storage.hasDataKey();
  }

  Future<void> clearWalletEncryption() async {
    await _storage.deleteDataKey();
  }
}
