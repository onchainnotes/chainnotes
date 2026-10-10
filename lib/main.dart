import 'package:chain_notes/common/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chain_notes/app/app.dart';

import 'package:chain_notes/common/utils/app_version_info.dart';
import 'package:chain_notes/utils/app_init.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppVersionInfo.ensureInitialized();

  AppInit.init();

  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = AppConstants.sentryDsn;
        options.sendDefaultPii = false;
        options.enableLogs = true;
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 0.0;
        options.replay.sessionSampleRate = 0.0;
        options.replay.onErrorSampleRate = 0.0;
      },
      appRunner: () =>
          runApp(SentryWidget(child: const ProviderScope(child: App()))),
    );
  } else {
    runApp(const ProviderScope(child: App()));
  }
}
