import 'package:flutter/material.dart';
import 'package:chain_notes/app/theme/app_design_tokens.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';

class AppThemeData {
  AppThemeData._();

  static const double _text2xl = 24.0;
  static const double _textXl = 20.0;
  static const double _textLg = 18.0;
  static const double _textBase = 16.0;

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: null,
      colorScheme: ColorScheme.light(
        surface: AppDesignTokens.lightBackground,
        onSurface: AppDesignTokens.lightForeground,
        primary: AppDesignTokens.lightPrimary,
        onPrimary: AppDesignTokens.lightPrimaryForeground,
        secondary: AppDesignTokens.lightSecondary,
        onSecondary: AppDesignTokens.lightSecondaryForeground,
        tertiary: AppDesignTokens.lightMuted,
        onTertiary: AppDesignTokens.lightMutedForeground,
        error: AppDesignTokens.lightDestructive,
        onError: AppDesignTokens.lightDestructiveForeground,
        outline: AppDesignTokens.lightBorder,
        surfaceContainerHighest: AppDesignTokens.lightMuted,
      ),
      scaffoldBackgroundColor: AppDesignTokens.lightBackground,
      cardColor: AppDesignTokens.lightCard,
      extensions: const <ThemeExtension<dynamic>>[
        AppBrandTheme.light,
      ],
      cardTheme: CardThemeData(
        color: AppDesignTokens.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppDesignTokens.lightBackground,
        foregroundColor: AppDesignTokens.lightForeground,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppDesignTokens.lightInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          borderSide: const BorderSide(color: AppDesignTokens.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          borderSide: const BorderSide(color: AppDesignTokens.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          borderSide: const BorderSide(color: AppDesignTokens.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          borderSide: const BorderSide(color: AppDesignTokens.lightDestructive),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesignTokens.lightPrimary,
          foregroundColor: AppDesignTokens.lightPrimaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppDesignTokens.lightPrimary,
          side: const BorderSide(color: AppDesignTokens.lightBorder),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          ),
        ),
      ),
      textTheme: _textTheme(AppDesignTokens.lightForeground),
      dividerColor: AppDesignTokens.lightBorder,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: null,
      colorScheme: ColorScheme.dark(
        surface: AppDesignTokens.darkBackground,
        onSurface: AppDesignTokens.darkForeground,
        primary: AppDesignTokens.darkPrimary,
        onPrimary: AppDesignTokens.darkPrimaryForeground,
        secondary: AppDesignTokens.darkSecondary,
        onSecondary: AppDesignTokens.darkSecondaryForeground,
        tertiary: AppDesignTokens.darkMuted,
        onTertiary: AppDesignTokens.darkMutedForeground,
        error: AppDesignTokens.darkDestructive,
        onError: AppDesignTokens.darkDestructiveForeground,
        outline: AppDesignTokens.darkBorder,
        outlineVariant: AppDesignTokens.darkBorder,
        surfaceContainerHighest: AppDesignTokens.darkMuted,
      ),
      scaffoldBackgroundColor: AppDesignTokens.darkBackground,
      cardColor: AppDesignTokens.darkCard,
      extensions: const <ThemeExtension<dynamic>>[
        AppBrandTheme.dark,
      ],
      cardTheme: CardThemeData(
        color: AppDesignTokens.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppDesignTokens.darkBackground,
        foregroundColor: AppDesignTokens.darkForeground,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppDesignTokens.darkInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          borderSide: const BorderSide(color: AppDesignTokens.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          borderSide: const BorderSide(color: AppDesignTokens.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          borderSide: const BorderSide(color: AppDesignTokens.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          borderSide: const BorderSide(color: AppDesignTokens.darkDestructive),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesignTokens.darkPrimary,
          foregroundColor: AppDesignTokens.darkPrimaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppDesignTokens.darkPrimary,
          side: const BorderSide(color: AppDesignTokens.darkBorder),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusLg),
          ),
        ),
      ),
      textTheme: _textTheme(AppDesignTokens.darkForeground),
      dividerColor: AppDesignTokens.darkBorder,
    );
  }

  static TextTheme _textTheme(Color foreground) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: _text2xl,
        fontWeight: AppDesignTokens.fontWeightMedium,
        height: 1.5,
        color: foreground,
      ),
      displayMedium: TextStyle(
        fontSize: _textXl,
        fontWeight: AppDesignTokens.fontWeightMedium,
        height: 1.5,
        color: foreground,
      ),
      displaySmall: TextStyle(
        fontSize: _textLg,
        fontWeight: AppDesignTokens.fontWeightMedium,
        height: 1.5,
        color: foreground,
      ),
      headlineMedium: TextStyle(
        fontSize: _textBase,
        fontWeight: AppDesignTokens.fontWeightMedium,
        height: 1.5,
        color: foreground,
      ),
      bodyLarge: TextStyle(
        fontSize: _textBase,
        fontWeight: AppDesignTokens.fontWeightNormal,
        height: 1.5,
        color: foreground,
      ),
      bodyMedium: TextStyle(
        fontSize: AppDesignTokens.fontSize,
        fontWeight: AppDesignTokens.fontWeightNormal,
        height: 1.5,
        color: foreground,
      ),
      labelLarge: TextStyle(
        fontSize: _textBase,
        fontWeight: AppDesignTokens.fontWeightMedium,
        height: 1.5,
        color: foreground,
      ),
    );
  }
}
