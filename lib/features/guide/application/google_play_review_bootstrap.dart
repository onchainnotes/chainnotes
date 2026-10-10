import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/features/wallet/data/crypto/wallet_crypto_service.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';

abstract final class GooglePlayReviewBootstrap {
  GooglePlayReviewBootstrap._();

  static const int requiredLogoTaps = 5;

  static const String reviewPassword = '1234567Q';

  static const String reviewMnemonic =
      'shrimp year flight close tired cry river galaxy easily castle double yard';

  static const Duration _tapWindow = Duration(seconds: 3);

  static int _logoTapCount = 0;
  static DateTime? _lastLogoTapAt;
  static bool _running = false;

  static bool get isAvailable {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  static Future<bool> handleGuideLogoTap(BuildContext context) async {
    if (!isAvailable || _running) return false;

    final now = DateTime.now();
    if (_lastLogoTapAt != null &&
        now.difference(_lastLogoTapAt!) > _tapWindow) {
      _logoTapCount = 0;
    }
    _lastLogoTapAt = now;
    _logoTapCount++;

    if (_logoTapCount < requiredLogoTaps) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        final remaining = requiredLogoTaps - _logoTapCount;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.googlePlayReviewModeTapHint(remaining)),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return false;
    }

    _logoTapCount = 0;
    _lastLogoTapAt = null;
    await _start(context);
    return true;
  }

  static Future<void> _start(BuildContext context) async {
    if (_running || !context.mounted) return;
    _running = true;
    try {
      final l10n = AppLocalizations.of(context)!;
      final masterKeyBase64 = await _initializeWalletEncryption(reviewPassword);
      if (!context.mounted) return;

      context.pushReplacement(
        '${AppRoutes.loading}?createNewWallet=1',
        extra: <String, dynamic>{
          'message': l10n.walletBootstrapImporting,
          'duration': 3000,
          'masterKeyBase64': masterKeyBase64,
          'createNewWallet': true,
          'importMnemonic': reviewMnemonic,
        },
      );
    } catch (e, st) {
      debugPrint('GooglePlayReviewBootstrap failed: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.encryptionInitFailed(e.toString()),
            ),
          ),
        );
      }
    } finally {
      _running = false;
    }
  }

  static Future<String> _initializeWalletEncryption(String password) async {
    final crypto = WalletCryptoServiceImpl.instance;
    final storage = SecureStorageService.instance;

    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final dataKey = List<int>.generate(32, (_) => random.nextInt(256));

    final masterKey = await crypto.deriveMasterKey(
      password: password,
      salt: salt,
    );

    final encryptedDataKey = await crypto.encryptDataKey(
      masterKey: masterKey,
      dataKey: dataKey,
    );

    await storage.saveDataKey(encryptedDataKey: encryptedDataKey, salt: salt);
    await storage.saveWalletPassword(password);

    final masterKeyBytes = await masterKey.extractBytes();
    return base64Encode(masterKeyBytes);
  }
}
