import 'package:chain_notes/common/config/contract_config.dart';

class NftConfig {
  NftConfig._();

  static const Map<int, String> contractByChainId =
      ContractConfig.contractByChainId;

  static String? getContractAddress(int? chainId) {
    if (chainId == null) return null;
    final addr = contractByChainId[chainId];
    if (addr == null || addr == '0x0000000000000000000000000000000000000000') {
      return null;
    }
    return addr.startsWith('0x') ? addr : '0x$addr';
  }

  static List<int> get chainIdsWithContract => contractByChainId.entries
      .where(
        (e) =>
            e.value != '0x0000000000000000000000000000000000000000' &&
            e.value.isNotEmpty,
      )
      .map((e) => e.key)
      .toList();
}
