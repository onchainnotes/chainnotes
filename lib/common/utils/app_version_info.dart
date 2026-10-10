import 'package:chain_notes/common/constants/app_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract final class AppVersionInfo {
  static PackageInfo? _packageInfo;

  static Future<void> ensureInitialized() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
  }

  static PackageInfo get _info {
    final p = _packageInfo;
    if (p == null) {
      throw StateError(
        'AppVersionInfo.ensureInitialized() must run before any UI uses version text.',
      );
    }
    return p;
  }

  static String get version => _info.version;

  static String get buildNumber => _info.buildNumber;

  static String get releaseDate => AppConstants.releaseDate;

  static const String copyrightYear = '2026';
}
