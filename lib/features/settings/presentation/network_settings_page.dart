import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/settings/application/network_settings_provider.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class NetworkSettingsPage extends ConsumerWidget {
  const NetworkSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final asyncRows = ref.watch(networkSettingsRowsProvider);

    return Scaffold(
      backgroundColor: brand.settingsBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeaderWithBack(
            onBack: () => context.pop(),
            title: l10n.networkSettingsTitle,
            subtitle: l10n.networkSettingsSubtitle,
            backgroundGradient: brand.settingsHeaderGradient,
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 14),
            backBackgroundColor: Colors.white12,
            backIconColor: brand.onSettingsHeader,
            titleStyle: theme.textTheme.titleLarge?.copyWith(
              color: brand.onSettingsHeader,
              fontWeight: FontWeight.w800,
            ),
            subtitleStyle: theme.textTheme.bodySmall?.copyWith(
              color: brand.onSettingsHeaderSoft.withValues(alpha: 0.85),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: brand.settingsAccent,
              onRefresh: () async {
                ref.invalidate(networkSettingsRowsProvider);
                await ref.read(networkSettingsRowsProvider.future);
              },
              child: asyncRows.when(
                loading: () => Center(
                  child: CircularProgressIndicator(color: brand.settingsAccent),
                ),
                error: (e, _) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      l10n.networkLoadFailed(e.toString()),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          ref.invalidate(networkSettingsRowsProvider),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
                data: (grouped) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    _InfoCard(theme: theme, l10n: l10n),
                    const SizedBox(height: 16),
                    _SectionHeader(
                      icon: Icons.show_chart_rounded,
                      title: l10n.networkSectionMainnet,
                      countLabel: l10n.networkCountNetworks(
                        grouped.mainnetRows.length,
                      ),
                      badgeBackground: isDark
                          ? const Color(0xFF14532d)
                          : const Color(0xFFdcfce7),
                      badgeForeground: isDark
                          ? const Color(0xFFbbf7d0)
                          : const Color(0xFF15803d),
                    ),
                    const SizedBox(height: 12),
                    ...grouped.mainnetRows.map(
                      (row) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NetworkCard(
                          l10n: l10n,
                          row: row,
                          onTap: () => context.push(
                            AppRoutes.networkDetail,
                            extra: <String, dynamic>{'chain': row.chain},
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _SectionHeader(
                      icon: Icons.science_outlined,
                      title: l10n.networkSectionTestnet,
                      countLabel: l10n.networkCountNetworks(
                        grouped.testnetRows.length,
                      ),
                      badgeBackground: isDark
                          ? const Color(0xFF78350f)
                          : const Color(0xFFfef3c7),
                      badgeForeground: isDark
                          ? const Color(0xFFfde68a)
                          : const Color(0xFFb45309),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.networkTestnetListHint,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? scheme.onSurfaceVariant
                            : const Color(0xFF78716c),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...grouped.testnetRows.map(
                      (row) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NetworkCard(
                          l10n: l10n,
                          row: row,
                          onTap: () => context.push(
                            AppRoutes.networkDetail,
                            extra: <String, dynamic>{'chain': row.chain},
                          ),
                        ),
                      ),
                    ),
                    _QuickAddCard(theme: theme, l10n: l10n),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.countLabel,
    required this.badgeBackground,
    required this.badgeForeground,
  });

  final IconData icon;
  final String title;
  final String countLabel;
  final Color badgeBackground;
  final Color badgeForeground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.extension<AppBrandTheme>() ??
        (theme.brightness == Brightness.dark
            ? AppBrandTheme.dark
            : AppBrandTheme.light);
    return Row(
      children: [
        Icon(icon, size: 18, color: brand.settingsAccent),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: badgeBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            countLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: badgeForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.theme, required this.l10n});

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.18),
            scheme.surfaceContainerHighest,
          )
        : const Color(0xFFeff6ff);
    final border = isDark ? scheme.outlineVariant : const Color(0xFFbfdbfe);
    final titleColor = isDark ? scheme.onSurface : const Color(0xFF1e3a8a);
    final bodyColor = isDark ? scheme.onSurfaceVariant : const Color(0xFF1e3a8a);
    final bulletColor = isDark ? scheme.primary : const Color(0xFF1e40af);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: scheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.networkAboutNodesTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 8),
                _bullet(l10n.networkAboutNodesBullet1, bulletColor, bodyColor),
                _bullet(l10n.networkAboutNodesBullet2, bulletColor, bodyColor),
                _bullet(l10n.networkAboutNodesBullet3, bulletColor, bodyColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _bullet(String text, Color dotColor, Color bodyColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: dotColor)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                color: bodyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkCard extends StatelessWidget {
  const _NetworkCard({
    required this.l10n,
    required this.row,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final NetworkSettingsRow row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? scheme.surfaceContainerHighest : Colors.white;
    final borderColor =
        isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb);
    final subtitleColor =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);
    final metaIconColor =
        isDark ? scheme.onSurfaceVariant : Colors.grey[600]!;
    final chevronColor =
        isDark ? scheme.outlineVariant : Colors.grey[400]!;
    final chain = row.chain;
    final fallbackLabel = (chain.icon != null && chain.icon!.isNotEmpty)
        ? chain.icon!
        : chain.name.isNotEmpty
            ? chain.name[0]
            : '?';

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(chain.colorValue).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ChainNetworkLogo(
                  chainLogoUrl: chain.chainLogo,
                  fallbackColor: chain.colorValue,
                  fallbackLabel: fallbackLabel,
                  size: 48,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            chain.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusChip(
                          l10n: l10n,
                          status: row.status,
                          isDark: isDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chain.displayNameOrName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.hub_outlined,
                                size: 14, color: metaIconColor),
                            const SizedBox(width: 4),
                            Text(
                              l10n.networkNodeCountLabel(row.nodeCount),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                        if (row.status == NetworkNodeStatus.online)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 14,
                                color: isDark
                                    ? const Color(0xFF4ade80)
                                    : Colors.green[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.networkStatusConnectionOk,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isDark
                                      ? const Color(0xFF86efac)
                                      : Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        if (row.status == NetworkNodeStatus.offline)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 14,
                                color: isDark
                                    ? const Color(0xFFf87171)
                                    : Colors.red[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.networkStatusConnectionError,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isDark
                                      ? const Color(0xFFfecaca)
                                      : Colors.red[800],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: chevronColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.l10n,
    required this.status,
    required this.isDark,
  });

  final AppLocalizations l10n;
  final NetworkNodeStatus status;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case NetworkNodeStatus.online:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF14532d) : const Color(0xFFdcfce7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_rounded,
                size: 12,
                color: isDark ? const Color(0xFF86efac) : Colors.green[800],
              ),
              const SizedBox(width: 4),
              Text(
                l10n.networkNodeOnline,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFbbf7d0) : Colors.green[900],
                ),
              ),
            ],
          ),
        );
      case NetworkNodeStatus.custom:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1e3a5f) : const Color(0xFFdbeafe),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: 12,
                color: isDark ? const Color(0xFF93c5fd) : Colors.blue[900],
              ),
              const SizedBox(width: 4),
              Text(
                l10n.networkStatusCustomized,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFbfdbfe) : Colors.blue[900]!,
                ),
              ),
            ],
          ),
        );
      case NetworkNodeStatus.offline:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF450a0a) : const Color(0xFFfee2e2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 12,
                color: isDark ? const Color(0xFFfca5a5) : Colors.red[900],
              ),
              const SizedBox(width: 4),
              Text(
                l10n.networkNodeOffline,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFfecaca) : Colors.red[900],
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _QuickAddCard extends StatelessWidget {
  const _QuickAddCard({required this.theme, required this.l10n});

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final borderColor =
        isDark ? scheme.outlineVariant : const Color(0xFF86efac);
    final titleColor =
        isDark ? const Color(0xFFd1fae5) : const Color(0xFF14532d);
    final line1Color =
        isDark ? const Color(0xFFa7f3d0) : const Color(0xFF166534);
    final line2Color =
        isDark ? const Color(0xFF6ee7b7) : const Color(0xFF15803d);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: brand.settingsAccentSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(color: brand.settingsAccent, shape: BoxShape.circle),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.networkQuickAddTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.networkQuickAddLine1,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: line1Color,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.networkQuickAddLine2,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: line2Color,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
