import 'package:flutter/material.dart';
import 'package:chain_notes/features/settings/domain/language_models.dart';
import 'package:chain_notes/shared/preference_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_locale_provider.g.dart';

Locale materialLocaleForLanguageCode(String code) {
  switch (code) {
    case 'en':
      return const Locale('en');
    case 'zh-TW':
      return const Locale('zh', 'TW');
    case 'zh-CN':
    case 'zh':
      return const Locale('zh');
    case 'ja':
      return const Locale('ja');
    case 'ko':
      return const Locale('ko');
    default:
      return const Locale('en');
  }
}

@riverpod
class AppLanguage extends _$AppLanguage {
  static final _prefKey = PreferenceKeys.appLanguageCode;

  @override
  String build() {
    Future.microtask(_restoreFromPrefs);
    return LanguageCatalog.defaultCode;
  }

  Future<void> _restoreFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw == null || raw.isEmpty) return;
    if (LanguageCatalog.tryFind(raw) == null) return;
    if (!LanguageCatalog.isImplemented(raw)) {
      state = LanguageCatalog.defaultCode;
      await prefs.setString(_prefKey, LanguageCatalog.defaultCode);
      return;
    }
    state = raw;
  }

  Future<void> setLanguageCode(String code) async {
    if (LanguageCatalog.tryFind(code) == null) return;
    if (!LanguageCatalog.isImplemented(code)) return;
    state = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, code);
  }
}
