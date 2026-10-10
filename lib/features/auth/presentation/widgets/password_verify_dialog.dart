import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/features/wallet/data/crypto/wallet_crypto_service.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';

enum PasswordVerifyPurpose {
  standard,
  exportMnemonic,
  exportPrivateKey,
  importWallet,
  backupMnemonic,
  createWallet,
  deleteWallet,
  mintNft,
}

String _descriptionForPurpose(
  AppLocalizations l,
  PasswordVerifyPurpose purpose,
) {
  switch (purpose) {
    case PasswordVerifyPurpose.standard:
      return l.passwordVerifyDescription;
    case PasswordVerifyPurpose.exportMnemonic:
      return l.passwordVerifyDescExportMnemonic;
    case PasswordVerifyPurpose.exportPrivateKey:
      return l.passwordVerifyDescExportPrivateKey;
    case PasswordVerifyPurpose.importWallet:
      return l.passwordVerifyDescImportWallet;
    case PasswordVerifyPurpose.backupMnemonic:
      return l.passwordVerifyDescBackupMnemonic;
    case PasswordVerifyPurpose.createWallet:
      return l.passwordVerifyDescCreateWallet;
    case PasswordVerifyPurpose.deleteWallet:
      return l.passwordVerifyDescDeleteWallet;
    case PasswordVerifyPurpose.mintNft:
      return l.passwordVerifyDescMintNft;
  }
}

class PasswordVerifyDialog extends StatefulWidget {
  const PasswordVerifyDialog({
    super.key,
    this.purpose = PasswordVerifyPurpose.standard,
    this.warningMessage,
    this.onSuccess,
  });

  final PasswordVerifyPurpose purpose;
  final String? warningMessage;
  final VoidCallback? onSuccess;

  @override
  State<PasswordVerifyDialog> createState() => _PasswordVerifyDialogState();
}

