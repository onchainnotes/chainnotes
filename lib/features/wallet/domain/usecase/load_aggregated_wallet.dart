import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/repository/wallet_repository.dart';
import 'package:chain_notes/shared/result/result.dart';

class LoadAggregatedWallet {
  const LoadAggregatedWallet(this._repository);

  final WalletRepository _repository;

  Future<Result<AggregatedWallet>> call() => _repository.loadAggregatedWallet();
}
