import 'package:chain_notes/common/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/features/settings/application/help_center_catalog_provider.dart';
import 'package:chain_notes/features/settings/application/help_center_provider.dart';
import 'package:chain_notes/features/settings/domain/help_center_models.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';

const _comingSoonQuickGuideIds = {'guide-1', 'guide-2', 'guide-3', 'guide-4'};

class HelpCenterPage extends ConsumerWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(helpCenterControllerProvider);
    final controller = ref.read(helpCenterControllerProvider.notifier);
    final catalog = ref.watch(helpCenterFaqCatalogReaderProvider);
    final faqData = catalog.faqItems(l10n);
    final quickGuides = catalog.quickGuides(l10n);

    final categoryEntries = <({String key, String label})>[
      (key: HelpCenterCategoryKey.all, label: l10n.helpCategoryAll),
      (key: HelpCenterCategoryKey.basics, label: l10n.helpCategoryBasics),
      (key: HelpCenterCategoryKey.blockchain, label: l10n.helpCategoryBlockchain),
      (
        key: HelpCenterCategoryKey.walletSecurity,
        label: l10n.helpCategoryWalletSecurity,
      ),
      (key: HelpCenterCategoryKey.walletMgmt, label: l10n.helpCategoryWalletMgmt),
      (key: HelpCenterCategoryKey.advanced, label: l10n.helpCategoryAdvanced),
      (key: HelpCenterCategoryKey.common, label: l10n.helpCategoryCommon),
    ];

    final query = s.searchQuery.trim().toLowerCase();
    final filtered = faqData.where((faq) {
      final matchesCategory =
          s.selectedCategoryKey == HelpCenterCategoryKey.all ||
              faq.categoryKey == s.selectedCategoryKey;
      final matchesSearch = query.isEmpty ||
          faq.question.toLowerCase().contains(query) ||
          faq.answer.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList(growable: false);

    return Scaffold(
      backgroundColor: brand.settingsBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeaderWithBack(
            onBack: () => context.pop(),
            title: l10n.helpCenter,
            subtitle: l10n.helpCenterSubtitle,
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
                _SearchCard(
                  value: s.searchQuery,
                  hintText: l10n.helpSearchHint,
                  onChanged: controller.setSearchQuery,
                ),
                const SizedBox(height: 16),
                _SectionTitle(
                  icon: Icons.lightbulb_outline,
                  title: l10n.helpSectionQuickGuide,
                  color: brand.settingsAccent,
                ),
                _QuickGuidesGrid(
                  guides: quickGuides,
                  onGuideTap: (g) {
                    if (!_comingSoonQuickGuideIds.contains(g.id)) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.helpComingSoon)),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _SectionTitle(title: l10n.helpSectionFaq),
                const SizedBox(height: 12),
                _CategoryChips(
                  entries: categoryEntries,
                  selectedKey: s.selectedCategoryKey,
                  onSelect: controller.selectCategoryKey,
                ),
                const SizedBox(height: 12),
                if (filtered.isEmpty) _EmptyState(theme: theme, l10n: l10n),
                if (filtered.isNotEmpty)
                  ...filtered.map(
                    (faq) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _FaqCard(
                        theme: theme,
                        faq: faq,
                        expanded: s.expandedFaqIds.contains(faq.id),
                        onTap: () => controller.toggleFaq(faq.id),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                _ContactCard(
                  theme: theme,
                  l10n: l10n,
                  showForm: s.showContactForm,
                  supportEmail: AppConstants.support,
                  feedbackEmail: s.feedbackEmail,
                  feedbackMessage: s.feedbackMessage,
                  isSending: s.isSending,
                  onCopyEmail: () async {
                    await controller.copySupportEmail();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.helpCopySupportEmail)),
                    );
                  },
                  onToggleForm: () => controller.showForm(!s.showContactForm),
                  onEmailChanged: controller.setFeedbackEmail,
                  onMessageChanged: controller.setFeedbackMessage,
                  onCancel: () {
                    controller.showForm(false);
                    controller.setFeedbackEmail('');
                    controller.setFeedbackMessage('');
                  },
                  onSend: () async {
                    if (s.feedbackMessage.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.helpFeedbackEmpty)),
                      );
                      return;
                    }
                    final ok = await controller.sendFeedback(l10n);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok ? l10n.helpFeedbackThanks : l10n.helpFeedbackMailFailed,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    this.icon,
    this.color,
  });

  final String title;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? scheme.onSurface : const Color(0xFF111827);
    return Row(
      children: [
        if (icon != null)
          Icon(
            icon,
            size: 16,
            color: color ?? const Color(0xFF111827),
          ),
        if (icon != null) const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
      ],
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.value,
    required this.hintText,
    required this.onChanged,
  });

  final String value;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      color: isDark ? scheme.surfaceContainerHighest : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark
            ? BorderSide(color: scheme.outlineVariant)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF9ca3af)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
                onChanged: onChanged,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickGuidesGrid extends StatelessWidget {
  const _QuickGuidesGrid({
    required this.guides,
    required this.onGuideTap,
  });

  final List<HelpCenterQuickGuide> guides;
  final ValueChanged<HelpCenterQuickGuide> onGuideTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return GridView.builder(
      itemCount: guides.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, idx) {
        final g = guides[idx];
        return Card(
          color: isDark ? scheme.surfaceContainerHighest : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isDark
                ? BorderSide(color: scheme.outlineVariant)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onGuideTap(g),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: g.gradient,
                    ),
                    alignment: Alignment.center,
                    child: Icon(g.icon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    g.title,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: isDark ? scheme.onSurface : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    g.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1,
                      color: isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.entries,
    required this.selectedKey,
    required this.onSelect,
  });

  final List<({String key, String label})> entries;
  final String selectedKey;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final e in entries)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(e.label),
                selected: selectedKey == e.key,
                onSelected: (_) => onSelect(e.key),
                selectedColor: const Color(0xFF16a34a),
                backgroundColor:
                    isDark ? scheme.surfaceContainerHighest : null,
                side: isDark
                    ? BorderSide(color: scheme.outlineVariant)
                    : null,
                labelStyle: TextStyle(
                  color: selectedKey == e.key
                      ? Colors.white
                      : (isDark ? scheme.onSurface : const Color(0xFF374151)),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.theme,
    required this.faq,
    required this.expanded,
    required this.onTap,
  });

  final ThemeData theme;
  final HelpCenterFaqItem faq;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final border = expanded
        ? const Color(0xFF34d399)
        : (isDark ? scheme.outlineVariant : const Color(0xFFE5E7EB));
    final bg = expanded
        ? (isDark
            ? Color.alphaBlend(
                const Color(0xFFecfdf5).withValues(alpha: 0.35),
                scheme.surfaceContainerHighest,
              )
            : const Color(0xFFecfdf5))
        : (isDark ? scheme.surfaceContainerHighest : Colors.white);
    return Card(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: border, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFdcfce7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      faq.icon,
                      size: 18,
                      color: const Color(0xFF16a34a),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                faq.question,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            Icon(
                              expanded ? Icons.expand_less : Icons.expand_more,
                              color: const Color(0xFF9ca3af),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? scheme.surfaceContainerLow
                                : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            faq.category,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? scheme.onSurfaceVariant
                                  : const Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? scheme.surface : Colors.white,
                    border: Border.all(
                      color: isDark
                          ? scheme.outlineVariant
                          : const Color(0xFFbbf7d0),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    faq.answer,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: isDark ? scheme.onSurface : const Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme, required this.l10n});

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      color: isDark ? scheme.surfaceContainerHighest : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark
            ? BorderSide(color: scheme.outlineVariant)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.help_outline, size: 44, color: Color(0xFF9ca3af)),
            const SizedBox(height: 10),
            Text(
              l10n.helpEmptyTitle,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.helpEmptySubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.theme,
    required this.l10n,
    required this.showForm,
    required this.supportEmail,
    required this.feedbackEmail,
    required this.feedbackMessage,
    required this.isSending,
    required this.onCopyEmail,
    required this.onToggleForm,
    required this.onEmailChanged,
    required this.onMessageChanged,
    required this.onCancel,
    required this.onSend,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final bool showForm;
  final String supportEmail;
  final String feedbackEmail;
  final String feedbackMessage;
  final bool isSending;
  final VoidCallback onCopyEmail;
  final VoidCallback onToggleForm;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onMessageChanged;
  final VoidCallback onCancel;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      color: isDark ? scheme.surfaceContainerHighest : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark
            ? BorderSide(color: scheme.outlineVariant)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF16a34a),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mail_outline, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.helpContactTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? const Color(0xFF86efac)
                              : const Color(0xFF064e3b),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.helpContactSubtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF6ee7b7)
                              : const Color(0xFF047857),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? scheme.surface : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? scheme.outlineVariant
                                : const Color(0xFFbbf7d0),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.mail,
                              size: 18,
                              color: Color(0xFF6b7280),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                supportEmail,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                  color: isDark
                                      ? scheme.onSurface
                                      : const Color(0xFF111827),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            InkWell(
                              onTap: onCopyEmail,
                              borderRadius: BorderRadius.circular(8),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: Color(0xFF16a34a),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!showForm)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onToggleForm,
                  icon: const Icon(Icons.message_outlined, size: 18),
                  label: Text(l10n.helpContactSendFeedback),
                ),
              ),
            if (showForm) ...[
              const SizedBox(height: 12),
              Text(
                l10n.helpContactYourEmailOptional,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              TextField(
                onChanged: onEmailChanged,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: l10n.helpContactEmailHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                controller: TextEditingController(text: feedbackEmail)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: feedbackEmail.length),
                  ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.helpContactMessageLabel,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              TextField(
                onChanged: onMessageChanged,
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: l10n.helpContactMessageHint,
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(text: feedbackMessage)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: feedbackMessage.length),
                  ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSending ? null : onCancel,
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: isSending || feedbackMessage.trim().isEmpty
                          ? null
                          : onSend,
                      icon: Icon(
                        isSending ? Icons.schedule_send : Icons.send,
                        size: 18,
                      ),
                      label: Text(
                        isSending
                            ? l10n.helpContactSending
                            : l10n.helpContactSend,
                      ),
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
}

