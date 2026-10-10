import 'package:chain_notes/common/config/app_distribution_links.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

void shareAppInvite(AppLocalizations l10n) {
  Share.share(
    l10n.profileShareMessage(AppDistributionLinks.googlePlayStoreUrl),
  );
}
