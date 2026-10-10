import 'dart:async';

import 'package:chain_notes/common/config/admob_config.dart';
import 'package:chain_notes/features/home/data/datasource/realm/note_realm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';

abstract final class AppBootstrap {
  static Future<void>? _future;

  static Future<void> ensureStarted() =>
      _future ??= _run();

  static Future<void> _run() async {

    await NoteRealmManager.instance.open();

    FlutterTrustWalletCore.init();

    unawaited(
      AdmobConfig.initialize().catchError((Object error, StackTrace stackTrace) {
        debugPrint('AdMob initialize failed: $error');
      }),
    );
  }
}
