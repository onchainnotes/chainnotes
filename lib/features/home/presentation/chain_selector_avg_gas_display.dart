import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

String localizedAvgGasCostForSelector(Chain chain, AppLocalizations l10n) {
  final r = chain.avgGasCost.trim();
  if (r.isEmpty) return '-';
  final lower = r.toLowerCase();
  if (r == '中等' || lower == 'medium') {
    return l10n.chainGasCostLevelMedium;
  }
  if (r == '测试网' || lower == 'testnet') {
    return l10n.chainSelectorTestnetTab;
  }
  return r;
}
