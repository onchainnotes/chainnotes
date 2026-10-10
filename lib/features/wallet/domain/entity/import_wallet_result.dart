import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';

sealed class ImportWalletResult {
  const ImportWalletResult();
}

final class ImportWalletSuccess extends ImportWalletResult {
  const ImportWalletSuccess(this.wallet);
  final AggregatedWallet wallet;
}

final class ImportWalletDuplicate extends ImportWalletResult {
  const ImportWalletDuplicate();
}

final class ImportWalletInvalidMnemonic extends ImportWalletResult {
  const ImportWalletInvalidMnemonic();
}

final class ImportWalletInvalidPrivateKey extends ImportWalletResult {
  const ImportWalletInvalidPrivateKey();
}
