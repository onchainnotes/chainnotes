import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_wallet_password_form_provider.g.dart';

enum CreateWalletPasswordStrength { weak, medium, strong }

@immutable
class CreateWalletPasswordFormState {
  const CreateWalletPasswordFormState({
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.touched = false,
    this.strength = CreateWalletPasswordStrength.weak,
    this.revision = 0,
  });

  final bool showPassword;
  final bool showConfirmPassword;
  final bool touched;
  final CreateWalletPasswordStrength strength;
  final int revision;

  CreateWalletPasswordFormState copyWith({
    bool? showPassword,
    bool? showConfirmPassword,
    bool? touched,
    CreateWalletPasswordStrength? strength,
    int? revision,
  }) {
    return CreateWalletPasswordFormState(
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      touched: touched ?? this.touched,
      strength: strength ?? this.strength,
      revision: revision ?? this.revision,
    );
  }
}

CreateWalletPasswordStrength _computeStrength(String password) {
  if (password.isEmpty) return CreateWalletPasswordStrength.weak;
  int score = 0;
  if (password.length >= 8) score++;
  if (password.length >= 12) score++;
  if (RegExp(r'\d').hasMatch(password)) score++;
  if (RegExp(r'[a-z]').hasMatch(password)) score++;
  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (RegExp(r'[^a-zA-Z0-9]').hasMatch(password)) score++;
  if (score <= 2) return CreateWalletPasswordStrength.weak;
  if (score <= 4) return CreateWalletPasswordStrength.medium;
  return CreateWalletPasswordStrength.strong;
}

@riverpod
class CreateWalletPasswordForm extends _$CreateWalletPasswordForm {
  @override
  CreateWalletPasswordFormState build() => const CreateWalletPasswordFormState();

  void toggleShowPassword() {
    state = state.copyWith(
      showPassword: !state.showPassword,
      revision: state.revision + 1,
    );
  }

  void toggleShowConfirmPassword() {
    state = state.copyWith(
      showConfirmPassword: !state.showConfirmPassword,
      revision: state.revision + 1,
    );
  }

  void syncPasswordStrength(String password) {
    state = state.copyWith(
      strength: _computeStrength(password),
      revision: state.revision + 1,
    );
  }

  void onFieldsChanged() {
    if (!state.touched) {
      state = state.copyWith(touched: true, revision: state.revision + 1);
    } else {
      state = state.copyWith(revision: state.revision + 1);
    }
  }

  void forceTouched() {
    state = state.copyWith(touched: true, revision: state.revision + 1);
  }
}
