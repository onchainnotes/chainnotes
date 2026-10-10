import 'package:chain_notes/generated/l10n/app_localizations.dart';

String chainLocalizedName(AppLocalizations l10n, String chainId) {
  switch (chainId) {
    case 'evm':
      return l10n.chainNameEvm;
    case 'bitcoin':
      return l10n.chainNameBitcoin;
    case 'solana':
      return l10n.chainNameSolana;
    case 'tron':
      return l10n.chainNameTron;
    case 'cosmos':
      return l10n.chainNameCosmos;
    default:
      return chainId;
  }
}

String chainLocalizedPkDescription(AppLocalizations l10n, String chainId) {
  switch (chainId) {
    case 'evm':
      return l10n.chainPkDescEvm;
    case 'bitcoin':
      return l10n.chainPkDescBitcoin;
    case 'solana':
      return l10n.chainPkDescSolana;
    case 'tron':
      return l10n.chainPkDescTronHex;
    case 'cosmos':
      return l10n.chainPkDescCosmosHex;
    default:
      return '';
  }
}
