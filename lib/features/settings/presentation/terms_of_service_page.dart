import 'package:chain_notes/common/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/common/constants/app_legal_documents.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

const _kHelpCenterRouteName = 'help-center';

Future<void> _openSupportMailto() async {
  final uri = Uri(scheme: 'mailto', path: AppConstants.support);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key, this.onBack});

  final VoidCallback? onBack;

  static const _accentGreen = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final l10n = AppLocalizations.of(context)!;
    final sections = _termsSections(l10n);

    void goBack() {
      if (onBack != null) {
        onBack!();
      } else {
        context.pop();
      }
    }

    return Scaffold(
      backgroundColor: brand.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeaderWithBack(
            onBack: goBack,
            title: l10n.profileTerms,
            backgroundGradient: brand.settingsHeaderGradient,
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 14),
            backBackgroundColor: Colors.white12,
            backIconColor: brand.onSettingsHeader,
            titleStyle: theme.textTheme.titleLarge?.copyWith(
              color: brand.onSettingsHeader,
              fontWeight: FontWeight.w800,
            ),
            leadingIcon: Icons.description_outlined,
            leadingIconColor:
                brand.onSettingsHeaderSoft.withValues(alpha: 0.85),
            spacingAfterTitleLeading: 12,
          ),
          _LastUpdatedBar(theme: theme, l10n: l10n),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _ImportantNoticeCard(theme: theme, l10n: l10n),
                const SizedBox(height: 16),
                for (final s in sections) ...[
                  _TermsSectionCard(theme: theme, section: s),
                  const SizedBox(height: 16),
                ],
                _HelpFooterCard(theme: theme, l10n: l10n),
                const SizedBox(height: 16),
                _PageFooter(theme: theme, l10n: l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsSection {
  const _TermsSection({
    required this.title,
    required this.icon,
    required this.paragraphs,
  });

  final String title;
  final IconData icon;
  final List<String> paragraphs;
}

List<String> _splitTermsLines(String source) {
  return source
      .split('\n')
      .map((line) => line.trimRight())
      .where((line) => line.isNotEmpty)
      .toList();
}

List<_TermsSection> _termsSections(AppLocalizations l10n) {
  final appTitle = l10n.appTitle;
  final privacyDoc = l10n.profilePrivacy;
  return [
    _TermsSection(
      title: l10n.termsOfServiceSection01Title,
      icon: Icons.check_circle_outline,
      paragraphs: _splitTermsLines(
        l10n.termsOfServiceSection01Body(appTitle),
      ),
    ),
    _TermsSection(
      title: l10n.termsOfServiceSection02Title,
      icon: Icons.article_outlined,
      paragraphs: _splitTermsLines(l10n.termsOfServiceSection02Body),
    ),
    _TermsSection(
      title: l10n.termsOfServiceSection03Title,
      icon: Icons.shield_outlined,
      paragraphs: _splitTermsLines(l10n.termsOfServiceSection03Body),
    ),
    _TermsSection(
      title: l10n.termsOfServiceSection04Title,
      icon: Icons.balance_outlined,
      paragraphs: _splitTermsLines(
        l10n.termsOfServiceSection04Body(appTitle),
      ),
    ),
    _TermsSection(
      title: l10n.termsOfServiceSection05Title,
      icon: Icons.warning_amber_rounded,
      paragraphs: _splitTermsLines(l10n.termsOfServiceSection05Body),
    ),
    _TermsSection(
      title: l10n.termsOfServiceSection06Title,
      icon: Icons.description_outlined,
      paragraphs: _splitTermsLines(l10n.termsOfServiceSection06Body),
    ),
    _TermsSection(
      title: l10n.termsOfServiceSection07Title,
      icon: Icons.warning_amber_outlined,
      paragraphs: _splitTermsLines(l10n.termsOfServiceSection07Body),
    ),
    _TermsSection(
      title: l10n.termsOfServiceSection08Title,
      icon: Icons.info_outline_rounded,
      paragraphs: _splitTermsLines(l10n.termsOfServiceSection08Body),
    ),
    _TermsSection(
      title: l10n.termsOfServiceSection09Title,
      icon: Icons.gavel_outlined,
      paragraphs: _splitTermsLines(l10n.termsOfServiceSection09Body),
    ),
    _TermsSection(
      title: l10n.termsOfServiceSection10Title,
      icon: Icons.list_alt_outlined,
      paragraphs: _splitTermsLines(
        l10n.termsOfServiceSection10Body(privacyDoc),
      ),
    ),
  ];
}

class _LastUpdatedBar extends StatelessWidget {
  const _LastUpdatedBar({required this.theme, required this.l10n});

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? scheme.surface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.termsOfServiceLastUpdatedLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? scheme.onSurface : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                AppLegalDocuments.lastUpdatedDisplay(locale),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFdcfce7),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFbbf7d0)),
            ),
            child: Text(
              AppLegalDocuments.versionBadgeDisplay(locale),
              style: theme.textTheme.labelSmall?.copyWith(
                color: const Color(0xFF15803d),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportantNoticeCard extends StatelessWidget {
  const _ImportantNoticeCard({required this.theme, required this.l10n});

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      elevation: 1,
      color: isDark ? scheme.surfaceContainerHighest : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border(
            left: BorderSide(color: TermsOfServicePage._accentGreen, width: 4),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFdcfce7),
                    const Color(0xFFccfbf1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.balance_outlined,
                color: TermsOfServicePage._accentGreen,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.termsOfServiceIntroTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? scheme.onSurface : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.termsOfServiceIntroBody(l10n.profilePrivacy),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563),
                      height: 1.45,
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

class _TermsSectionCard extends StatelessWidget {
  const _TermsSectionCard({required this.theme, required this.section});

  final ThemeData theme;
  final _TermsSection section;

  TextStyle _styleForLine(String line) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final muted = isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563);
    final strong = isDark ? scheme.onSurface : const Color(0xFF374151);
    if (line.startsWith('•')) {
      return (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: muted,
        height: 1.45,
      );
    }
    if (RegExp(r'^\d+\.\d+').hasMatch(line)) {
      return (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: strong,
        fontWeight: FontWeight.w600,
        height: 1.45,
      );
    }
    return (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: muted,
      height: 1.45,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      elevation: 1,
      color: isDark ? scheme.surfaceContainerHighest : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFdcfce7),
                        const Color(0xFFccfbf1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    section.icon,
                    size: 20,
                    color: TermsOfServicePage._accentGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? scheme.onSurface : const Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final line in section.paragraphs) ...[
                    Text(line, style: _styleForLine(line)),
                    const SizedBox(height: 6),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpFooterCard extends StatelessWidget {
  const _HelpFooterCard({required this.theme, required this.l10n});

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final gradientColors = isDark
        ? [
            Color.alphaBlend(
              const Color(0xFFf0fdf4).withValues(alpha: 0.22),
              scheme.surfaceContainerHighest,
            ),
            Color.alphaBlend(
              const Color(0xFFf0fdfa).withValues(alpha: 0.22),
              scheme.surfaceContainerHighest,
            ),
          ]
        : [
            const Color(0xFFf0fdf4).withValues(alpha: 0.9),
            const Color(0xFFf0fdfa).withValues(alpha: 0.9),
          ];
    return Card(
      elevation: 1,
      color: isDark ? scheme.surfaceContainerHighest : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? scheme.outlineVariant : const Color(0xFFbbf7d0),
          width: isDark ? 1 : 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: TermsOfServicePage._accentGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.termsOfServiceHelpTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? scheme.onSurface : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.termsOfServiceHelpBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ChipBadge(
                        label: l10n.helpCenter,
                        fg: const Color(0xFF15803d),
                        bg: const Color(0xFFdcfce7),
                        border: const Color(0xFF86efac),
                        onTap: () => context.pushNamed(_kHelpCenterRouteName),
                      ),
                      _ChipBadge(
                        label: l10n.termsOfServiceHelpMailFeedback,
                        fg: const Color(0xFF0f766e),
                        bg: const Color(0xFFccfbf1),
                        border: const Color(0xFF5eead4),
                        onTap: () => _openSupportMailto(),
                      ),
                    ],
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

class _ChipBadge extends StatelessWidget {
  const _ChipBadge({
    required this.label,
    required this.fg,
    required this.bg,
    required this.border,
    this.onTap,
  });

  final String label;
  final Color fg;
  final Color bg;
  final Color border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600),
      ),
    );
    if (onTap == null) return chip;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: chip,
      ),
    );
  }
}

class _PageFooter extends StatelessWidget {
  const _PageFooter({required this.theme, required this.l10n});

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final appTitle = l10n.appTitle;
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final footerColor =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF9ca3af);
    return Column(
      children: [
        Text(
          l10n.termsOfServiceFooterLine1(appTitle),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: footerColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.aboutPageCopyrightNotice(AppConstants.aboutCopyrightYearBrand),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: footerColor,
          ),
        ),
      ],
    );
  }
}
