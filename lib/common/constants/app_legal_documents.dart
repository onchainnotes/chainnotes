import 'package:chain_notes/common/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// [AppConstants.termsOfServiceLastUpdated]、
/// [AppConstants.termsOfServiceVersionSemantic]）。
abstract final class AppLegalDocuments {
  AppLegalDocuments._();

  static DateTime get lastUpdated => AppConstants.termsOfServiceLastUpdated;

  static String get versionSemantic =>
      AppConstants.termsOfServiceVersionSemantic;

  static String lastUpdatedDisplay(Locale locale) {
    final lang = locale.languageCode;
    if (lang == 'zh') {
      return DateFormat('y年M月d日', 'zh_CN').format(lastUpdated);
    }
    if (lang == 'ja') {
      return DateFormat('y年M月d日', 'ja').format(lastUpdated);
    }
    if (lang == 'ko') {
      return DateFormat('y년 M월 d일', 'ko').format(lastUpdated);
    }
    return DateFormat.yMMMMd(locale.toLanguageTag()).format(lastUpdated);
  }

  static String versionBadgeDisplay(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return '版本 $versionSemantic';
      case 'ja':
        return 'バージョン $versionSemantic';
      case 'ko':
        return '버전 $versionSemantic';
      default:
        return 'Version $versionSemantic';
    }
  }
}
