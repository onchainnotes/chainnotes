

abstract interface class WalletApi {

  Future<Map<String, dynamic>?> fetchAggregatedWallet();

  Future<void> saveAggregatedWallet(Map<String, dynamic> data);
}

class WalletApiImpl implements WalletApi {
  Map<String, dynamic>? _cache;

  @override
  Future<Map<String, dynamic>?> fetchAggregatedWallet() async => _cache;

  @override
  Future<void> saveAggregatedWallet(Map<String, dynamic> data) async {
    _cache = Map<String, dynamic>.from(data);
  }
}
