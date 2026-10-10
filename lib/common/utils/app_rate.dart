import 'package:flutter/foundation.dart';
import 'package:chain_notes/common/config/app_distribution_links.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> rateUs() async {
  if (kIsWeb) return;
  if (defaultTargetPlatform != TargetPlatform.android) return;
  final uri = Uri.parse(AppDistributionLinks.googlePlayStoreUrl);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

