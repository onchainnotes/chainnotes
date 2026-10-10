import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';
import 'package:chain_notes/shared/result/result.dart';

abstract interface class WalletRepository {

  Future<Result<AggregatedWallet>> loadAggregatedWallet();

  Future<Result<void>> saveAggregatedWallet(AggregatedWallet aggregated);

  Future<Result<Wallet?>> loadWallet();

  Future<Result<Wallet>> importByMnemonic(List<String> words, int length);

  Future<Result<Wallet>> importByPrivateKey(String privateKey);
}
