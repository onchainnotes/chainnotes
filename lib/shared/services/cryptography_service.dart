import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' as crypto;

class CryptographyService {
  CryptographyService._();

  static final CryptographyService instance = CryptographyService._();

  Future<List<int>> sha256Hash(List<int> data) async {
    final algorithm = crypto.Sha256();
    final hash = await algorithm.hash(data);
    return hash.bytes;
  }

  Future<String> sha256HashHex(String data) async {
    final bytes = utf8.encode(data);
    final hash = await sha256Hash(bytes);
    return hash.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  Future<List<int>> sha512Hash(List<int> data) async {
    final algorithm = crypto.Sha512();
    final hash = await algorithm.hash(data);
    return hash.bytes;
  }

  Future<String> sha512HashHex(String data) async {
    final bytes = utf8.encode(data);
    final hash = await sha512Hash(bytes);
    return hash.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  Future<String> hashPassword(String password, {List<int>? salt}) async {

    final saltBytes = salt != null
        ? Uint8List.fromList(salt)
        : await generateRandomBytes(16);

    final algorithm = crypto.Argon2id(
      memory: 65536, // 64 MB (65536 * 1KB)
      parallelism: 4,
      iterations: 3,
      hashLength: 32,
    );

    final passwordKey = crypto.SecretKey(utf8.encode(password));
    final secretKey = await algorithm.deriveKey(
      secretKey: passwordKey,
      nonce: saltBytes,
    );

    final hashBytes = await secretKey.extractBytes();

    final saltBase64 = base64Encode(saltBytes);
    final hashBase64 = base64Encode(hashBytes);
    return '$saltBase64:$hashBase64';
  }

  Future<bool> verifyPassword(String password, String hashedPassword) async {
    try {
      final parts = hashedPassword.split(':');
      if (parts.length != 2) return false;

      final saltBase64 = parts[0];
      final hashBase64 = parts[1];

      final salt = base64Decode(saltBase64);
      final expectedHash = base64Decode(hashBase64);

      final computedHash = await hashPassword(password, salt: salt);
      final computedParts = computedHash.split(':');
      final computedHashBytes = base64Decode(computedParts[1]);

      if (computedHashBytes.length != expectedHash.length) return false;
      for (int i = 0; i < computedHashBytes.length; i++) {
        if (computedHashBytes[i] != expectedHash[i]) return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<crypto.SecretBox> aes256GcmEncrypt(
    List<int> data, {
    required crypto.SecretKey secretKey,
    List<int>? nonce,
  }) async {
    final algorithm = crypto.AesGcm.with256bits();
    final secretBox = await algorithm.encrypt(
      data,
      secretKey: secretKey,
      nonce: nonce != null ? Uint8List.fromList(nonce) : null,
    );
    return secretBox;
  }

  Future<List<int>> aes256GcmDecrypt(
    crypto.SecretBox secretBox,
    crypto.SecretKey secretKey,
  ) async {
    final algorithm = crypto.AesGcm.with256bits();
    final decrypted = await algorithm.decrypt(secretBox, secretKey: secretKey);
    return decrypted;
  }

  Future<crypto.SecretKey> deriveAesKeyFromPassword(
    String password, {
    List<int>? salt,
  }) async {

    final saltBytes = salt != null
        ? Uint8List.fromList(salt)
        : await generateRandomBytes(16);

    final algorithm = crypto.Pbkdf2(
      macAlgorithm: crypto.Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );

    final passwordKey = crypto.SecretKey(utf8.encode(password));
    final secretKey = await algorithm.deriveKey(
      secretKey: passwordKey,
      nonce: saltBytes,
    );

    return secretKey;
  }

  Future<crypto.SecretBox> chacha20Poly1305Encrypt(
    List<int> data, {
    required crypto.SecretKey secretKey,
    List<int>? nonce,
  }) async {
    final algorithm = crypto.Chacha20.poly1305Aead();
    final secretBox = await algorithm.encrypt(
      data,
      secretKey: secretKey,
      nonce: nonce != null ? Uint8List.fromList(nonce) : null,
    );
    return secretBox;
  }

  Future<List<int>> chacha20Poly1305Decrypt(
    crypto.SecretBox secretBox,
    crypto.SecretKey secretKey,
  ) async {
    final algorithm = crypto.Chacha20.poly1305Aead();
    final decrypted = await algorithm.decrypt(secretBox, secretKey: secretKey);
    return decrypted;
  }

  Future<crypto.SecretKey> generateAes256Key() async {
    final algorithm = crypto.AesGcm.with256bits();
    return await algorithm.newSecretKey();
  }

  Future<Uint8List> generateRandomBytes(int length) async {
    final rnd = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => rnd.nextInt(256)),
    );
  }

  Future<String> encryptString(String text, String password) async {

    final salt = await generateRandomBytes(16);

    final secretKey = await deriveAesKeyFromPassword(password, salt: salt);

    final secretBox = await aes256GcmEncrypt(
      utf8.encode(text),
      secretKey: secretKey,
    );

    final saltBase64 = base64Encode(salt);
    final nonceBase64 = base64Encode(secretBox.nonce);
    final ciphertextBase64 = base64Encode(secretBox.cipherText);
    final macBytes = secretBox.mac.bytes;
    final macBase64 = base64Encode(macBytes);

    return '$saltBase64:$nonceBase64:$ciphertextBase64:$macBase64';
  }

  Future<String> decryptString(String encryptedData, String password) async {
    try {
      final parts = encryptedData.split(':');
      if (parts.length != 4) {
        throw ArgumentError('Invalid encrypted data format');
      }

      final salt = base64Decode(parts[0]);
      final nonce = base64Decode(parts[1]);
      final ciphertext = base64Decode(parts[2]);
      final macBytes = base64Decode(parts[3]);

      final secretKey = await deriveAesKeyFromPassword(password, salt: salt);

      final mac = crypto.Mac(macBytes);
      final secretBox = crypto.SecretBox(ciphertext, nonce: nonce, mac: mac);

      final decrypted = await aes256GcmDecrypt(secretBox, secretKey);
      return utf8.decode(decrypted);
    } catch (e) {
      throw ArgumentError('Failed to decrypt: $e');
    }
  }
}
