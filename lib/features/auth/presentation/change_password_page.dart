import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/auth/presentation/providers/change_password_provider.dart';

import 'package:chain_notes/generated/l10n/app_localizations.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(() {
      ref
          .read(changePasswordControllerProvider.notifier)
          .setOldPassword(_oldPasswordController.text);
    });
    _newPasswordController.addListener(() {
      ref
          .read(changePasswordControllerProvider.notifier)
          .setNewPassword(_newPasswordController.text);
    });
    _confirmPasswordController.addListener(() {
      ref
          .read(changePasswordControllerProvider.notifier)
          .setConfirmPassword(_confirmPasswordController.text);
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  static ({String text, Color color}) _strengthInfo(
    AppLocalizations l10n,
    PasswordStrength s,
  ) {
    switch (s) {
      case PasswordStrength.weak:
        return (text: l10n.passwordStrengthWeak, color: const Color(0xFFdc2626));
      case PasswordStrength.medium:
        return (
          text: l10n.passwordStrengthMedium,
          color: const Color(0xFFca8a04),
        );
      case PasswordStrength.strong:
        return (
          text: l10n.passwordStrengthStrong,
          color: const Color(0xFF16a34a),
        );
    }
  }

  static String _submitMessage(AppLocalizations l10n, ChangePasswordSubmitKind k) {
    switch (k) {
      case ChangePasswordSubmitKind.success:
        return l10n.passwordChangeSuccess;
      case ChangePasswordSubmitKind.mismatch:
        return l10n.passwordMismatch;
      case ChangePasswordSubmitKind.sameAsOld:
        return l10n.changePasswordSameAsOld;
      case ChangePasswordSubmitKind.invalidLength:
        return l10n.changePasswordLength632;
      case ChangePasswordSubmitKind.missingKey:
        return l10n.walletNoSavedKey;
      case ChangePasswordSubmitKind.failed:
        return l10n.changePasswordWrongOrFailed;
    }
  }

  List<({bool Function(String) test, String text})> _passwordRules(
    AppLocalizations l10n,
  ) {
    return [
      (
        test: (p) => p.length >= 6 && p.length <= 32,
        text: l10n.changePasswordRuleLength,
      ),
      (
        test: (p) =>
            RegExp(r'[a-z]').hasMatch(p) && RegExp(r'[A-Z]').hasMatch(p),
        text: l10n.changePasswordRuleCase,
      ),
      (
        test: (p) => RegExp(r'\d').hasMatch(p),
        text: l10n.changePasswordRuleDigit,
      ),
    ];
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final result =
        await ref.read(changePasswordControllerProvider.notifier).submit();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_submitMessage(l10n, result.kind))),
    );
    if (!result.ok) return;

    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    ref.read(changePasswordControllerProvider.notifier).reset();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _onBack();
  }

  void _onBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    return Scaffold(
      backgroundColor: brand.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: theme.brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: theme.brightness == Brightness.dark
                  ? Brightness.dark
                  : Brightness.light,
              systemStatusBarContrastEnforced: false,
            ),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: SafeArea(
                bottom: false,
                child: PageHeaderWithBack(
                  onBack: _onBack,
                  title: l10n.changePasswordPageTitle,
                  subtitle: l10n.changePasswordPageSubtitle,
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  children: [
                    _buildSecurityNotice(theme, l10n),
                    const SizedBox(height: 16),
                    _buildPasswordCard(theme, l10n),
                    const SizedBox(height: 16),
                    _buildRulesCard(theme, l10n),
                    const SizedBox(height: 24),
                    _buildActions(theme, l10n),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNotice(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark
        ? Color.alphaBlend(
            const Color(0xFF2563eb).withValues(alpha: 0.14),
            scheme.surfaceContainerHighest,
          )
        : const Color(0xFFeff6ff);
    final borderColor =
        isDark ? scheme.outlineVariant : const Color(0xFF93c5fd);
    final circleColor = isDark
        ? Color.alphaBlend(
            const Color(0xFFbfdbfe).withValues(alpha: 0.35),
            scheme.surfaceContainerHighest,
          )
        : const Color(0xFFbfdbfe);
    final titleColor =
        isDark ? scheme.onSurface : const Color(0xFF1e3a8a);
    final bodyColor = isDark ? scheme.primary : const Color(0xFF1d4ed8);

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.shield_rounded,
                color: Color(0xFF2563eb),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.changePasswordSecurityHintTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.changePasswordSecurityHintBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bodyColor,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordCard(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final ui = ref.watch(changePasswordControllerProvider);
    final strengthInfo = _strengthInfo(l10n, ui.strength);
    return Card(
      elevation: 0,
      color: isDark ? scheme.surfaceContainerHighest : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? scheme.outlineVariant : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPasswordField(
              theme,
              l10n,
              controller: _oldPasswordController,
              label: l10n.changePasswordOldLabel,
              hint: l10n.changePasswordOldHint,
              showPassword: ui.showOldPassword,
              onToggle: () => ref
                  .read(changePasswordControllerProvider.notifier)
                  .toggleShowOld(),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return l10n.validatorOldPasswordRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              theme,
              l10n,
              controller: _newPasswordController,
              label: l10n.changePasswordNewLabel,
              hint: l10n.changePasswordNewHint,
              showPassword: ui.showNewPassword,
              onToggle: () => ref
                  .read(changePasswordControllerProvider.notifier)
                  .toggleShowNew(),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return l10n.validatorNewPasswordRequired;
                }
                if (v.length < 6) return l10n.validatorNewPasswordMin6;
                if (v.length > 32) return l10n.validatorNewPasswordMax32;
                return null;
              },
            ),
            if (ui.newPassword.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    l10n.changePasswordStrengthLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? scheme.onSurfaceVariant
                          : const Color(0xFF6b7280),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: strengthInfo.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      strengthInfo.text,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: strengthInfo.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(3, (i) {
                  final level = i + 1;
                  final filled =
                      (ui.strength == PasswordStrength.weak && level == 1) ||
                      (ui.strength == PasswordStrength.medium && level <= 2) ||
                      (ui.strength == PasswordStrength.strong && level <= 3);
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: filled
                            ? strengthInfo.color
                            : (isDark
                                ? scheme.outlineVariant
                                : Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ],
            const SizedBox(height: 16),
            _buildPasswordField(
              theme,
              l10n,
              controller: _confirmPasswordController,
              label: l10n.changePasswordConfirmLabel,
              hint: l10n.changePasswordConfirmHint,
              showPassword: ui.showConfirmPassword,
              onToggle: () => ref
                  .read(changePasswordControllerProvider.notifier)
                  .toggleShowConfirm(),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return l10n.validatorConfirmRequired;
                }
                if (v != _newPasswordController.text) {
                  return l10n.validatorConfirmMismatch;
                }
                return null;
              },
            ),
            if (_confirmPasswordController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    _newPasswordController.text ==
                            _confirmPasswordController.text
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    size: 18,
                    color:
                        _newPasswordController.text ==
                            _confirmPasswordController.text
                        ? const Color(0xFF16a34a)
                        : const Color(0xFFdc2626),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _newPasswordController.text ==
                            _confirmPasswordController.text
                        ? l10n.changePasswordMatchOk
                        : l10n.changePasswordMatchBad,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          _newPasswordController.text ==
                              _confirmPasswordController.text
                          ? const Color(0xFF16a34a)
                          : const Color(0xFFdc2626),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    ThemeData theme,
    AppLocalizations l10n, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool showPassword,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final ui = ref.watch(changePasswordControllerProvider);
    const iconGrey = Color(0xFF9ca3af);
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      validator: validator,
      enabled: !ui.isSubmitting,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: isDark,
        fillColor: isDark ? scheme.surface : null,
        prefixIcon: const Icon(
          Icons.lock_outline,
          size: 20,
          color: iconGrey,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
            color: iconGrey,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: isDark
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: scheme.outlineVariant),
              )
            : null,
        focusedBorder: isDark
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: scheme.primary, width: 2),
              )
            : null,
        isDense: true,
      ),
    );
  }

  Widget _buildRulesCard(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final newPwd = ref.watch(changePasswordControllerProvider).newPassword;
    final rules = _passwordRules(l10n);
    final cardColor = isDark
        ? Color.alphaBlend(
            const Color(0xFFfde047).withValues(alpha: 0.12),
            scheme.surfaceContainerHighest,
          )
        : const Color(0xFFfffbeb).withValues(alpha: 0.6);
    final borderColor =
        isDark ? scheme.outlineVariant : const Color(0xFFfde047);
    final titleColor =
        isDark ? scheme.onSurface : const Color(0xFF92400e);

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: Color(0xFFca8a04),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.changePasswordRulesTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...rules.map((rule) {
              final passed = rule.test(newPwd);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      passed
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      size: 18,
                      color: passed
                          ? const Color(0xFF16a34a)
                          : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      rule.text,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: passed
                            ? (isDark
                                ? const Color(0xFF86efac)
                                : const Color(0xFF166534))
                            : (isDark
                                ? scheme.onSurfaceVariant
                                : const Color(0xFF6b7280)),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(ThemeData theme, AppLocalizations l10n) {
    final ui = ref.watch(changePasswordControllerProvider);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: ui.isSubmitting
                ? null
                : () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      context.pop();
                    }
                  },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.cancel),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: ui.isSubmitting ? null : _handleSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: ui.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.changePasswordSubmit,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