class _PasswordVerifyDialogState extends State<PasswordVerifyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isVerifying = false;
  bool _isPasswordValid = false;
  int _attempts = 0;
  static const int _maxAttempts = 5;
  static const int _lockoutHours = 2;
  DateTime? _lockoutUntil;
  String? _errorMessage;
  bool _showResetPasswordEntry = false;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _loadAttemptsAndLockout();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkShowResetEntry());
  }

  Future<void> _checkShowResetEntry() async {
    final hasWallet = WalletUtils.hasWalletInRealm();
    if (mounted) {
      setState(() => _showResetPasswordEntry = !hasWallet);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadAttemptsAndLockout() async {
    final storage = SecureStorageService.instance;

    final attemptsStr = await storage.read(_kPasswordAttemptsKey);
    if (attemptsStr != null) {
      setState(() {
        _attempts = int.tryParse(attemptsStr) ?? 0;
      });
    }

    final lockoutUntilStr = await storage.read(_kPasswordLockoutKey);
    if (lockoutUntilStr != null) {
      final lockoutUntil = DateTime.fromMillisecondsSinceEpoch(
        int.parse(lockoutUntilStr),
      );
      if (lockoutUntil.isAfter(DateTime.now())) {
        setState(() {
          _lockoutUntil = lockoutUntil;
        });
      } else {
        await storage.delete(_kPasswordLockoutKey);
        await storage.delete(_kPasswordAttemptsKey);
        setState(() {
          _lockoutUntil = null;
          _attempts = 0;
        });
      }
    }
  }

  Future<void> _handleVerify() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = _l10n;

    if (_lockoutUntil != null && _lockoutUntil!.isAfter(DateTime.now())) {
      final remainingMinutes = _lockoutUntil!
          .difference(DateTime.now())
          .inMinutes;
      setState(() {
        _errorMessage = l10n.passwordVerifyLockoutMinutes(remainingMinutes);
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final password = _passwordController.text;
    final storage = SecureStorageService.instance;
    final crypto = WalletCryptoServiceImpl.instance;

    try {
      final encryptedDataKey = await storage.getEncryptedDataKey();
      final salt = await storage.getDataKeySalt();

      if (encryptedDataKey == null || salt == null) {
        setState(() {
          _isVerifying = false;
          _errorMessage = l10n.passwordVerifyNoEncryptedData;
        });
        return;
      }

      final masterKey = await crypto.deriveMasterKey(
        password: password,
        salt: salt,
      );

      try {
        await crypto.decryptDataKey(
          masterKey: masterKey,
          encryptedDataKey: encryptedDataKey,
        );

        await storage.delete(_kPasswordAttemptsKey);
        await storage.delete(_kPasswordLockoutKey);

        final masterKeyBytes = await masterKey.extractBytes();
        final masterKeyBase64 = base64Encode(masterKeyBytes);

        if (mounted) {
          Navigator.of(context).pop(masterKeyBase64);
          widget.onSuccess?.call();
        }
      } catch (e) {
        await _handleFailedAttempt();
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _errorMessage = l10n.passwordVerifyFailedWithError(e.toString());
      });
    }
  }

  Future<void> _handleFailedAttempt() async {
    final storage = SecureStorageService.instance;
    final newAttempts = _attempts + 1;
    final l10n = _l10n;

    await storage.write(_kPasswordAttemptsKey, newAttempts.toString());
    setState(() {
      _attempts = newAttempts;
      _isVerifying = false;
      _passwordController.clear();
    });

    if (newAttempts >= _maxAttempts) {
      final lockoutUntil = DateTime.now().add(
        const Duration(hours: _lockoutHours),
      );
      await storage.write(
        _kPasswordLockoutKey,
        lockoutUntil.millisecondsSinceEpoch.toString(),
      );
      setState(() {
        _lockoutUntil = lockoutUntil;
        _errorMessage = l10n.passwordVerifyLockoutHours(_lockoutHours);
      });
    } else {
      setState(() {
        _errorMessage =
            l10n.passwordVerifyWrongWithCount(newAttempts, _maxAttempts);
      });
    }
  }

  void _handleClose() {
    _passwordController.clear();
    Navigator.of(context).pop();
  }

  String? _formatRemainingLockout(AppLocalizations l10n) {
    if (_lockoutUntil == null) return null;
    final now = DateTime.now();
    if (_lockoutUntil!.isBefore(now)) return null;

    final difference = _lockoutUntil!.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return l10n.passwordVerifyDurationHoursMinutes(hours, minutes);
    }
    return l10n.passwordVerifyDurationMinutes(minutes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final remainingTime = _formatRemainingLockout(l10n);
    final isLocked = remainingTime != null;
    final description =
        _descriptionForPurpose(l10n, widget.purpose);

    final warnBg = isDark
        ? Color.alphaBlend(
            Colors.amber.withValues(alpha: 0.14),
            scheme.surfaceContainerHighest,
          )
        : Colors.amber.shade50;
    final warnBorder =
        isDark ? Colors.amber.withValues(alpha: 0.42) : Colors.amber.shade200;
    final warnIcon = isDark ? Colors.amber.shade400 : Colors.amber.shade700;
    final warnText = isDark ? Colors.amber.shade100 : Colors.amber.shade900;

    final tipsBg = isDark
        ? Color.alphaBlend(
            Colors.blue.withValues(alpha: 0.14),
            scheme.surfaceContainerHighest,
          )
        : Colors.blue.shade50;
    final tipsBorder = isDark
        ? Colors.blue.withValues(alpha: 0.45)
        : Colors.blue.shade200;
    final tipsIconBg =
        isDark ? Colors.blue.withValues(alpha: 0.22) : Colors.blue.shade100;
    final tipsIconColor = isDark ? Colors.blue.shade300 : Colors.blue;
    final tipsTitleColor = isDark ? Colors.blue.shade300 : Colors.blue;
    final tipsBodyStyle = isDark
        ? TextStyle(fontSize: 12, color: Colors.blue.shade200.withValues(alpha: 0.95))
        : TextStyle(fontSize: 12, color: Colors.blue.shade700);

    final lockBg = isDark ? scheme.errorContainer : Colors.red.shade50;
    final lockBorder = isDark
        ? scheme.error.withValues(alpha: 0.35)
        : Colors.red.shade200;
    final lockIconColor = scheme.error;
    final lockTextColor = isDark ? scheme.onErrorContainer : Colors.red;

    return AlertDialog(
      backgroundColor:
          isDark ? scheme.surfaceContainerHigh : theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade100, Colors.teal.shade100],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shield, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.passwordVerifyTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                description,
                style: isDark
                    ? theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: scheme.onSurfaceVariant,
                      )
                    : const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              if (widget.warningMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: warnBg,
                    border: Border.all(color: warnBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: warnIcon,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.warningMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: warnText,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              PasswordInputField(
                controller: _passwordController,
                labelText: l10n.passwordVerifyWalletPasswordLabel,
                hintText: l10n.passwordVerifyWalletPasswordHint,
                enabled: !_isVerifying && !isLocked,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.validatorWalletPasswordRequired;
                  }
                  if (value.length < 6) {
                    return l10n.passwordMinLength;
                  }
                  if (value.length > 32) {
                    return l10n.passwordMaxLength32;
                  }
                  return null;
                },
                onChanged: (value) {
                  final valid = value.isNotEmpty &&
                      value.length >= 6 &&
                      value.length <= 32;

                  setState(() {
                    _isPasswordValid = valid;
                    if (_errorMessage != null) {
                      _errorMessage = null;
                    }
                  });
                },
              ),

              if (_attempts > 0 && !isLocked) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.cancel,
                      size: 14,
                      color: isDark ? scheme.error : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        l10n.passwordVerifyAttemptsBanner(
                          _attempts,
                          _maxAttempts - _attempts,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? scheme.error : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              if (isLocked) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: lockBg,
                    border: Border.all(color: lockBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_clock, size: 16, color: lockIconColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.passwordVerifyLockBanner(remainingTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: lockTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (_errorMessage != null && !isLocked) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: isDark ? scheme.error : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],

              if (_showResetPasswordEntry) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _isVerifying || isLocked
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          GoRouter.of(context).push(
                            AppRoutes.createWalletPassword,
                            extra: <String, dynamic>{'resetPasswordOnly': true},
                          );
                        },
                  style: TextButton.styleFrom(foregroundColor: scheme.primary),
                  child: Text(l10n.passwordVerifyForgotGoReset),
                ),
              ],

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tipsBg,
                  border: Border.all(color: tipsBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: tipsIconBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            size: 14,
                            color: tipsIconColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.passwordVerifySecurityTipsTitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: tipsTitleColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.passwordVerifySecurityTipsBody(_maxAttempts),
                      style: tipsBodyStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isVerifying || isLocked ? null : _handleClose,
          style: TextButton.styleFrom(foregroundColor: scheme.primary),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: (_isVerifying || isLocked || !_isPasswordValid)
              ? null
              : _handleVerify,
          child: _isVerifying
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: scheme.onPrimary,
                  ),
                )
              : Text(l10n.confirm),
        ),
      ],
    );
  }
}

const String _kPasswordAttemptsKey = 'password-verify-attempts';

const String _kPasswordLockoutKey = 'password-verify-lockout';

Future<void> clearPasswordVerifyLockAndAttempts() async {
  final s = SecureStorageService.instance;
  await s.delete(_kPasswordAttemptsKey);
  await s.delete(_kPasswordLockoutKey);
}
