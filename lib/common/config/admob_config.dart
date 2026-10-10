import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobConfig {
  AdmobConfig._();

  static const AdRequest request = AdRequest(nonPersonalizedAds: true);

  static Future<void> initialize() => MobileAds.instance.initialize();

  static const String _prodHomeBannerAdUnitId = '{sensitive information}';

  static const String _testHomeBannerAdUnitId =
      'ca-app-pub-3940256099942544/9214589741';

  static String get homeBannerAdUnitId =>
      kReleaseMode ? _prodHomeBannerAdUnitId : _testHomeBannerAdUnitId;
}
