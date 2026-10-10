import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/settings/application/app_locale_provider.dart';
import 'package:chain_notes/features/settings/domain/language_models.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  void _onLanguageRowTap(
    BuildContext context,
    WidgetRef ref,
    LanguageOption language,
  ) {
    _handleSelect(context, ref, language.code);
  }

  Future<void> _handleSelect(
    BuildContext context,
    WidgetRef ref,
    String code,
  ) async {
    final current = ref.read(appLanguageProvider);
    if (code == current) {
      if (context.mounted) context.pop();
      return;
    }

    await ref.read(appLanguageProvider.notifier).setLanguageCode(code);
    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final lang = LanguageCatalog.optionForCode(code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.languageSwitchedTo(lang.nativeName))),
    );
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final scheme = theme.colorScheme;
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final selected = ref.watch(appLanguageProvider);

    return Scaffold(
      backgroundColor: brand.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeaderWithBack(
            onBack: () => context.pop(),
            title: l10n.languageSelectTitle,
            subtitle: l10n.languageSelectSubtitle,
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _NoticeCard(theme: theme, l10n: l10n),
                const SizedBox(height: 12),
                ...LanguageCatalog.settingsPickerOptions.map((language) {
                  final isSelected = selected == language.code;
                  final titleColor = scheme.onSurface;
                  final subtitleColor = scheme.onSurfaceVariant;
                  final cardBg = isSelected
                      ? brand.settingsAccentSoft
                      : scheme.surface;
                  final borderColor = isSelected
                      ? brand.settingsAccent
                      : scheme.outlineVariant;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            _onLanguageRowTap(context, ref, language),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: brand.settingsAccent
                                          .withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              Text(
                                language.flagEmoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            language.nativeName,
                                            style: theme
                                                .textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: titleColor,
                                            ),
                                          ),
                                        ),
                                        if (isSelected) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: brand.settingsAccent,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              l10n.languageCurrentBadge,
                                              style: theme
                                                  .textTheme.labelSmall
                                                  ?.copyWith(
                                                color: brand.onSettingsHeader,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      language.name,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: subtitleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: brand.settingsAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                    color: brand.onSettingsHeader,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: brand.pageBackground,
              border: Border(
                top: BorderSide(color: scheme.outlineVariant),
              ),
            ),
            child: Text(
              l10n.languageFooterMore,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.theme,
    required this.l10n,
  });

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark
        ? scheme.primary.withValues(alpha: 0.12)
        : const Color(0xFFeff6ff);
    final border = isDark
        ? scheme.primary.withValues(alpha: 0.35)
        : const Color(0xFF93c5fd);
    final iconColor = isDark ? scheme.primary : const Color(0xFF2563eb);
    final titleColor = isDark
        ? scheme.onSurface
        : const Color(0xFF1e3a8a);
    final bodyColor = isDark ? scheme.onSurfaceVariant : const Color(0xFF1d4ed8);

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
          Icon(Icons.info_outline_rounded, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(
                  color: bodyColor,
                  fontSize: 12,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: l10n.languageNoticeHint,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  TextSpan(text: l10n.languageNoticeBody),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
