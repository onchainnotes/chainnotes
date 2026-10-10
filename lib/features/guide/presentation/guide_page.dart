import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/common/storage/preference_keys.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/guide/application/google_play_review_bootstrap.dart';
import 'package:chain_notes/features/guide/application/guide_page_provider.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool _kShowGuideCloudRestoreCards = false;

class GuidePage extends ConsumerStatefulWidget {
  const GuidePage({super.key});

  @override
  ConsumerState<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends ConsumerState<GuidePage> {
  GuidePageController get _guide => ref.read(guidePageControllerProvider.notifier);

  Future<void> _createWallet() async {
    final ui = ref.read(guidePageControllerProvider);
    if (ui.isCreating) return;
    _guide.setCreating(true);

    final storage = SecureStorageService.instance;
    final hasDataKey = await storage.hasDataKey();

    if (!mounted) {
      _guide.setCreating(false);
      return;
    }

    if (hasDataKey) {
      _guide.setCreating(false);
      final masterKeyBase64 = await _showPasswordVerifyDialog();
      if (masterKeyBase64 != null && mounted) {
        await _verifyPasswordAndDecrypt(masterKeyBase64);
      }
      return;
    }

    _guide.setCreating(false);
    final result = await context.push<String>(AppRoutes.createWalletPassword);
    if (result != null && mounted) {
      await _doCreateWallet(result);
    }
  }

  Future<String?> _showPasswordVerifyDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PasswordVerifyDialog(),
    );
  }

  Future<void> _verifyPasswordAndDecrypt(String? masterKeyBase64) async {
    if (masterKeyBase64 == null) return;

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      context.pushReplacement(
        AppRoutes.loading,
        extra: <String, dynamic>{
          'message': l10n.guideLoadingWalletMessage,
          'duration': 2000,
          'masterKeyBase64': masterKeyBase64,
          'createNewWallet': false,
        },
      );
    }
  }

  Future<void> _doCreateWallet(String password) async {
    if (!mounted) return;
    _guide.setCreating(true);

    final rng = math.Random();
    final addr =
        '0x${List.generate(40, (_) => rng.nextInt(16).toRadixString(16)).join()}';
    final words = [
      'abandon',
      'ability',
      'able',
      'about',
      'above',
      'absent',
      'absorb',
      'abstract',
      'absurd',
      'abuse',
      'access',
      'accident',
    ]..shuffle(rng);
    final mnemonic = words.take(12).join(' ');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.currentWallet, addr);
    await prefs.setString(PreferenceKeys.walletMnemonic, mnemonic);
    await prefs.setBool(PreferenceKeys.onboardingCompleted, true);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.newWalletCreateSuccess)));
    context.go(AppRoutes.home);
    _guide.setCreating(false);
  }

  void _goToImportWallet() {
    context.push(AppRoutes.wallet);
  }

  Future<void> _cloudRestore(String providerKey) async {
    if (kReleaseMode) return;
    final ui = ref.read(guidePageControllerProvider);
    if (ui.isRestoring) return;
    _guide.setRestoring(true);
    final l10n = AppLocalizations.of(context)!;
    final providerName = providerKey == 'icloud'
        ? l10n.guideProviderICloud
        : l10n.guideProviderGoogleDrive;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(content: Text(l10n.restoringFromProvider(providerName))),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final hasBackup = math.Random().nextDouble() > 0.5;
    if (hasBackup) {
      final rng = math.Random();
      final addr =
          '0x${List.generate(40, (_) => rng.nextInt(16).toRadixString(16)).join()}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PreferenceKeys.currentWallet, addr);
      await prefs.setBool(PreferenceKeys.onboardingCompleted, true);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(l10n.restoredFromProvider(providerName))),
      );
      context.go(AppRoutes.home);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(l10n.noBackupFoundProvider(providerName))),
      );
    }
    _guide.setRestoring(false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final ui = ref.watch(guidePageControllerProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFf0fdf4),
                    Color(0xFFf0fdfa),
                    Color(0xFFecfdf5),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
          color: isDark ? scheme.surface : null,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(theme, scheme, l10n, isDark),
                const SizedBox(height: 24),
                _buildSecurityNotice(theme, scheme, l10n, isDark),
                const SizedBox(height: 24),
                _buildOptionCards(theme, scheme, l10n, ui, isDark),
                const SizedBox(height: 24),
                _buildFooter(theme, scheme, l10n, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideLogo() {
    final logo = SizedBox(
      width: 96,
      height: 96,
      child: Image.asset(
        'assets/app_logo_pure.png',
        fit: BoxFit.contain,
      ),
    );
    if (!GooglePlayReviewBootstrap.isAvailable) return logo;
    return GestureDetector(
      onTap: () => GooglePlayReviewBootstrap.handleGuideLogoTap(context),
      child: logo,
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Column(
      children: [
        Center(
          child: _buildGuideLogo(),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.guideWelcomeTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? scheme.onSurface : const Color(0xFF111827),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.guideWelcomeSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSecurityNotice(
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : const LinearGradient(
                colors: [Color(0xFFf0fdf4), Color(0xFFf0fdfa)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.65)
            : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? scheme.outlineVariant : const Color(0xFF86efac),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF059669),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.shield_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.guideSecurityTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? scheme.onSurface : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.guideSecurityBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563),
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

  Widget _buildOptionCards(
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
    GuidePageUiState ui,
    bool isDark,
  ) {
    final cloudRestoreEnabled = !kReleaseMode;
    return Column(
      children: [
        _OptionCard(
          isDark: isDark,
          scheme: scheme,
          icon: Icons.auto_awesome,
          iconGradient: const [Color(0xFF22c55e), Color(0xFF14b8a6)],
          title: l10n.guideCreateWalletTitle,
          subtitle: l10n.guideCreateWalletSubtitle,
          badge: l10n.guideRecommendedNewUser,
          badgeIcon: Icons.auto_awesome,
          onTap: ui.isCreating ? null : _createWallet,
        ),
        const SizedBox(height: 12),
        _OptionCard(
          isDark: isDark,
          scheme: scheme,
          icon: Icons.download_rounded,
          iconGradient: const [Color(0xFF14b8a6), Color(0xFF06b6d4)],
          title: l10n.guideImportWalletTitle,
          subtitle: l10n.guideImportWalletSubtitle,
          tags: [l10n.guideTagMnemonic, l10n.guideTagPrivateKey],
          onTap: _goToImportWallet,
        ),
        if (_kShowGuideCloudRestoreCards) ...[
          const SizedBox(height: 12),
          _OptionCard(
            isDark: isDark,
            scheme: scheme,
            icon: Icons.cloud_rounded,
            iconGradient: const [Color(0xFF3b82f6), Color(0xFF6366f1)],
            title: l10n.guideICloudRestoreTitle,
            subtitle: l10n.guideICloudRestoreSubtitle,
            badge: l10n.guideBadgeIosOnly,
            badgeColor: const Color(0xFF2563eb),
            enabled: cloudRestoreEnabled,
            onTap: cloudRestoreEnabled && !ui.isRestoring
                ? () => _cloudRestore('icloud')
                : null,
          ),
          const SizedBox(height: 12),
          _OptionCard(
            isDark: isDark,
            scheme: scheme,
            icon: Icons.cloud_rounded,
            iconGradient: const [Color(0xFFf97316), Color(0xFFef4444)],
            title: l10n.guideGoogleRestoreTitle,
            subtitle: l10n.guideGoogleRestoreSubtitle,
            badge: l10n.guideBadgeAllDevices,
            badgeColor: const Color(0xFFea580c),
            enabled: cloudRestoreEnabled,
            onTap: cloudRestoreEnabled && !ui.isRestoring
                ? () => _cloudRestore('google')
                : null,
          ),
        ],
      ],
    );
  }

  Widget _buildFooter(
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Text(
      l10n.guideFooterHint,
      style: theme.textTheme.bodySmall?.copyWith(
        color: isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.isDark,
    required this.scheme,
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
    this.badge,
    this.badgeIcon,
    this.badgeColor,
    this.tags,
    this.enabled = true,
    required this.onTap,
  });

  final bool isDark;
  final ColorScheme scheme;
  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;
  final String? badge;
  final IconData? badgeIcon;
  final Color? badgeColor;
  final List<String>? tags;

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOnTap = enabled ? onTap : null;
    final iconColors = enabled
        ? iconGradient
        : const [Color(0xFFd1d5db), Color(0xFF9ca3af)];
    final titleColor = !enabled
        ? const Color(0xFF9ca3af)
        : (isDark ? scheme.onSurface : const Color(0xFF111827));
    final subtitleColor = !enabled
        ? const Color(0xFF9ca3af)
        : (isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563));
    final chevronColor = !enabled
        ? const Color(0xFFd1d5db)
        : (isDark
            ? scheme.onSurfaceVariant.withValues(alpha: 0.65)
            : Colors.grey[400]!);

    final cardBg = !enabled
        ? (isDark ? scheme.surfaceContainerHighest : const Color(0xFFf9fafb))
        : (isDark ? scheme.surfaceContainerLow : Colors.white);
    final cardBorder =
        isDark ? Border.all(color: scheme.outlineVariant, width: 1) : null;

    final content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: cardBorder ??
            Border.all(color: Colors.transparent, width: 2),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: enabled ? 0.06 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: iconColors,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 24,
              color: enabled ? Colors.white : const Color(0xFFe5e7eb),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: chevronColor,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (enabled
                              ? (badgeColor ?? const Color(0xFFdcfce7))
                              : const Color(0xFFe5e7eb))
                          .withValues(alpha: enabled ? 0.8 : 1.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (badgeIcon != null) ...[
                          Icon(
                            badgeIcon,
                            size: 12,
                            color: enabled
                                ? (badgeColor ?? const Color(0xFF15803d))
                                : const Color(0xFF9ca3af),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Flexible(
                          child: Text(
                            badge!,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: enabled
                                  ? (badgeColor ?? const Color(0xFF15803d))
                                  : const Color(0xFF9ca3af),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (tags != null && tags!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: tags!.map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? scheme.surfaceContainerHighest
                              : const Color(0xFFf3f4f6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          t,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? scheme.onSurfaceVariant
                                : const Color(0xFF4b5563),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (effectiveOnTap == null) {
      return Opacity(opacity: enabled ? 0.7 : 1.0, child: content);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: effectiveOnTap,
        borderRadius: BorderRadius.circular(12),
        child: content,
      ),
    );
  }
}
