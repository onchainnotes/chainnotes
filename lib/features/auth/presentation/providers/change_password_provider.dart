import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chain_notes/features/wallet/data/crypto/wallet_crypto_service.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';

part 'change_password_provider.g.dart';

enum PasswordStrength { weak, medium, strong }

class ChangePasswordState {
  const ChangePasswordState({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.showOldPassword,
    required this.showNewPassword,
    required this.showConfirmPassword,
    required this.isSubmitting,
  });

  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  final bool showOldPassword;
  final bool showNewPassword;
  final bool showConfirmPassword;
  final bool isSubmitting;

  PasswordStrength get strength => _computeStrength(newPassword);

  ChangePasswordState copyWith({
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
    bool? showOldPassword,
    bool? showNewPassword,
    bool? showConfirmPassword,
    bool? isSubmitting,
  }) {
    return ChangePasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      showOldPassword: showOldPassword ?? this.showOldPassword,
      showNewPassword: showNewPassword ?? this.showNewPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  static const initial = ChangePasswordState(
    oldPassword: '',
    newPassword: '',
    confirmPassword: '',
    showOldPassword: false,
    showNewPassword: false,
    showConfirmPassword: false,
    isSubmitting: false,
  );
}

enum ChangePasswordSubmitKind {
  success,
  mismatch,
  sameAsOld,
  invalidLength,
  missingKey,
  failed,
}

class ChangePasswordSubmitResult {
  const ChangePasswordSubmitResult._(this.ok, this.kind);
  final bool ok;
  final ChangePasswordSubmitKind kind;

  static const success =
      ChangePasswordSubmitResult._(true, ChangePasswordSubmitKind.success);
  static const mismatch =
      ChangePasswordSubmitResult._(false, ChangePasswordSubmitKind.mismatch);
  static const sameAsOld =
      ChangePasswordSubmitResult._(false, ChangePasswordSubmitKind.sameAsOld);
  static const invalidLength =
      ChangePasswordSubmitResult._(false, ChangePasswordSubmitKind.invalidLength);
  static const missingKey =
      ChangePasswordSubmitResult._(false, ChangePasswordSubmitKind.missingKey);
  static const failed =
      ChangePasswordSubmitResult._(false, ChangePasswordSubmitKind.failed);
}

@riverpod
class ChangePasswordController extends _$ChangePasswordController {
  @override
  ChangePasswordState build() => ChangePasswordState.initial;

  void setOldPassword(String v) => state = state.copyWith(oldPassword: v);
  void setNewPassword(String v) => state = state.copyWith(newPassword: v);
  void setConfirmPassword(String v) =>
      state = state.copyWith(confirmPassword: v);

  void toggleShowOld() =>
      state = state.copyWith(showOldPassword: !state.showOldPassword);
  void toggleShowNew() =>
      state = state.copyWith(showNewPassword: !state.showNewPassword);
  void toggleShowConfirm() =>
      state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);

  void reset() => state = ChangePasswordState.initial;

  Future<ChangePasswordSubmitResult> submit() async {
    if (state.isSubmitting) return ChangePasswordSubmitResult.failed;

    final oldPwd = state.oldPassword;
    final newPwd = state.newPassword;
    final confirm = state.confirmPassword;

    if (newPwd != confirm) return ChangePasswordSubmitResult.mismatch;
    if (oldPwd == newPwd) return ChangePasswordSubmitResult.sameAsOld;
    if (newPwd.length < 6 || newPwd.length > 32) {
      return ChangePasswordSubmitResult.invalidLength;
    }

    state = state.copyWith(isSubmitting: true);
    final storage = SecureStorageService.instance;
    final crypto = WalletCryptoServiceImpl.instance;
    try {
      final encryptedDataKey = await storage.getEncryptedDataKey();
      final salt = await storage.getDataKeySalt();
      if (encryptedDataKey == null || salt == null) {
        return ChangePasswordSubmitResult.missingKey;
      }

      final masterKey = await crypto.deriveMasterKey(
        password: oldPwd,
        salt: salt,
      );
      final dataKey = await crypto.decryptDataKey(
        masterKey: masterKey,
        encryptedDataKey: encryptedDataKey,
      );

      final newSalt = List<int>.generate(
        16,
        (_) => Random.secure().nextInt(256),
      );
      final newMasterKey = await crypto.deriveMasterKey(
        password: newPwd,
        salt: newSalt,
      );
      final newEncryptedDataKey = await crypto.encryptDataKey(
        masterKey: newMasterKey,
        dataKey: dataKey,
      );
      await storage.saveDataKey(
        encryptedDataKey: newEncryptedDataKey,
        salt: newSalt,
      );
      await storage.saveWalletPassword(newPwd);

      return ChangePasswordSubmitResult.success;
    } catch (_) {
      return ChangePasswordSubmitResult.failed;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

PasswordStrength _computeStrength(String pwd) {
  if (pwd.isEmpty) return PasswordStrength.weak;
  var s = 0;
  if (pwd.length >= 6) s++;
  if (pwd.length >= 8) s++;
  if (pwd.length >= 12) s++;
  if (RegExp(r'[a-z]').hasMatch(pwd) && RegExp(r'[A-Z]').hasMatch(pwd)) s++;
  if (RegExp(r'\d').hasMatch(pwd)) s++;
  if (RegExp(r'[^a-zA-Z0-9]').hasMatch(pwd)) s++;
  if (s <= 2) return PasswordStrength.weak;
  if (s <= 4) return PasswordStrength.medium;
  return PasswordStrength.strong;
}

