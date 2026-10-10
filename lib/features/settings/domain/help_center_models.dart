import 'package:flutter/material.dart';

@immutable
class HelpCenterFaqItem {
  const HelpCenterFaqItem({
    required this.id,
    required this.categoryKey,
    required this.category,
    required this.question,
    required this.answer,
    required this.icon,
  });

  final String id;

  final String categoryKey;
  final String category;
  final String question;
  final String answer;
  final IconData icon;
}

abstract final class HelpCenterCategoryKey {
  HelpCenterCategoryKey._();

  static const String all = 'all';
  static const String basics = 'basics';
  static const String blockchain = 'blockchain';
  static const String walletSecurity = 'walletSecurity';
  static const String walletMgmt = 'walletMgmt';
  static const String advanced = 'advanced';
  static const String common = 'common';
}

@immutable
class HelpCenterQuickGuide {
  const HelpCenterQuickGuide({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;
}

