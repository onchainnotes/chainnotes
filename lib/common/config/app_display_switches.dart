
abstract final class AppDisplaySwitches {

  static const bool showFiatUsdValues = false;

  static const bool showHomeGetGasEntry = false;

  static String walletFiatBalanceLabel(double totalAmountUsd) {
    if (!showFiatUsdValues) return '—';
    return '\$${totalAmountUsd.toStringAsFixed(2)}';
  }

  static String displayStoredWalletBalance(String balance) {
    if (!showFiatUsdValues) return '—';
    return balance;
  }
}
