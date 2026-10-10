import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/app/theme/app_theme_data.dart';
import 'package:chain_notes/features/settings/application/app_locale_provider.dart';
import 'package:chain_notes/app/theme/theme_mode_provider.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
          DeviceOrientation.portraitUp,
        ]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);
    final languageCode = ref.watch(appLanguageProvider);
    return MaterialApp.router(
      title: 'ChainNotes',
      theme: AppThemeData.light,
      darkTheme: AppThemeData.dark,
      themeMode: themeMode,
      locale: materialLocaleForLanguageCode(languageCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
