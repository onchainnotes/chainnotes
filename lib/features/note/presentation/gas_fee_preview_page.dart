import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/common/config/app_display_switches.dart';
import 'package:chain_notes/features/home/data/service/gas_speed.dart';
import 'package:chain_notes/features/note/application/gas_fee_preview_provider.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

String _gasSpeedTitle(AppLocalizations l10n, GasSpeed s) => switch (s) {
      GasSpeed.slow => l10n.gasSpeedSlow,
      GasSpeed.normal => l10n.gasSpeedStandard,
      GasSpeed.fast => l10n.gasSpeedFast,
    };

String _gasSpeedTime(AppLocalizations l10n, GasSpeed s) => switch (s) {
      GasSpeed.slow => l10n.gasTimeSlow,
      GasSpeed.normal => l10n.gasTimeStandard,
      GasSpeed.fast => l10n.gasTimeFast,
    };

String _gasSpeedDesc(AppLocalizations l10n, GasSpeed s) => switch (s) {
      GasSpeed.slow => l10n.gasDescSlow,
      GasSpeed.normal => l10n.gasDescStandard,
      GasSpeed.fast => l10n.gasDescFast,
    };

class GasFeePreviewPage extends ConsumerWidget {
  const GasFeePreviewPage({super.key, required this.args});

