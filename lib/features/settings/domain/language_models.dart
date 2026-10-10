import 'package:flutter/foundation.dart';

@immutable
class LanguageOption {
  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
  });

  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;
}

abstract final class LanguageCatalog {
  static const String defaultCode = 'en';

  static const Set<String> implementedCodes = <String>{
    'zh-CN',
    'zh-TW',
    'en',
    'ja',
    'ko',
  };

  static bool isImplemented(String code) => implementedCodes.contains(code);

  static List<LanguageOption> get settingsPickerOptions =>
      [for (final o in all) if (isImplemented(o.code)) o];

  static const List<LanguageOption> all = <LanguageOption>[
    LanguageOption(
      code: 'zh-CN',
      name: 'Chinese (Simplified)',
      nativeName: '简体中文',
      flagEmoji: '🇨🇳',
    ),
    LanguageOption(
      code: 'zh-TW',
      name: 'Chinese (Traditional)',
      nativeName: '繁體中文',
      flagEmoji: '🇭🇰',
    ),
    LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flagEmoji: '🇺🇸',
    ),
    LanguageOption(
      code: 'ja',
      name: 'Japanese',
      nativeName: '日本語',
      flagEmoji: '🇯🇵',
    ),
    LanguageOption(
      code: 'ko',
      name: 'Korean',
      nativeName: '한국어',
      flagEmoji: '🇰🇷',
    ),
    LanguageOption(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      flagEmoji: '🇪🇸',
    ),
    LanguageOption(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flagEmoji: '🇫🇷',
    ),
    LanguageOption(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      flagEmoji: '🇩🇪',
    ),
    LanguageOption(
      code: 'ru',
      name: 'Russian',
      nativeName: 'Русский',
      flagEmoji: '🇷🇺',
    ),
    LanguageOption(
      code: 'pt',
      name: 'Portuguese',
      nativeName: 'Português',
      flagEmoji: '🇵🇹',
    ),
    LanguageOption(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flagEmoji: '🇸🇦',
    ),
    LanguageOption(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      flagEmoji: '🇮🇳',
    ),
  ];

  static LanguageOption? tryFind(String code) {
    for (final option in all) {
      if (option.code == code) return option;
    }
    return null;
  }

  static LanguageOption optionForCode(String code) =>
      tryFind(code) ?? tryFind(defaultCode)!;
}
