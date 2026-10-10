

enum WalletStatus { idle, loading, success, error }

class WalletState {
  const WalletState({this.status = WalletStatus.idle, this.errorMessage});

  final WalletStatus status;
  final String? errorMessage;
}
