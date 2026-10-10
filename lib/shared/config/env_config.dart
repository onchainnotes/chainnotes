import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:chain_notes/shared/config/firebase_options_config.dart';

class EnvConfig {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return DefaultFirebaseOptions.android;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return DefaultFirebaseOptions.ios;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      );
    }
  }

  /// iOS Firebase 会在原生层校验 API Key：长度必须是 39，以 A 开头，
  /// 且只能包含字母、数字、`-`、`_`。格式不对时进程会直接退出。
  static bool get hasUsableFirebaseApiKey {
    final FirebaseOptions options;
    try {
      options = currentPlatform;
    } catch (_) {
      return false;
    }
    final key = options.apiKey;
    if (key.length != 39 || !key.startsWith('A')) return false;
    return RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(key);
  }

  static String get firebaseName {
    var platform = kIsWeb
        ? 'on-chain-notes-web'
        : defaultTargetPlatform == TargetPlatform.android
        ? 'on-chain-notes-android'
        : defaultTargetPlatform == TargetPlatform.iOS
        ? 'on-chain-notes-ios'
        : 'unknown';
    return platform;
  }
}
