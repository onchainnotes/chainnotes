import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chain_notes/features/wallet/data/crypto/encrypted_data.dart';
import 'package:chain_notes/shared/services/cryptography_service.dart';

/// - iOS: Keychain

class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  Future<void> saveWalletPassword(String password) async {
    final hashedPassword = await CryptographyService.instance.hashPassword(
      password,
    );
    await write(_kWalletPasswordHashKey, hashedPassword);
    await setWalletPasswordSet(true);
  }

  Future<bool> verifyWalletPassword(String password) async {
    final hashedPassword = await getWalletPasswordHash();
    if (hashedPassword == null) return false;
    return await CryptographyService.instance.verifyPassword(
      password,
      hashedPassword,
    );
  }

  @Deprecated('Use saveWalletPassword instead')
  Future<void> saveWalletPasswordHash(String passwordHash) async {
    await write(_kWalletPasswordHashKey, passwordHash);
  }

  Future<String?> getWalletPasswordHash() async {
    return await read(_kWalletPasswordHashKey);
  }

  Future<void> deleteWalletPasswordHash() async {
    await delete(_kWalletPasswordHashKey);
    await setWalletPasswordSet(false);
  }

  Future<bool> hasWalletPassword() async {
    return await containsKey(_kWalletPasswordHashKey);
  }

  Future<void> setWalletPasswordSet(bool value) async {
    await write(_kWalletPasswordSetKey, value.toString());
  }

  Future<bool> isWalletPasswordSet() async {
    final value = await read(_kWalletPasswordSetKey);
    return value == 'true';
  }

  Future<void> saveDataKey({
    required EncryptedData encryptedDataKey,
    required List<int> salt,
    Map<String, dynamic>? kdfParams,
  }) async {
    final data = {
      'encryptedDataKey': encryptedDataKey.toJsonString(),
      'salt': base64Encode(salt),
      'kdfParams':
          kdfParams ??
          {
            'algorithm': 'PBKDF2-HMAC-SHA256',
            'iterations': 100000,
            'keyLength': 32,
          },
    };
    await write(_kDataKeyStorageKey, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getDataKeyStorage() async {
    final jsonString = await read(_kDataKeyStorageKey);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<EncryptedData?> getEncryptedDataKey() async {
    final storage = await getDataKeyStorage();
    if (storage == null) return null;
    final encryptedDataKeyStr = storage['encryptedDataKey'] as String;
    return EncryptedData.fromJsonString(encryptedDataKeyStr);
  }

  Future<List<int>?> getDataKeySalt() async {
    final storage = await getDataKeyStorage();
    if (storage == null) return null;
    final saltBase64 = storage['salt'] as String;
    return base64Decode(saltBase64);
  }

  Future<Map<String, dynamic>?> getKdfParams() async {
    final storage = await getDataKeyStorage();
    if (storage == null) return null;
    return storage['kdfParams'] as Map<String, dynamic>?;
  }

  Future<bool> hasDataKey() async {
    return await containsKey(_kDataKeyStorageKey);
  }

  Future<void> deleteDataKey() async {
    await delete(_kDataKeyStorageKey);
  }
}

const String _kWalletPasswordHashKey = 'wallet-password-hash';

const String _kWalletPasswordSetKey = 'wallet-password-set';

const String _kDataKeyStorageKey = 'wallet-data-key-storage';
