import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/app/theme/app_design_tokens.dart';
import 'package:chain_notes/features/auth/application/create_wallet_password_form_provider.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/wallet/data/crypto/wallet_crypto_service.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';

class CreateWalletPasswordPage extends ConsumerStatefulWidget {
  const CreateWalletPasswordPage({
    super.key,
    this.onComplete,
    this.onBack,
    this.resetPasswordOnly = false,
    this.importMnemonic,
    this.importPrivateKey,
  });

  final void Function(String password)? onComplete;
  final VoidCallback? onBack;

  final bool resetPasswordOnly;

  final String? importMnemonic;

  final String? importPrivateKey;

  @override
  ConsumerState<CreateWalletPasswordPage> createState() =>
      _CreateWalletPasswordPageState();
}

class _CreateWalletPasswordPageState
    extends ConsumerState<CreateWalletPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSubmitting = false;

  void _onPasswordFieldChanged() {
    ref
        .read(createWalletPasswordFormProvider.notifier)
        .syncPasswordStrength(_passwordController.text);
    ref.read(createWalletPasswordFormProvider.notifier).onFieldsChanged();
  }

  void _onConfirmFieldChanged() {
    ref.read(createWalletPasswordFormProvider.notifier).onFieldsChanged();
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordFieldChanged);
    _confirmPasswordController.addListener(_onConfirmFieldChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordFieldChanged);
    _confirmPasswordController.removeListener(_onConfirmFieldChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Map<String, bool> get _validations {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    return {
      'length': password.length >= 6 && password.length <= 32,
      'match': password == confirmPassword && confirmPassword.isNotEmpty,
      'hasNumber': RegExp(r'\d').hasMatch(password),
      'hasLetter': RegExp(r'[a-zA-Z]').hasMatch(password),
    };
  }

  bool get _allValid => _validations.values.every((v) => v);

  Future<void> _handleSubmit() async {
    final form = ref.read(createWalletPasswordFormProvider.notifier);
    if (!ref.read(createWalletPasswordFormProvider).touched) {
      form.forceTouched();
    }

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final l10n = AppLocalizations.of(context)!;

    if (password.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordMinLength)));
      return;
    }

    if (password.length > 32) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordMaxLength32)));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordMismatch)));
      return;
    }

    if (!_allValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordMeetAllRequirements)));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final masterKey = await _initializeWalletEncryption(password);

      if (!mounted) return;

      if (widget.resetPasswordOnly) {
        await clearPasswordVerifyLockAndAttempts();
        if (!mounted) return;
        context.pop();
        return;
      }

      final masterKeyBytes = await masterKey.extractBytes();
      final masterKeyBase64 = base64Encode(masterKeyBytes);

      if (mounted) {
        final isMnemonicImport =
            widget.importMnemonic != null &&
            widget.importMnemonic!.trim().isNotEmpty;
        final isPrivateKeyImport =
            widget.importPrivateKey != null &&
            widget.importPrivateKey!.trim().isNotEmpty;
        final isImport = isMnemonicImport || isPrivateKeyImport;
        context.pushReplacement(
          '${AppRoutes.loading}?createNewWallet=1',
          extra: <String, dynamic>{
            'message': isImport
                ? l10n.walletBootstrapImporting
                : l10n.walletBootstrapInitializing,
            'duration': 3000,
            'masterKeyBase64': masterKeyBase64,
            'createNewWallet': true,
            if (isMnemonicImport)
              'importMnemonic': widget.importMnemonic!.trim(),
            if (isPrivateKeyImport)
              'importPrivateKey': widget.importPrivateKey!.trim(),
            'onBack': () {
              if (widget.onComplete != null) {
                widget.onComplete!(password);
              } else {
                context.go(AppRoutes.guide);
              }
            },
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.encryptionInitFailed(e.toString()))),
      );
    }
  }

  Widget _balanceStyleSubmitProgressIndicator({required Color color}) {
    return SizedBox(
      width: 11,
      height: 11,
      child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
    );
  }

  Future<SecretKey> _initializeWalletEncryption(String password) async {
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

    return masterKey;
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      context.pop();
    }
  }

  static const List<Color> _lightPageGradientColors = [
    Color(0xFFf0fdf4),
    Color(0xFFf0fdfa),
    Color(0xFFecfdf5),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final form = ref.watch(createWalletPasswordFormProvider);
    final validations = _validations;
    final touched = form.touched;
    final isDark = theme.brightness == Brightness.dark;

    final lightTitleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: const Color(0xFF111827),
    );
    final lightSubtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: const Color(0xFF4b5563),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _lightPageGradientColors,
                  stops: [0.0, 0.5, 1.0],
                ),
          color: isDark ? scheme.surface : null,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? null
                      : LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFf0fdf4).withValues(alpha: 0.95),
                            const Color(0xFFf0fdfa).withValues(alpha: 0.95),
                            Colors.transparent,
                          ],
                        ),
                ),
                child: Column(
                  children: [
                    PageHeaderWithBack(
                      onBack: _handleBack,
                      title: l10n.createWalletPasswordPageTitle,
                      subtitle: l10n.createWalletPasswordSubtitle,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      backBackgroundColor: isDark
                          ? scheme.surfaceContainerHighest
                          : Colors.white.withValues(alpha: 0.6),
                      backIconColor: isDark ? scheme.onSurface : null,
                      titleStyle: isDark
                          ? theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.onSurface,
                            )
                          : lightTitleStyle,
                      subtitleStyle: isDark
                          ? theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            )
                          : lightSubtitleStyle,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildSecurityNotice(theme, scheme, l10n, isDark),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPasswordCard(
                        theme,
                        scheme,
                        l10n,
                        form,
                        validations,
                        touched,
                        isDark,
                      ),
                      const SizedBox(height: 16),
                      _buildWarningCard(theme, scheme, l10n, isDark),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: (_allValid || !touched)
                            ? _handleSubmit
                            : null,
                        style: ElevatedButton.styleFrom(

                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: isDark
                              ? scheme.surfaceContainerHighest
                              : const Color(0xFF059669).withValues(alpha: 0.5),
                          disabledForegroundColor: isDark
                              ? scheme.onSurface.withValues(alpha: 0.38)
                              : Colors.white.withValues(alpha: 0.9),
                        ),
                        child: _isSubmitting
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _balanceStyleSubmitProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.resetPasswordOnly
                                        ? l10n.createWalletPasswordSubmitReset
                                        : l10n.createWalletPasswordSubmitCreate,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    size: 20,
                                    color: (_allValid || !touched)
                                        ? Colors.white
                                        : (isDark
                                              ? scheme.onSurface.withValues(
                                                  alpha: 0.38,
                                                )
                                              : Colors.white.withValues(
                                                  alpha: 0.9,
                                                )),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.resetPasswordOnly
                                        ? l10n.createWalletPasswordSubmitReset
                                        : l10n.createWalletPasswordSubmitCreate,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: (_allValid || !touched)
                                              ? Colors.white
                                              : (isDark
                                                    ? scheme.onSurface
                                                          .withValues(
                                                            alpha: 0.38,
                                                          )
                                                    : Colors.white.withValues(
                                                        alpha: 0.9,
                                                      )),
                                        ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.createWalletPasswordFooterAck,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? scheme.onSurfaceVariant
                              : const Color(0xFF6b7280),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityNotice(
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final borderColor = isDark
        ? scheme.outlineVariant
        : const Color(0xFF86efac);
    final titleColor = isDark ? scheme.onSurface : const Color(0xFF111827);
    final bodyColor = isDark
        ? scheme.onSurfaceVariant
        : const Color(0xFF4b5563);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : const LinearGradient(
                colors: [Color(0xFFf0fdf4), Color(0xFFf0fdfa)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.6)
            : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF059669),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.shield_rounded,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.createWalletPasswordWhyTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.createWalletPasswordWhyBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: bodyColor,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard(
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
    CreateWalletPasswordFormState form,
    Map<String, bool> validations,
    bool touched,
    bool isDark,
  ) {
    final cardBorder = isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb);

    return Card(
      elevation: 0,
      color: isDark ? scheme.surfaceContainerLow : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cardBorder, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPasswordField(
              theme,
              scheme,
              controller: _passwordController,
              label: l10n.walletPasswordFieldLabel,
              hint: l10n.walletPasswordFieldHint,
              showPassword: form.showPassword,
              onToggleVisibility: () => ref
                  .read(createWalletPasswordFormProvider.notifier)
                  .toggleShowPassword(),
              onChanged: _onPasswordFieldChanged,
              icon: Icons.lock_rounded,
              isDark: isDark,
            ),
            if (_passwordController.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildPasswordStrengthIndicator(
                theme,
                scheme,
                l10n,
                form.strength,
                isDark,
              ),
            ],
            const SizedBox(height: 20),
            _buildPasswordField(
              theme,
              scheme,
              controller: _confirmPasswordController,
              label: l10n.walletConfirmPasswordFieldLabel,
              hint: l10n.walletConfirmPasswordFieldHint,
              showPassword: form.showConfirmPassword,
              onToggleVisibility: () => ref
                  .read(createWalletPasswordFormProvider.notifier)
                  .toggleShowConfirmPassword(),
              onChanged: _onConfirmFieldChanged,
              icon: Icons.key_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            _buildValidationList(
              theme,
              scheme,
              validations,
              l10n,
              touched,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard(
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final bg = isDark
        ? Color.alphaBlend(
            Colors.amber.withValues(alpha: 0.12),
            scheme.surfaceContainerHighest,
          )
        : const Color(0xFFfefce8);
    final border = isDark
        ? Colors.amber.withValues(alpha: 0.45)
        : const Color(0xFFfde047);
    final iconFg = isDark ? Colors.amber.shade400 : const Color(0xFFca8a04);
    final titleFg = isDark ? Colors.amber.shade100 : const Color(0xFF854d0e);
    final bodyFg = isDark ? Colors.amber.shade200 : const Color(0xFF854d0e);

    return Card(
      elevation: 0,
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, size: 16, color: iconFg),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.walletPasswordImportantNotice,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: titleFg,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ..._buildWarningList(theme, bodyFg, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    ThemeData theme,
    ColorScheme scheme, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool showPassword,
    required VoidCallback onToggleVisibility,
    required VoidCallback onChanged,
    required IconData icon,
    required bool isDark,
  }) {
    final borderColor = isDark
        ? scheme.outlineVariant
        : AppDesignTokens.lightCardSubtleBorder;
    final focusedBorder = isDark ? scheme.primary : const Color(0xFF14b8a6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF14b8a6)),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !showPassword,
          maxLength: 32,
          onChanged: (_) => onChanged(),
          style: TextStyle(color: scheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            counterText: '',
            suffixIcon: IconButton(
              icon: Icon(
                showPassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: 20,
                color: Colors.grey[400],
              ),
              onPressed: onToggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: focusedBorder, width: 2),
            ),
            filled: isDark,
            fillColor: isDark ? scheme.surfaceContainerHighest : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator(
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
    CreateWalletPasswordStrength strength,
    bool isDark,
  ) {
    final config = {
      CreateWalletPasswordStrength.weak: {
        'color': const Color(0xFFef4444),
        'textColor': isDark ? const Color(0xFFfca5a5) : const Color(0xFFdc2626),
        'label': l10n.passwordStrengthWeak,
        'width': 0.33,
      },
      CreateWalletPasswordStrength.medium: {
        'color': const Color(0xFFeab308),
        'textColor': isDark ? const Color(0xFFfde047) : const Color(0xFFca8a04),
        'label': l10n.passwordStrengthMedium,
        'width': 0.67,
      },
      CreateWalletPasswordStrength.strong: {
        'color': const Color(0xFF22c55e),
        'textColor': isDark ? const Color(0xFF86efac) : const Color(0xFF16a34a),
        'label': l10n.passwordStrengthStrong,
        'width': 1.0,
      },
    }[strength]!;
    final trackColor = isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb);
    final labelMuted = isDark
        ? scheme.onSurfaceVariant
        : const Color(0xFF4b5563);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.changePasswordStrengthLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: labelMuted,
                fontSize: 11,
              ),
            ),
            Text(
              config['label'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: config['textColor'] as Color,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            widthFactor: config['width'] as double,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: config['color'] as Color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationList(
    ThemeData theme,
    ColorScheme scheme,
    Map<String, bool> validations,
    AppLocalizations l10n,
    bool touched,
    bool isDark,
  ) {
    final headerColor = isDark ? scheme.onSurface : const Color(0xFF374151);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.walletPasswordRulesHeader,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: headerColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        _ValidationItem(
          valid: validations['length']!,
          touched: touched,
          text: l10n.walletPasswordRuleLength632,
          isDark: isDark,
          scheme: scheme,
        ),
        const SizedBox(height: 6),
        _ValidationItem(
          valid: validations['hasLetter']!,
          touched: touched,
          text: l10n.walletPasswordRuleLetter,
          isDark: isDark,
          scheme: scheme,
        ),
        const SizedBox(height: 6),
        _ValidationItem(
          valid: validations['hasNumber']!,
          touched: touched,
          text: l10n.walletPasswordRuleNumberRecommended,
          isDark: isDark,
          scheme: scheme,
        ),
        const SizedBox(height: 6),
        _ValidationItem(
          valid: validations['match']!,
          touched: touched && _confirmPasswordController.text.isNotEmpty,
          text: l10n.walletPasswordRuleMatch,
          isDark: isDark,
          scheme: scheme,
        ),
      ],
    );
  }

  List<Widget> _buildWarningList(
    ThemeData theme,
    Color bodyFg,
    AppLocalizations l10n,
  ) {
    return l10n.walletPasswordWarnBullets
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map((line) {
          final item = line.startsWith('• ') ? line.substring(2) : line;
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: bodyFg,
                    fontSize: 11,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bodyFg,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        })
        .toList();
  }
}

class _ValidationItem extends StatelessWidget {
  const _ValidationItem({
    required this.valid,
    required this.touched,
    required this.text,
    required this.isDark,
    required this.scheme,
  });

  final bool valid;
  final bool touched;
  final String text;
  final bool isDark;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    late Color bgColor;
    late Color textColor;
    late Widget icon;

    if (valid) {
      bgColor = isDark
          ? Color.alphaBlend(
              const Color(0xFF22c55e).withValues(alpha: 0.28),
              scheme.surfaceContainerHighest,
            )
          : const Color(0xFFdcfce7);
      textColor = isDark ? const Color(0xFFbbf7d0) : const Color(0xFF166534);
      icon = Icon(Icons.check_rounded, size: 12, color: textColor);
    } else if (touched) {
      bgColor = isDark
          ? Color.alphaBlend(
              scheme.error.withValues(alpha: 0.35),
              scheme.surfaceContainerHighest,
            )
          : const Color(0xFFfee2e2);
      textColor = isDark ? const Color(0xFFfca5a5) : const Color(0xFFdc2626);
      icon = Icon(Icons.close_rounded, size: 12, color: textColor);
    } else {
      bgColor = isDark
          ? scheme.surfaceContainerHighest
          : const Color(0xFFf3f4f6);
      textColor = isDark ? scheme.onSurfaceVariant : const Color(0xFF9ca3af);
      icon = Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
      );
    }

    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: icon,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontSize: 11,
              fontWeight: valid ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
