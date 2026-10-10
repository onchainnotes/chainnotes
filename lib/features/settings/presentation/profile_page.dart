import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/app/theme/theme_mode_provider.dart';
import 'package:chain_notes/features/settings/application/app_locale_provider.dart';
import 'package:chain_notes/features/settings/domain/language_models.dart';
import 'package:chain_notes/common/config/app_v2_feature_switches.dart';
import 'package:chain_notes/common/utils/app_rate.dart';
import 'package:chain_notes/common/utils/app_share.dart';
import 'package:chain_notes/common/utils/app_version_info.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/settings/application/profile_page_provider.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

BoxDecoration _profileLeadingIconDecoration(
  ThemeData theme, {
  required bool danger,
}) {
  final scheme = theme.colorScheme;
  if (danger) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: scheme.errorContainer,
    );
  }
  if (theme.brightness == Brightness.dark) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          scheme.primary.withValues(alpha: 0.28),
          scheme.tertiary.withValues(alpha: 0.18),
        ],
      ),
    );
  }
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFdcfce7), Color(0xFFccfbf1)],
    ),
  );
}

Color _profileLeadingIconForeground(ThemeData theme, {required bool danger}) {
  if (danger) return theme.colorScheme.error;
  return theme.brightness == Brightness.dark
      ? theme.colorScheme.primary
      : const Color(0xFF059669);
}

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    super.key,
    this.notes = const [],
    this.currentChain,
    this.walletContextTick = 0,
    this.onOpenWalletManagement,
    this.onOpenAbout,
  });

  final List<Note> notes;

  final Chain? currentChain;

  final int walletContextTick;
  final VoidCallback? onOpenWalletManagement;
  final VoidCallback? onOpenAbout;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _verificationCode = TextEditingController();

  ProfilePageController _controller() {
    return ref.read(
      profilePageControllerProvider(
        walletContextTick: widget.walletContextTick,
        chainId: widget.currentChain?.chainId,
      ).notifier,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _email.dispose();
    _verificationCode.dispose();
    super.dispose();
  }

  String _formatAddress(String? address, AppLocalizations l10n) {
    if (address == null || address.isEmpty) return l10n.profileNotConnected;
    if (address.length < 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  String _formatEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final local = parts[0];
    if (local.length <= 3) return email;
    return '${local.substring(0, 3)}***@${parts[1]}';
  }

  void _handleSendCode() {
    final email = _email.text.trim();
    final l10n = AppLocalizations.of(context)!;
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.enterValidEmail)));
      return;
    }
    _controller().startSendCodeCountdown();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.verificationCodeSent)));
  }

  Future<void> _handleBindEmail() async {
    final email = _email.text.trim();
    final code = _verificationCode.text.trim();
    final l10n = AppLocalizations.of(context)!;
    if (email.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.fillAllFields)));
      return;
    }
    if (code.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.enterSixDigitCode)));
      return;
    }
    await _controller().bindEmailSuccess(email);
    _email.clear();
    _verificationCode.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.emailBindSuccess)),
    );
  }

  Future<void> _handleUnbindEmail() async {
    await _controller().unbindEmail();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.emailUnbound)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final ui = ref.watch(
      profilePageControllerProvider(
        walletContextTick: widget.walletContextTick,
        chainId: widget.currentChain?.chainId,
      ),
    );
    final controller = _controller();
    ref.watch(appThemeModeProvider);

    final effectiveDarkMode = theme.brightness == Brightness.dark;
    final languageCode = ref.watch(appLanguageProvider);
    final languageDisplayName = LanguageCatalog.optionForCode(
      languageCode,
    ).nativeName;
    return Scaffold(
      backgroundColor: brand.pageBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(theme, l10n, ui),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _sectionTitle(theme, l10n.profileSectionAccount),
                      const SizedBox(height: 8),
                      _buildCard(
                        theme,
                        [
                        _MenuItem(
                          icon: Icons.account_balance_wallet_outlined,
                          label: l10n.walletManagement,
                          value: _formatAddress(
                            ui.currentProtocolAddress ?? ui.currentWallet,
                            l10n,
                          ),
                          onTap: widget.onOpenWalletManagement,
                        ),
                        _MenuItem(
                          icon: Icons.hub_outlined,
                          label: l10n.networkSettingsTitle,
                          value: l10n.profileNetworkSettingsSubtitle,
                          onTap: () => context.push(AppRoutes.networkSettings),
                        ),
                      ],
                        useDarkOutlineDividers: true,
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle(theme, l10n.profileSectionSecurity),
                      const SizedBox(height: 8),
                      _buildCard(
                        theme,
                        [
                        _MenuItem(
                          icon: Icons.lock_outline,
                          label: l10n.changePassword,
                          value: l10n.profileChangePasswordSubtitle,
                          onTap: () => context.push(AppRoutes.changePassword),
                        ),
                        if (AppV2FeatureSwitches
                            .profileBindEmailNotificationsLogout)
                          _MenuItem(
                            icon: Icons.mail_outline,
                            label: l10n.bindEmail,
                            value: ui.boundEmail != null
                                ? _formatEmail(ui.boundEmail!)
                                : l10n.profileBindEmailNotBound,
                            badge: ui.boundEmail != null
                                ? l10n.profileBindEmailBadgeBound
                                : null,
                            onTap: () => controller.openBindEmailDialog(true),
                          ),
                      ],
                        useDarkOutlineDividers: true,
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle(theme, l10n.profileSectionPreferences),
                      const SizedBox(height: 8),
                      _buildCard(
                        theme,
                        [
                        if (AppV2FeatureSwitches
                            .profileBindEmailNotificationsLogout)
                          _SwitchItem(
                            icon: Icons.notifications_outlined,
                            label: l10n.profileNotifications,
                            value: ui.notifications,
                            onChanged: controller.setNotifications,
                          ),
                        _SwitchItem(
                          icon: Icons.dark_mode_outlined,
                          label: l10n.profileDarkMode,
                          value: effectiveDarkMode,
                          onChanged: (v) => ref
                              .read(appThemeModeProvider.notifier)
                              .setDarkMode(v),
                        ),
                        _MenuItem(
                          icon: Icons.language,
                          label: l10n.profileLanguage,
                          value: languageDisplayName,
                          onTap: () => context.push(AppRoutes.languageSettings),
                        ),
                      ],
                        useDarkOutlineDividers: true,
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle(theme, l10n.profileSectionMore),
                      const SizedBox(height: 8),
                      _buildCard(
                        theme,
                        [
                        _MenuItem(
                          icon: Icons.info_outline,
                          label: l10n.aboutUs,
                          onTap:
                              widget.onOpenAbout ??
                              () => context.push(AppRoutes.about),
                        ),
                        _MenuItem(
                          icon: Icons.help_outline,
                          label: l10n.helpCenter,
                          onTap: () => context.push(AppRoutes.helpCenter),
                        ),
                        _MenuItem(
                          icon: Icons.description_outlined,
                          label: l10n.profileTerms,
                          onTap: () => context.push(AppRoutes.termsOfService),
                        ),
                        _MenuItem(
                          icon: Icons.shield_outlined,
                          label: l10n.profilePrivacy,
                          onTap: () => context.push(AppRoutes.privacyPolicy),
                        ),
                        _MenuItem(
                          icon: Icons.star_outline,
                          label: l10n.profileRateUs,
                          onTap: rateUs,
                        ),
                        _MenuItem(
                          icon: Icons.share_outlined,
                          label: l10n.profileShare,
                          onTap: () => shareAppInvite(l10n),
                        ),
                      ],
                        useDarkOutlineDividers: true,
                      ),
                      if (!kReleaseMode) ...[
                        const SizedBox(height: 12),
                        _buildCard(theme, [
                          _MenuItem(
                            icon: Icons.bug_report_outlined,
                            label: l10n.profileTestPage,
                            value: l10n.profileTestPageSubtitle,
                            onTap: () async {

                              // ignore: dead_code
                              context.push(AppRoutes.test);
                            },
                          ),
                        ]),
                      ],
                      if (AppV2FeatureSwitches
                          .profileBindEmailNotificationsLogout) ...[
                        const SizedBox(height: 16),
                        _buildCard(theme, [
                          _MenuItem(
                            icon: Icons.logout,
                            label: l10n.profileLogoutLabel,
                            danger: true,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.profileLogoutPending),
                                ),
                              );
                            },
                          ),
                        ]),
                      ],
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          l10n.profilePageFooter(
                            l10n.appTitle,
                            AppVersionInfo.version,
                            AppVersionInfo.copyrightYear,
                          ),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (AppV2FeatureSwitches.profileBindEmailNotificationsLogout &&
              ui.showBindEmailDialog)
            _buildBindEmailDialog(theme, l10n, ui, controller),
        ],
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    AppLocalizations l10n,
    ProfilePageState ui,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF059669), Color(0xFF0d9488)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF22c55e), Color(0xFF14b8a6)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        ui.currentWallet != null &&
                                ui.currentWallet!.length >= 4
                            ? ui.currentWallet!.substring(2, 4).toUpperCase()
                            : 'ME',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ui.currentWalletName ?? l10n.profileDefaultWalletName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatAddress(
                            ui.currentProtocolAddress ?? ui.currentWallet,
                            l10n,
                          ),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ui.isActiveUser
                                ? l10n.profileUserActive
                                : l10n.profileUserNormal,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatCard(
                    value: '${ui.noteCount}',
                    label: l10n.profileStatNotes,
                  ),
                  const SizedBox(width: 8),
                  _StatCard(
                    value: '${ui.onChainCount}',
                    label: l10n.profileStatOnChain,
                  ),
                  const SizedBox(width: 8),
                  _StatCard(
                    value: '${ui.activeDays}',
                    label: l10n.profileStatDays,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    ThemeData theme,
    List<Widget> children, {
    bool useDarkOutlineDividers = false,
  }) {
    final scheme = theme.colorScheme;
    final borderAndDividerColor =
        useDarkOutlineDividers && theme.brightness == Brightness.dark
            ? scheme.outlineVariant
            : Colors.grey.shade200;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderAndDividerColor),
      ),
      child: Column(
        children: children
            .asMap()
            .entries
            .map(
              (e) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  e.value,
                  if (e.key < children.length - 1)
                    Divider(height: 1, color: borderAndDividerColor),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildBindEmailDialog(
    ThemeData theme,
    AppLocalizations l10n,
    ProfilePageState ui,
    ProfilePageController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.openBindEmailDialog(false),
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.black26,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.bindEmail, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  l10n.profileBindEmailDialogSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: l10n.profileBindEmailFieldEmail,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _verificationCode,
                        decoration: InputDecoration(
                          labelText: l10n.profileBindEmailFieldCode,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      child: FilledButton(
                        onPressed: ui.codeSent && ui.countdown > 0
                            ? null
                            : _handleSendCode,
                        child: Text(
                          ui.codeSent && ui.countdown > 0
                              ? l10n.profileResendCodeInSeconds(ui.countdown)
                              : l10n.profileSendVerificationCode,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => controller.openBindEmailDialog(false),
                      child: Text(l10n.cancel),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _handleBindEmail,
                      child: Text(l10n.confirm),
                    ),
                  ],
                ),
                if (ui.boundEmail != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _handleUnbindEmail,
                    child: Text(
                      l10n.profileUnbindEmail,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.value,
    this.badge,
    this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final String? badge;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: _profileLeadingIconDecoration(theme, danger: danger),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 20,
              color: _profileLeadingIconForeground(theme, danger: danger),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: danger ? theme.colorScheme.error : null,
                  ),
                ),
                if (value != null && value!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    value!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(badge!, style: theme.textTheme.labelSmall),
            ),
          if (onTap != null)
            Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(onTap: onTap, child: content);
    }
    return content;
  }
}

class _SwitchItem extends StatelessWidget {
  const _SwitchItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: _profileLeadingIconDecoration(theme, danger: false),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 20,
              color: _profileLeadingIconForeground(theme, danger: false),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return theme.colorScheme.onPrimary;
              }
              return theme.colorScheme.outline;
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {

                return const Color(0xFF059669);
              }
              return theme.colorScheme.surfaceContainerHighest;
            }),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }
}
