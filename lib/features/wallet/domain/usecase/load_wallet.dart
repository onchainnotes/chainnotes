import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';
import 'package:chain_notes/features/wallet/domain/repository/wallet_repository.dart';
import 'package:chain_notes/shared/result/result.dart';

class LoadWallet {
  const LoadWallet(this._repository);

  final WalletRepository _repository;

  Future<Result<Wallet?>> call() => _repository.loadWallet();
}
