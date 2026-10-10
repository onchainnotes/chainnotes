import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';

class NetworkRpcDefaultEntry {
  const NetworkRpcDefaultEntry({required this.name, required this.url});

  final String name;
  final String url;
}

const Map<String, List<NetworkRpcDefaultEntry>> kDefaultRpcPresets = {
  'ethereum': [
    NetworkRpcDefaultEntry(
      name: 'Infura',
      url: 'https://mainnet.infura.io/v3/YOUR-PROJECT-ID',
    ),
  ],
  'bsc': [
    NetworkRpcDefaultEntry(
      name: 'BSC Official',
      url: 'https://bsc-dataseed.binance.org/',
    ),
  ],
  'polygon': [
    NetworkRpcDefaultEntry(
      name: 'Polygon Official',
      url: 'https://polygon-rpc.com/',
    ),
  ],
  'arbitrum': [
    NetworkRpcDefaultEntry(
      name: 'Arbitrum Official',
      url: 'https://arb1.arbitrum.io/rpc',
    ),
  ],
  'optimism': [
    NetworkRpcDefaultEntry(
      name: 'Optimism Official',
      url: 'https://mainnet.optimism.io',
    ),
  ],
  'avalanche': [
    NetworkRpcDefaultEntry(
      name: 'Avalanche Official',
      url: 'https://api.avax.network/ext/bc/C/rpc',
    ),
  ],
  'fantom': [
    NetworkRpcDefaultEntry(
      name: 'Fantom Official',
      url: 'https://rpc.ftm.tools/',
    ),
  ],
  'base': [
    NetworkRpcDefaultEntry(
      name: 'Base Official',
      url: 'https://mainnet.base.org',
    ),
  ],
};

Chain? chainByNetworkSettingsId(String chainId) {
  for (final c in ChainFromDemo.mainnetChains) {
    if (c.id == chainId) return c;
  }
  for (final c in ChainFromDemo.testnetChains) {
    if (c.id == chainId) return c;
  }
  return null;
}
