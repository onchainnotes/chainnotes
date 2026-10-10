import 'package:flutter/material.dart';
import 'package:chain_notes/features/settings/domain/help_center_models.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'help_center_catalog_provider.g.dart';

class HelpCenterFaqCatalogReader {
  const HelpCenterFaqCatalogReader();

  List<HelpCenterFaqItem> faqItems(AppLocalizations l10n) {
    return [
      HelpCenterFaqItem(
        id: '1',
        categoryKey: HelpCenterCategoryKey.basics,
        category: l10n.helpCategoryBasics,
        question: l10n.helpFaq1Question,
        answer: l10n.helpFaq1Answer,
        icon: Icons.description_outlined,
      ),
      HelpCenterFaqItem(
        id: '2',
        categoryKey: HelpCenterCategoryKey.basics,
        category: l10n.helpCategoryBasics,
        question: l10n.helpFaq2Question,
        answer: l10n.helpFaq2Answer,
        icon: Icons.note_add_outlined,
      ),
      HelpCenterFaqItem(
        id: '3',
        categoryKey: HelpCenterCategoryKey.basics,
        category: l10n.helpCategoryBasics,
        question: l10n.helpFaq3Question,
        answer: l10n.helpFaq3Answer,
        icon: Icons.save_outlined,
      ),
      HelpCenterFaqItem(
        id: '4',
        categoryKey: HelpCenterCategoryKey.blockchain,
        category: l10n.helpCategoryBlockchain,
        question: l10n.helpFaq4Question,
        answer: l10n.helpFaq4Answer,
        icon: Icons.link,
      ),
      HelpCenterFaqItem(
        id: '5',
        categoryKey: HelpCenterCategoryKey.blockchain,
        category: l10n.helpCategoryBlockchain,
        question: l10n.helpFaq5Question,
        answer: l10n.helpFaq5Answer,
        icon: Icons.hub_outlined,
      ),
      HelpCenterFaqItem(
        id: '6',
        categoryKey: HelpCenterCategoryKey.blockchain,
        category: l10n.helpCategoryBlockchain,
        question: l10n.helpFaq6Question,
        answer: l10n.helpFaq6Answer,
        icon: Icons.verified_outlined,
      ),
      HelpCenterFaqItem(
        id: '7',
        categoryKey: HelpCenterCategoryKey.walletSecurity,
        category: l10n.helpCategoryWalletSecurity,
        question: l10n.helpFaq7Question,
        answer: l10n.helpFaq7Answer,
        icon: Icons.shield_outlined,
      ),
      HelpCenterFaqItem(
        id: '8',
        categoryKey: HelpCenterCategoryKey.walletSecurity,
        category: l10n.helpCategoryWalletSecurity,
        question: l10n.helpFaq8Question,
        answer: l10n.helpFaq8Answer,
        icon: Icons.security_outlined,
      ),
      HelpCenterFaqItem(
        id: '9',
        categoryKey: HelpCenterCategoryKey.walletSecurity,
        category: l10n.helpCategoryWalletSecurity,
        question: l10n.helpFaq9Question,
        answer: l10n.helpFaq9Answer,
        icon: Icons.key_outlined,
      ),
      HelpCenterFaqItem(
        id: '10',
        categoryKey: HelpCenterCategoryKey.walletMgmt,
        category: l10n.helpCategoryWalletMgmt,
        question: l10n.helpFaq10Question,
        answer: l10n.helpFaq10Answer,
        icon: Icons.account_balance_wallet_outlined,
      ),
      HelpCenterFaqItem(
        id: '11',
        categoryKey: HelpCenterCategoryKey.walletMgmt,
        category: l10n.helpCategoryWalletMgmt,
        question: l10n.helpFaq11Question,
        answer: l10n.helpFaq11Answer,
        icon: Icons.expand_more,
      ),
      HelpCenterFaqItem(
        id: '12',
        categoryKey: HelpCenterCategoryKey.advanced,
        category: l10n.helpCategoryAdvanced,
        question: l10n.helpFaq12Question,
        answer: l10n.helpFaq12Answer,
        icon: Icons.settings_ethernet_outlined,
      ),
      HelpCenterFaqItem(
        id: '13',
        categoryKey: HelpCenterCategoryKey.advanced,
        category: l10n.helpCategoryAdvanced,
        question: l10n.helpFaq13Question,
        answer: l10n.helpFaq13Answer,
        icon: Icons.format_bold,
      ),
      HelpCenterFaqItem(
        id: '14',
        categoryKey: HelpCenterCategoryKey.common,
        category: l10n.helpCategoryCommon,
        question: l10n.helpFaq14Question,
        answer: l10n.helpFaq14Answer,
        icon: Icons.warning_amber_outlined,
      ),
      HelpCenterFaqItem(
        id: '15',
        categoryKey: HelpCenterCategoryKey.common,
        category: l10n.helpCategoryCommon,
        question: l10n.helpFaq15Question,
        answer: l10n.helpFaq15Answer,
        icon: Icons.hourglass_bottom,
      ),
      HelpCenterFaqItem(
        id: '16',
        categoryKey: HelpCenterCategoryKey.common,
        category: l10n.helpCategoryCommon,
        question: l10n.helpFaq16Question,
        answer: l10n.helpFaq16Answer,
        icon: Icons.help_outline,
      ),
    ];
  }

  List<HelpCenterQuickGuide> quickGuides(AppLocalizations l10n) {
    return [
      HelpCenterQuickGuide(
        id: 'guide-1',
        title: l10n.helpQuickGuide1Title,
        description: l10n.helpQuickGuide1Desc,
        icon: Icons.menu_book_outlined,
        gradient: const LinearGradient(
          colors: [Color(0xFF3b82f6), Color(0xFF2563eb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      HelpCenterQuickGuide(
        id: 'guide-2',
        title: l10n.helpQuickGuide2Title,
        description: l10n.helpQuickGuide2Desc,
        icon: Icons.description_outlined,
        gradient: const LinearGradient(
          colors: [Color(0xFF22c55e), Color(0xFF16a34a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      HelpCenterQuickGuide(
        id: 'guide-3',
        title: l10n.helpQuickGuide3Title,
        description: l10n.helpQuickGuide3Desc,
        icon: Icons.shield_outlined,
        gradient: const LinearGradient(
          colors: [Color(0xFFef4444), Color(0xFFdc2626)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      HelpCenterQuickGuide(
        id: 'guide-4',
        title: l10n.helpQuickGuide4Title,
        description: l10n.helpQuickGuide4Desc,
        icon: Icons.account_balance_wallet_outlined,
        gradient: const LinearGradient(
          colors: [Color(0xFFa855f7), Color(0xFF7c3aed)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];
  }
}

@riverpod
HelpCenterFaqCatalogReader helpCenterFaqCatalogReader(
  HelpCenterFaqCatalogReaderRef ref,
) {
  return const HelpCenterFaqCatalogReader();
}
