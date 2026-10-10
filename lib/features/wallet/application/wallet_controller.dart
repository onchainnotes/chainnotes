import 'package:chain_notes/features/wallet/domain/usecase/load_wallet.dart';

class WalletController {
  WalletController(this._loadWallet);

  final LoadWallet _loadWallet;

  Future<void> load() async {
    final result = await _loadWallet();

  }
}
