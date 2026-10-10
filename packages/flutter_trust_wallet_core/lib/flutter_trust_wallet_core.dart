library flutter_trust_wallet_core;

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'trust_wallet_core_ffi.dart';

part 'extensions.dart';

part 'core/mnemonic.dart';
part 'core/hd_wallet.dart';
part 'core/private_key.dart';
part 'core/public_key.dart';
part 'core/stored_key.dart';
part 'core/any_address.dart';
part 'core/base58.dart';
part 'core/hash.dart';
part 'core/bitcoin_address.dart';
part 'core/any_signer.dart';
part 'core/bitcoin_script.dart';
part 'core/ripple_x_address.dart';
part 'core/segwit_address.dart';
part 'core/solana_address.dart';
part 'core/hd_version.dart';
part 'core/groestlcoin_address.dart';
part 'core/fio_account.dart';
part 'core/ethereum_abi.dart';
part 'core/ethereum_abi_value.dart';
part 'core/coin_type_configuration.dart';
part 'core/ethereum_abi_function.dart';
part 'core/hrp.dart';

class FlutterTrustWalletCore {
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    walletCoreLib = _openWalletCoreLibrary();
    _assertWalletCoreLoaded();
    _initialized = true;
  }

  static DynamicLibrary _openWalletCoreLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libTrustWalletCore.so');
    }
    if (Platform.isIOS || Platform.isMacOS) {
      _tryOpenIosDependencyFramework('SwiftProtobuf.framework/SwiftProtobuf');
      final paths = <String>[
        'WalletCore.framework/WalletCore',
        '@rpath/WalletCore.framework/WalletCore',
        'Frameworks/WalletCore.framework/WalletCore',
      ];
      for (final path in paths) {
        try {
          return DynamicLibrary.open(path);
        } catch (_) {}
      }
      // Static linkage: symbols live in the app executable after WalletCoreForceLink.m.
      try {
        return DynamicLibrary.executable();
      } catch (_) {
        return DynamicLibrary.process();
      }
    }
    return DynamicLibrary.process();
  }

  static void _tryOpenIosDependencyFramework(String path) {
    try {
      DynamicLibrary.open(path);
    } catch (_) {
      try {
        DynamicLibrary.open('@rpath/$path');
      } catch (_) {}
    }
  }

  static void _assertWalletCoreLoaded() {
    try {
      walletCoreLib.lookup('TWStringCreateWithUTF8Bytes');
    } catch (_) {
      throw StateError(
        'Trust Wallet Core native library is not linked. '
        'iOS: run `cd ios && pod install` (plugin uses CocoaPods TrustWalletCore when '
        'packages/flutter_trust_wallet_core/ios/Frameworks/*.xcframework is absent), or place '
        'WalletCore.xcframework and SwiftProtobuf.xcframework under ios/Frameworks/. '
        'Android: add packages/flutter_trust_wallet_core/android/libs/trustwalletcore-release.aar.',
      );
    }
  }
}
