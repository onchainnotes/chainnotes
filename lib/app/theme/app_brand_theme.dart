import 'package:flutter/material.dart';

@immutable
class AppBrandTheme extends ThemeExtension<AppBrandTheme> {
  const AppBrandTheme({
    required this.pageBackground,
    required this.settingsBackground,
    required this.settingsHeaderGradient,
    required this.settingsAccent,
    required this.settingsAccentSoft,
    required this.onSettingsHeader,
    required this.onSettingsHeaderSoft,
  });

  final Color settingsBackground;

  final Color pageBackground;

  final Gradient settingsHeaderGradient;

  final Color settingsAccent;

  final Color settingsAccentSoft;

  final Color onSettingsHeader;

  final Color onSettingsHeaderSoft;

  static const AppBrandTheme light = AppBrandTheme(
    pageBackground: Color(0xFFf9fafb),
    settingsBackground: Color(0xFFf0fdf4),
    settingsHeaderGradient: LinearGradient(
      colors: [Color(0xFF059669), Color(0xFF0d9488)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    settingsAccent: Color(0xFF059669),
    settingsAccentSoft: Color(0xFFdcfce7),
    onSettingsHeader: Colors.white,
    onSettingsHeaderSoft: Color(0xFFD1FAE5),
  );

  static const AppBrandTheme dark = AppBrandTheme(
    pageBackground: Color(0xFF121212),
    settingsBackground: Color(0xFF0b1220),
    settingsHeaderGradient: LinearGradient(
      colors: [Color(0xFF065f46), Color(0xFF115e59)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    settingsAccent: Color(0xFF34d399),
    settingsAccentSoft: Color(0xFF064e3b),
    onSettingsHeader: Colors.white,
    onSettingsHeaderSoft: Color(0xFFa7f3d0),
  );

  @override
  AppBrandTheme copyWith({
    Color? pageBackground,
    Color? settingsBackground,
    Gradient? settingsHeaderGradient,
    Color? settingsAccent,
    Color? settingsAccentSoft,
    Color? onSettingsHeader,
    Color? onSettingsHeaderSoft,
  }) {
    return AppBrandTheme(
      pageBackground: pageBackground ?? this.pageBackground,
      settingsBackground: settingsBackground ?? this.settingsBackground,
      settingsHeaderGradient: settingsHeaderGradient ?? this.settingsHeaderGradient,
      settingsAccent: settingsAccent ?? this.settingsAccent,
      settingsAccentSoft: settingsAccentSoft ?? this.settingsAccentSoft,
      onSettingsHeader: onSettingsHeader ?? this.onSettingsHeader,
      onSettingsHeaderSoft: onSettingsHeaderSoft ?? this.onSettingsHeaderSoft,
    );
  }

  @override
  AppBrandTheme lerp(ThemeExtension<AppBrandTheme>? other, double t) {
    if (other is! AppBrandTheme) return this;
    return AppBrandTheme(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      settingsBackground: Color.lerp(settingsBackground, other.settingsBackground, t)!,
      settingsHeaderGradient:
          _lerpGradient(settingsHeaderGradient, other.settingsHeaderGradient, t),
      settingsAccent: Color.lerp(settingsAccent, other.settingsAccent, t)!,
      settingsAccentSoft: Color.lerp(settingsAccentSoft, other.settingsAccentSoft, t)!,
      onSettingsHeader: Color.lerp(onSettingsHeader, other.onSettingsHeader, t)!,
      onSettingsHeaderSoft:
          Color.lerp(onSettingsHeaderSoft, other.onSettingsHeaderSoft, t)!,
    );
  }
}

Gradient _lerpGradient(Gradient a, Gradient b, double t) {
  if (a is LinearGradient && b is LinearGradient) {
    return LinearGradient(
      begin: t < 0.5 ? a.begin : b.begin,
      end: t < 0.5 ? a.end : b.end,
      colors: <Color>[
        Color.lerp(a.colors.first, b.colors.first, t)!,
        Color.lerp(a.colors.last, b.colors.last, t)!,
      ],
    );
  }
  return t < 0.5 ? a : b;
}

