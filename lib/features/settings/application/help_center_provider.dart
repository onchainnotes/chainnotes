import 'dart:async';

import 'package:chain_notes/common/constants/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chain_notes/features/settings/domain/help_center_models.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

part 'help_center_provider.g.dart';

class HelpCenterState {
  const HelpCenterState({
    required this.expandedFaqIds,
    required this.selectedCategoryKey,
    required this.searchQuery,
    required this.showContactForm,
    required this.feedbackEmail,
    required this.feedbackMessage,
    required this.isSending,
  });

  final Set<String> expandedFaqIds;

  final String selectedCategoryKey;
  final String searchQuery;
  final bool showContactForm;
  final String feedbackEmail;
  final String feedbackMessage;
  final bool isSending;

  HelpCenterState copyWith({
    Set<String>? expandedFaqIds,
    String? selectedCategoryKey,
    String? searchQuery,
    bool? showContactForm,
    String? feedbackEmail,
    String? feedbackMessage,
    bool? isSending,
  }) {
    return HelpCenterState(
      expandedFaqIds: expandedFaqIds ?? this.expandedFaqIds,
      selectedCategoryKey: selectedCategoryKey ?? this.selectedCategoryKey,
      searchQuery: searchQuery ?? this.searchQuery,
      showContactForm: showContactForm ?? this.showContactForm,
      feedbackEmail: feedbackEmail ?? this.feedbackEmail,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      isSending: isSending ?? this.isSending,
    );
  }
}

@riverpod
class HelpCenterController extends _$HelpCenterController {
  @override
  HelpCenterState build() {
    return const HelpCenterState(
      expandedFaqIds: <String>{},
      selectedCategoryKey: HelpCenterCategoryKey.all,
      searchQuery: '',
      showContactForm: false,
      feedbackEmail: '',
      feedbackMessage: '',
      isSending: false,
    );
  }

  void toggleFaq(String id) {
    final next = <String>{...state.expandedFaqIds};
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = state.copyWith(expandedFaqIds: next);
  }

  void selectCategoryKey(String categoryKey) {
    state = state.copyWith(selectedCategoryKey: categoryKey);
  }

  void setSearchQuery(String q) {
    state = state.copyWith(searchQuery: q);
  }

  void showForm(bool v) {
    state = state.copyWith(showContactForm: v);
  }

  void setFeedbackEmail(String v) {
    state = state.copyWith(feedbackEmail: v);
  }

  void setFeedbackMessage(String v) {
    state = state.copyWith(feedbackMessage: v);
  }

  Future<bool> copySupportEmail() async {
    await Clipboard.setData(
      const ClipboardData(text: AppConstants.support),
    );
    return true;
  }

  Future<bool> sendFeedback(AppLocalizations l10n) async {
    if (state.isSending) return false;
    if (state.feedbackMessage.trim().isEmpty) return false;

    state = state.copyWith(isSending: true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      final subject = Uri.encodeComponent(l10n.helpFeedbackMailSubject);
      final body = Uri.encodeComponent(
        l10n.helpFeedbackMailBody(state.feedbackEmail, state.feedbackMessage),
      );
      final uri = Uri.parse(
        'mailto:${AppConstants.support}?subject=$subject&body=$body',
      );
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (ok) {
        state = state.copyWith(
          feedbackEmail: '',
          feedbackMessage: '',
          showContactForm: false,
        );
      }
      return ok;
    } finally {
      state = state.copyWith(isSending: false);
    }
  }
}

