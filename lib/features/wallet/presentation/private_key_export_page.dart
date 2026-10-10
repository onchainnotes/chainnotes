import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/wallet/application/private_key_export_provider.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class PrivateKeyExportPage extends ConsumerStatefulWidget {
  const PrivateKeyExportPage({super.key, required this.walletAddress});

  final String walletAddress;

  @override
  ConsumerState<PrivateKeyExportPage> createState() =>
      _PrivateKeyExportPageState();
}

class _PrivateKeyExportPageState extends ConsumerState<PrivateKeyExportPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(privateKeyExportProvider(widget.walletAddress).notifier)
          .bootstrap(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(privateKeyExportProvider(widget.walletAddress));
    final n = ref.read(privateKeyExportProvider(widget.walletAddress).notifier);

    if (s.phase == PrivateKeyExportPhase.booting) {
      return Scaffold(
        backgroundColor: brand.pageBackground,
        body: Center(
          child: CircularProgressIndicator(color: brand.settingsAccent),
        ),
      );
    }

    if (s.phase == PrivateKeyExportPhase.error) {
      return Scaffold(
        backgroundColor: brand.pageBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeaderWithBack(
              onBack: () => context.pop(),
              title: l10n.viewPrivateKey,
              leadingIcon: Icons.key_rounded,
              leadingIconColor:
                  brand.onSettingsHeaderSoft.withValues(alpha: 0.85),
              backgroundGradient: brand.settingsHeaderGradient,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 14),
              backBackgroundColor: Colors.white12,
              backIconColor: brand.onSettingsHeader,
              titleStyle: theme.textTheme.titleLarge?.copyWith(
                color: brand.onSettingsHeader,
                fontWeight: FontWeight.w800,
              ),
              spacingAfterBack: 12,
              spacingAfterTitleLeading: 12,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.errorText ?? l10n.walletErrGetPrivateKeyFailed,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => context.pop(),
                        style: FilledButton.styleFrom(
                          backgroundColor: brand.settingsAccent,
                          foregroundColor: brand.onSettingsHeader,
                        ),
                        child: Text(l10n.back),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final selected = s.selectedChain;
    final chains = ref.watch(privateKeyExportChainsProvider);

    return Scaffold(
      backgroundColor: brand.settingsBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeaderWithBack(
            onBack: () => n.headerBack(context),
            title: selected == null
                ? l10n.viewPrivateKey
                : selected.displayNameOrName,
            subtitle: selected == null
                ? l10n.privateKeyExportSelectNetworkHint
                : l10n.privateKeyExportKeepKeySafeHint,
            leadingIcon: selected == null
                ? Icons.key_rounded
                : Icons.layers_rounded,
            leadingIconColor:
                brand.onSettingsHeaderSoft.withValues(alpha: 0.85),
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
            spacingAfterBack: 12,
            spacingAfterTitleLeading: 12,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: selected == null
                  ? _buildChainList(context, theme, brand, l10n, chains, n)
                  : _buildChainDetail(
                      context,
                      theme,
                      brand,
                      l10n,
                      s,
                      n,
                      selected,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChainList(
    BuildContext context,
    ThemeData theme,
    AppBrandTheme brand,
    AppLocalizations l10n,
    List<Chain> chains,
    PrivateKeyExport n,
  ) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final dangerBorder =
        isDark ? scheme.error.withValues(alpha: 0.55) : const Color(0xFFfecaca);
    final dangerBg =
        isDark ? scheme.errorContainer : const Color(0xFFfef2f2);
    final dangerFg =
        isDark ? scheme.onErrorContainer : const Color(0xFF991b1b);
    final dangerIcon = isDark ? scheme.error : const Color(0xFFdc2626);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _pkCard(
          border: dangerBorder,
          bg: dangerBg,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: dangerIcon, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.privateKeyExportSecurityWarningTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: dangerFg,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _pkBullet(l10n.privateKeyExportWarnBullet1, dangerFg),
                    _pkBullet(l10n.privateKeyExportWarnBullet2, dangerFg),
                    _pkBullet(l10n.privateKeyExportWarnBullet3, dangerFg),
                    _pkBullet(l10n.privateKeyExportWarnBullet4, dangerFg),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.lock_outline, color: brand.settingsAccent, size: 20),
            const SizedBox(width: 8),
            Text(
              l10n.privateKeyExportSupportedNetworksTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? brand.settingsAccent.withValues(alpha: 0.18)
                    : const Color(0xFFd1fae5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.privateKeyExportNetworkCount(chains.length),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDark ? brand.settingsAccent : const Color(0xFF047857),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...chains.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => n.openChainDetail(c),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: scheme.outline.withValues(alpha: isDark ? 0.45 : 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        _pkChainLogo(c),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    c.name,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: scheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      c.symbol,
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c.displayNameOrName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: scheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildChainDetail(
    BuildContext context,
    ThemeData theme,
    AppBrandTheme brand,
    AppLocalizations l10n,
    PrivateKeyExportState s,
    PrivateKeyExport n,
    Chain chain,
  ) {
    final hex = s.privateKeyHex ?? '';
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final okBorder =
        isDark ? brand.settingsAccent.withValues(alpha: 0.45) : const Color(0xFF86efac);
    final okBg = isDark
        ? brand.settingsAccent.withValues(alpha: 0.12)
        : const Color(0xFFf0fdf4);

    final warnBorder = isDark
        ? scheme.outlineVariant.withValues(alpha: 0.7)
        : const Color(0xFFfde68a);
    final warnBg =
        isDark ? scheme.tertiaryContainer : const Color(0xFFfffbeb);
    final warnFg =
        isDark ? scheme.onTertiaryContainer : const Color(0xFF92400e);
    final warnIcon =
        isDark ? scheme.onTertiaryContainer : Colors.amber.shade700;

    final dangerBorder =
        isDark ? scheme.error.withValues(alpha: 0.55) : const Color(0xFFfecaca);
    final dangerBg =
        isDark ? scheme.errorContainer : const Color(0xFFfef2f2);
    final dangerFg =
        isDark ? scheme.onErrorContainer : const Color(0xFF991b1b);
    final dangerIcon = isDark ? scheme.error : const Color(0xFFdc2626);

    final neutralBorder =
        scheme.outline.withValues(alpha: isDark ? 0.45 : 0.35);
    final neutralBg = scheme.surfaceContainerHighest.withValues(
      alpha: isDark ? 0.35 : 0.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _pkCard(
          border: okBorder,
          bg: okBg,
          child: Row(
            children: [
              _pkChainLogo(chain, size: 56),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          chain.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: brand.settingsAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            chain.symbol,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: brand.onSettingsHeader,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chain.displayNameOrName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _pkCard(
          border: warnBorder,
          bg: warnBg,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded, color: warnIcon, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.privateKeyExportViewSafetyTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: warnFg,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _pkBullet(l10n.privateKeyExportViewBullet1, warnFg),
                    _pkBullet(l10n.privateKeyExportViewBullet2, warnFg),
                    _pkBullet(l10n.privateKeyExportViewBullet3, warnFg),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: neutralBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.key_rounded, size: 18, color: brand.settingsAccent),
                  const SizedBox(width: 8),
                  Text(
                    l10n.privateKeyExportKeySectionTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: n.toggleShowPrivateKey,
                    icon: Icon(
                      s.showPrivateKey
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 22,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  IconButton(
                    onPressed: s.showPrivateKey
                        ? () => n.copyPrivateKey(context)
                        : null,
                    icon: Icon(
                      s.copied ? Icons.check_rounded : Icons.copy_rounded,
                      size: 22,
                      color: s.copied
                          ? brand.settingsAccent
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                l10n.privateKeyExportBip44Hint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? scheme.surfaceContainerHighest.withValues(alpha: 0.55)
                      : brand.pageBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: isDark ? 0.45 : 0.3),
                  ),
                ),
                width: double.infinity,
                child: s.showPrivateKey
                    ? SelectableText(
                        hex,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: scheme.onSurface,
                          height: 1.4,
                        ),
                      )
                    : Text(
                        hex.isEmpty
                            ? l10n.privateKeyExportMaskedPlaceholder
                            : '${hex.substring(0, 2)}${'•' * (hex.length - 2)}',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
              ),
              if (s.showPrivateKey) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 16, color: warnIcon),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.privateKeyExportDoNotShareInline,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        _pkCard(
          border: neutralBorder,
          bg: neutralBg,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.fingerprint_rounded,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.privateKeyExportNetworkAddressLabel(chain.name),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      s.chainResolvedAddress ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _pkCard(
          border: dangerBorder,
          bg: dangerBg,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: dangerIcon, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.privateKeyExportImportantReminderTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: dangerFg,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _pkBullet(l10n.privateKeyExportReminderBullet1, dangerFg),
                    _pkBullet(l10n.privateKeyExportReminderBullet2, dangerFg),
                    _pkBullet(l10n.privateKeyExportReminderBullet3, dangerFg),
                    _pkBullet(l10n.privateKeyExportReminderBullet4, dangerFg),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: n.backToChainList,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(l10n.privateKeyExportBackToList),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: scheme.onSurface,
                  side: BorderSide(color: neutralBorder, width: 2),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: s.showPrivateKey
                    ? () => n.copyPrivateKey(context)
                    : null,
                icon: Icon(
                  s.copied ? Icons.check_rounded : Icons.copy_rounded,
                  size: 18,
                ),
                label: Text(
                  s.copied
                      ? l10n.labelCopied
                      : l10n.privateKeyExportCopySecurityKey,
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: brand.settingsAccent,
                  foregroundColor: brand.onSettingsHeader,
                  disabledBackgroundColor:
                      scheme.surfaceContainerHighest.withValues(alpha: 0.9),
                  disabledForegroundColor:
                      scheme.onSurface.withValues(alpha: 0.38),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}

Widget _pkChainLogo(Chain chain, {double size = 48}) {
  return ChainNetworkLogo(
    chainLogoUrl: chain.chainLogo,
    fallbackColor: chain.colorValue,
    fallbackLabel: chain.icon ??
        (chain.name.isNotEmpty ? chain.name[0] : '?'),
    size: size,
  );
}

Widget _pkCard({
  required Color border,
  required Color bg,
  required Widget child,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: border, width: 2),
    ),
    child: child,
  );
}

Widget _pkBullet(String text, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(color: color, fontSize: 12)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 12, height: 1.35),
          ),
        ),
      ],
    ),
  );
}