  final GasFeePreviewArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gasFeePreviewProvider(args));
    final notifier = ref.read(gasFeePreviewProvider(args).notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final accent = isDark ? brand.settingsAccent : const Color(0xFF059669);
    final chain = state.chain;
    final sym = chain.symbol;
    final headerBg = isDark ? scheme.surface : Colors.white;
    final headerBorder =
        isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb);
    final muted = isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);
    final backBg =
        isDark ? scheme.surfaceContainerHighest : const Color(0xFFf3f4f6);
    final backIcon =
        isDark ? scheme.onSurface : const Color(0xFF374151);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            isDark ? Brightness.dark : Brightness.light,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
      backgroundColor: brand.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: headerBg,
              border: Border(
                bottom: BorderSide(color: headerBorder),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  BackIconButton(
                    onPressed: () => context.pop<GasSpeed?>(null),
                    backgroundColor: backBg,
                    iconColor: backIcon,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.local_gas_station_rounded,
                            color: accent, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          l10n.gasPreviewTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.gasPreviewSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ChainCard(chain: chain),
                  const SizedBox(height: 20),
                  if (state.isLoading) ...[
                    const SizedBox(height: 32),
                    Center(
                      child: CircularProgressIndicator(
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        l10n.gasPreviewLoading,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                        ),
                      ),
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.gasPreviewPickSpeed,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
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
                            l10n.gasPreviewLiveRates,
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...state.options.map(
                      (o) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SpeedOptionTile(
                          l10n: l10n,
                          option: o,
                          symbol: sym,
                          selected: state.selectedSpeed == o.speed,
                          onTap: () => notifier.setSpeed(o.speed),
                        ),
                      ),
                    ),
                    if (state.selectedOption != null)
                      _FeeBreakdownCard(
                        l10n: l10n,
                        option: state.selectedOption!,
                        noteKb: state.noteSizeBytes / 1024,
                        symbol: sym,
                        ethUsd: kGasFeeEthUsdEstimate,
                      ),
                    const SizedBox(height: 12),
                    _WarningCard(l10n: l10n, theme: theme),
                  ],
                  const SizedBox(height: 88),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              8 + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: BoxDecoration(
              color: headerBg,
              border: Border(
                top: BorderSide(color: headerBorder),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop<GasSpeed?>(null),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDark
                            ? scheme.outlineVariant
                            : const Color(0xFFd1d5db),
                        width: 2,
                      ),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                accent,
                                Color.lerp(accent, const Color(0xFF14b8a6), 0.45)!,
                              ]
                            : const [
                                Color(0xFF059669),
                                Color(0xFF14b8a6),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: state.isLoading || state.options.isEmpty
                            ? null
                            : () {
                                final speed = ref
                                    .read(gasFeePreviewProvider(args))
                                    .selectedSpeed;
                                context.pop<GasSpeed?>(speed);
                              },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: Text(
                              l10n.confirm,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
}

class _ChainCard extends StatelessWidget {
  const _ChainCard({required this.chain});

  final Chain chain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final decoration = isDark
        ? BoxDecoration(
            color: Color.alphaBlend(
              brand.settingsAccent.withValues(alpha: 0.2),
              scheme.surfaceContainerHighest,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant, width: 2),
          )
        : BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFecfdf5), Color(0xFFf0fdfa)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFa7f3d0), width: 2),
          );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: decoration,
      child: Row(
        children: [
          ChainNetworkLogo(
            chainLogoUrl: chain.chainLogo,
            fallbackColor: chain.colorValue,
            fallbackLabel: chain.icon ??
                (chain.name.isNotEmpty ? chain.name[0] : '?'),
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chain.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isDark ? scheme.onSurface : const Color(0xFF111827),
                  ),
                ),
                Text(
                  chain.displayNameOrName,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? scheme.onSurfaceVariant : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: brand.settingsAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              chain.symbol,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedOptionTile extends StatelessWidget {
  const _SpeedOptionTile({
    required this.l10n,
    required this.option,
    required this.symbol,
    required this.selected,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final GasFeeOption option;
  final String symbol;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final accent = isDark ? brand.settingsAccent : const Color(0xFF059669);
    final gwei = option.gweiMax;
    final gweiStr = gwei.toStringAsFixed(gwei < 1 ? 4 : 2);
    final gasCost = '${option.nativeAmount.toStringAsFixed(6)} $symbol';
    final showUsd = AppDisplaySwitches.showFiatUsdValues;
    final usd = option.nativeAmount * kGasFeeEthUsdEstimate;
    final usdLine =
        showUsd ? l10n.homeFiatApprox('\$${usd.toStringAsFixed(2)}') : '';
    final cardBg = selected
        ? (isDark
            ? Color.alphaBlend(
                accent.withValues(alpha: 0.22),
                scheme.surfaceContainerHighest,
              )
            : const Color(0xFFecfdf5))
        : (isDark ? scheme.surfaceContainerHighest : Colors.white);
    final cardBorder = selected
        ? accent
        : (isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb));
    final iconBoxBg = selected
        ? (isDark
            ? Color.alphaBlend(
                accent.withValues(alpha: 0.28),
                scheme.surfaceContainerHigh,
              )
            : const Color(0xFFd1fae5))
        : (isDark ? scheme.surfaceContainerHigh : const Color(0xFFf3f4f6));
    final iconFg =
        selected ? accent : (isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280));
    final muted =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);
    final labelMuted =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF9ca3af);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: cardBorder,
              width: 2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: isDark ? 0.2 : 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBoxBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  option.speed == GasSpeed.slow
                      ? Icons.schedule_rounded
                      : option.speed == GasSpeed.normal
                          ? Icons.bolt_rounded
                          : Icons.trending_up_rounded,
                  size: 22,
                  color: iconFg,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _gasSpeedTitle(l10n, option.speed),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                        if (option.speed == GasSpeed.normal) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF14532d)
                                  : const Color(0xFFd1fae5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.gasRecommendedBadge,
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? const Color(0xFFbbf7d0)
                                    : const Color(0xFF047857),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (selected)
                          Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: accent,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _gasSpeedTime(l10n, option.speed),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.gasLabelGasPrice,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: labelMuted,
                                ),
                              ),
                              Text(
                                l10n.gasPreviewGweiMax(gweiStr),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              l10n.gasLabelEstCost,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: labelMuted,
                              ),
                            ),
                            Text(
                              gasCost,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: accent,
                              ),
                            ),
                            if (usdLine.isNotEmpty)
                              Text(
                                usdLine,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: labelMuted,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeeBreakdownCard extends StatelessWidget {
  const _FeeBreakdownCard({
    required this.l10n,
    required this.option,
    required this.noteKb,
    required this.symbol,
    required this.ethUsd,
  });

  final AppLocalizations l10n;
  final GasFeeOption option;
  final double noteKb;
  final String symbol;
  final double ethUsd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final accent = isDark ? brand.settingsAccent : const Color(0xFF059669);
    final desc = _gasSpeedDesc(l10n, option.speed);
    final base = option.nativeAmount;
    final priority = base * 0.1;
    final total = base * 1.1;
    final showUsd = AppDisplaySwitches.showFiatUsdValues;
    final usdTotal = total * ethUsd;
    final borderColor =
        isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb);
    final descColor =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);
    final fiatMuted =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF9ca3af);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: brand.pageBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.gasFeeBreakdownTitle,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: descColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _breakRow(theme, l10n.gasFeeRowBase,
              '${base.toStringAsFixed(6)} $symbol'),
          _breakRow(theme, l10n.gasFeeRowPriority,
              '${priority.toStringAsFixed(6)} $symbol'),
          _breakRow(
            theme,
            l10n.gasFeeRowNoteSize,
            l10n.gasFeeNoteSizeKb(noteKb.toStringAsFixed(2)),
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.gasFeeRowTotal,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${total.toStringAsFixed(6)} $symbol',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                  if (showUsd)
                    Text(
                      l10n.homeFiatApprox('\$${usdTotal.toStringAsFixed(2)}'),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: fiatMuted,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _breakRow(ThemeData theme, String k, String v) {
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;
    final kColor =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);
    final vColor = isDark ? scheme.onSurface : const Color(0xFF111827);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            k,
            style: TextStyle(fontSize: 12, color: kColor),
          ),
          Text(
            v,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: vColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.l10n, required this.theme});

  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark
        ? Color.alphaBlend(
            Colors.amber.withValues(alpha: 0.14),
            scheme.surfaceContainerHighest,
          )
        : const Color(0xFFfffbeb);
    final border =
        isDark ? scheme.outlineVariant : const Color(0xFFfde68a);
    final iconColor = isDark ? Colors.amber.shade300 : Colors.amber.shade800;
    final textColor =
        isDark ? Colors.amber.shade100 : const Color(0xFF92400e);
    final subtitleColor =
        isDark ? Colors.amber.shade200 : const Color(0xFF92400e);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.gasWarningTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.gasWarningBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subtitleColor,
                    height: 1.45,
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
