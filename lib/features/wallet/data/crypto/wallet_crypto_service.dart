import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:chain_notes/features/wallet/data/crypto/encrypted_data.dart';

abstract class WalletCryptoService {

  Future<SecretKey> deriveMasterKey({
    required String password,
    required List<int> salt,
  });

  Future<EncryptedData> encryptDataKey({
    required SecretKey masterKey,
    required List<int> dataKey,
  });

  Future<List<int>> decryptDataKey({
    required SecretKey masterKey,
    required EncryptedData encryptedDataKey,
  });

  Future<EncryptedData> encryptMnemonic({
    required List<int> dataKey,
    required String mnemonic,
  });

  Future<String> decryptMnemonic({
    required List<int> dataKey,
    required EncryptedData encryptedMnemonic,
  });

  Future<EncryptedData> encryptPrivateKeyHex({
    required List<int> dataKey,
    required String privateKeyHexNo0x,
  });

  Future<String> decryptPrivateKeyHex({
    required List<int> dataKey,
    required EncryptedData encrypted,
  });
}

class WalletCryptoServiceImpl implements WalletCryptoService {
  WalletCryptoServiceImpl._();

  static final WalletCryptoServiceImpl instance = WalletCryptoServiceImpl._();

  static const int _pbkdf2Iterations = 100000;
  static const int _keyLength = 32;

  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: _pbkdf2Iterations,
    bits: _keyLength * 8,
  );

  final _aesGcm = AesGcm.with256bits();

  List<int> _randomBytes(int length) {
    final rnd = Random.secure();
    return List<int>.generate(length, (_) => rnd.nextInt(256));
  }

  @override
  Future<SecretKey> deriveMasterKey({
    required String password,
    required List<int> salt,
  }) async {
    return await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: Uint8List.fromList(salt),
    );
  }

  @override
  Future<EncryptedData> encryptDataKey({
    required SecretKey masterKey,
    required List<int> dataKey,
  }) async {
    final nonce = _randomBytes(12);

    final secretBox = await _aesGcm.encrypt(
      dataKey,
      secretKey: masterKey,
      nonce: Uint8List.fromList(nonce),
    );

    final macBytes = await secretBox.mac.bytes;

    return EncryptedData(
      cipherText: secretBox.cipherText,
      nonce: secretBox.nonce,
      mac: macBytes,
    );
  }

  @override
  Future<List<int>> decryptDataKey({
    required SecretKey masterKey,
    required EncryptedData encryptedDataKey,
  }) async {
    final box = SecretBox(
      encryptedDataKey.cipherText,
      nonce: Uint8List.fromList(encryptedDataKey.nonce),
      mac: Mac(encryptedDataKey.mac),
    );

    return await _aesGcm.decrypt(box, secretKey: masterKey);
  }

  @override
  Future<EncryptedData> encryptMnemonic({
    required List<int> dataKey,
    required String mnemonic,
  }) async {
    final nonce = _randomBytes(12);

    final secretBox = await _aesGcm.encrypt(
      utf8.encode(mnemonic),
      secretKey: SecretKey(dataKey),
      nonce: Uint8List.fromList(nonce),
    );

    final macBytes = await secretBox.mac.bytes;

    return EncryptedData(
      cipherText: secretBox.cipherText,
      nonce: secretBox.nonce,
      mac: macBytes,
    );
  }

  @override
  Future<String> decryptMnemonic({
    required List<int> dataKey,
    required EncryptedData encryptedMnemonic,
  }) async {
    final box = SecretBox(
      encryptedMnemonic.cipherText,
      nonce: Uint8List.fromList(encryptedMnemonic.nonce),
      mac: Mac(encryptedMnemonic.mac),
    );

    final bytes = await _aesGcm.decrypt(box, secretKey: SecretKey(dataKey));

    return utf8.decode(bytes);
  }

  @override
  Future<EncryptedData> encryptPrivateKeyHex({
    required List<int> dataKey,
    required String privateKeyHexNo0x,
  }) async {
    final nonce = _randomBytes(12);
    final secretBox = await _aesGcm.encrypt(
      utf8.encode(privateKeyHexNo0x),
      secretKey: SecretKey(dataKey),
      nonce: Uint8List.fromList(nonce),
    );
    final macBytes = await secretBox.mac.bytes;
    return EncryptedData(
      cipherText: secretBox.cipherText,
      nonce: secretBox.nonce,
      mac: macBytes,
    );
  }

  @override
  Future<String> decryptPrivateKeyHex({
    required List<int> dataKey,
    required EncryptedData encrypted,
  }) async {
    final box = SecretBox(
      encrypted.cipherText,
      nonce: Uint8List.fromList(encrypted.nonce),
      mac: Mac(encrypted.mac),
    );
    final bytes = await _aesGcm.decrypt(box, secretKey: SecretKey(dataKey));
    return utf8.decode(bytes);
  }
}
