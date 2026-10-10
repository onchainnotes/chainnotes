import 'package:flutter/material.dart';

class AppDesignTokens {
  AppDesignTokens._();

  static const double fontSize = 14.0; // --font-size: 14px
  static const FontWeight fontWeightMedium = FontWeight.w500; // 500
  static const FontWeight fontWeightNormal = FontWeight.w400; // 400

  static const double radius = 10.0; // --radius: 0.625rem ≈ 10px
  static double get radiusSm => radius - 4; // --radius-sm
  static double get radiusMd => radius - 2; // --radius-md
  static double get radiusLg => radius; // --radius-lg
  static double get radiusXl => radius + 4; // --radius-xl

  static const Color lightBackground = Color(0xFFFFFFFF); // --background
  static const Color lightForeground = Color(0xFF252525);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardForeground = Color(0xFF252525);
  static const Color lightPopover = Color(0xFFFFFFFF);
  static const Color lightPopoverForeground = Color(0xFF252525);
  static const Color lightPrimary = Color(0xFF030213); // --primary
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFFE8E9F5);
  static const Color lightSecondaryForeground = Color(0xFF030213);
  static const Color lightMuted = Color(0xFFECECF0); // --muted
  static const Color lightMutedForeground = Color(0xFF717182); // --muted-foreground
  static const Color lightAccent = Color(0xFFE9EBEF); // --accent
  static const Color lightAccentForeground = Color(0xFF030213);
  static const Color lightDestructive = Color(0xFFD4183D); // --destructive
  static const Color lightDestructiveForeground = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0x1A000000);

  static const Color lightCardSubtleBorder = Color(0xFFe5e7eb);
  static const Color lightInput = Colors.transparent;
  static const Color lightInputBackground = Color(0xFFF3F3F5); // --input-background
  static const Color lightSwitchBackground = Color(0xFFCBCED4); // --switch-background
  static const Color lightRing = Color(0xFFB5B5B5);

  static const Color darkBackground = Color(0xFF252525);
  static const Color darkForeground = Color(0xFFFAFAFA);
  static const Color darkCard = Color(0xFF252525);
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  static const Color darkPopover = Color(0xFF252525);
  static const Color darkPopoverForeground = Color(0xFFFAFAFA);
  static const Color darkPrimary = Color(0xFFFAFAFA);
  static const Color darkPrimaryForeground = Color(0xFF343434);
  static const Color darkSecondary = Color(0xFF454545);
  static const Color darkSecondaryForeground = Color(0xFFFAFAFA);
  static const Color darkMuted = Color(0xFF454545);
  static const Color darkMutedForeground = Color(0xFFB5B5B5);
  static const Color darkAccent = Color(0xFF454545);
  static const Color darkAccentForeground = Color(0xFFFAFAFA);
  static const Color darkDestructive = Color(0xFFB82E3D);
  static const Color darkDestructiveForeground = Color(0xFFD45A5A);
  static const Color darkBorder = Color(0xFF454545);
  static const Color darkInput = Color(0xFF454545);
  static const Color darkRing = Color(0xFF707070);
}
