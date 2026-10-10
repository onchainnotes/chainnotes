import 'dart:math';

import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:chain_notes/common/datasource/chain_datas.dart';
import 'package:chain_notes/features/wallet/data/datasource/wallet_api.dart';
import 'package:chain_notes/features/wallet/data/mapper/aggregated_wallet_mapper.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain_type.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';
import 'package:chain_notes/features/wallet/domain/repository/wallet_repository.dart';
import 'package:chain_notes/shared/result/result.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._api);

  final WalletApi _api;
  static final _random = Random();

  static String _newId() =>
      'w_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(0x7FFFFFFF).toRadixString(16)}';

  @override
  Future<Result<AggregatedWallet>> loadAggregatedWallet() async {
    try {
      final data = await _api.fetchAggregatedWallet();
      if (data == null) {
        return Success(AggregatedWallet(wallets: [], walletType: WalletType.created));
      }
      return Success(AggregatedWalletMapper.fromMap(data));
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<void>> saveAggregatedWallet(AggregatedWallet aggregated) async {
    try {
      await _api.saveAggregatedWallet(AggregatedWalletMapper.toMap(aggregated));
      return const Success(null);
    } catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<Wallet?>> loadWallet() async {
    final res = await loadAggregatedWallet();
    if (res is Failure<AggregatedWallet>) return Failure(res.error);
    return Success((res as Success<AggregatedWallet>).value.currentWallet);
  }

  @override
  Future<Result<Wallet>> importByMnemonic(
    List<String> words,
    int length,
  ) async {
    final raw = words.join(' ');

    final mnemonic = _normalizeMnemonicBip39(raw);
    if (!Mnemonic.isValid(mnemonic)) {
      return Failure(Exception('无效的恢复短语'));
    }
    try {
      final hdWallet = HDWallet.createWithMnemonic(mnemonic);
      try {
        final wallets = _deriveWalletsFromHd(hdWallet, WalletType.importedMnemonic);
        if (wallets.isEmpty) {
          return Failure(Exception('未能从恢复短语派生任何链的笔记账户'));
        }
        return _addWalletsAndSave(wallets);
      } finally {
        hdWallet.delete();
      }
    } catch (e) {
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<Wallet>> importByPrivateKey(String privateKey) async {

    final id = _newId();
    final now = DateTime.now().millisecondsSinceEpoch;
    final wallet = Wallet(
      id: id,
      address: _placeholderAddress([privateKey]),
      type: WalletType.importedPrivateKey,
      chainType: ChainType.evm,
      createdAt: now,
      updatedAt: now,
    );
    return _addWalletAndSave(wallet);
  }

  Future<Result<Wallet>> _addWalletAndSave(Wallet wallet) async {
    final res = await loadAggregatedWallet();
    if (res is Failure<AggregatedWallet>) return Failure(res.error);
    final aggregated = (res as Success<AggregatedWallet>).value;
    final next = aggregated.addWallet(wallet, setAsCurrent: true);
    final saveRes = await saveAggregatedWallet(next);
    if (saveRes is Failure<void>) return Failure(saveRes.error);
    return Success(wallet);
  }

  Future<Result<Wallet>> _addWalletsAndSave(List<Wallet> wallets) async {
    final res = await loadAggregatedWallet();
    if (res is Failure<AggregatedWallet>) return Failure(res.error);
    AggregatedWallet aggregated = (res as Success<AggregatedWallet>).value;
    for (var i = 0; i < wallets.length; i++) {
      aggregated = aggregated.addWallet(wallets[i], setAsCurrent: i == 0);
    }
    final saveRes = await saveAggregatedWallet(aggregated);
    if (saveRes is Failure<void>) return Failure(saveRes.error);
    return Success(wallets.first);
  }

  List<Wallet> _deriveWalletsFromHd(HDWallet hdWallet, WalletType type) {
    final chainDataMap = ChainDatas.demoChainInfoList as Map<String, dynamic>;
    final dataMap = chainDataMap['data'] as Map<String, dynamic>;
    final chainList = dataMap['list'] as List<dynamic>;
    final now = DateTime.now().millisecondsSinceEpoch;
    final walletsByChainType = <String, List<Protocol>>{};

    for (final chainInfo in chainList) {
      final walletCoreCoinType = chainInfo['wallet_core_coin_type'] as int;
      final chainType = chainInfo['chain_type'] as String;
      final chainId = chainInfo['chain_id'] as int;
      try {
        final address = hdWallet.getAddressForCoin(walletCoreCoinType);
        final privateKey = hdWallet.getKeyForCoin(walletCoreCoinType);
        final curve = _getCurveForCoinType(walletCoreCoinType);
        final publicKey = privateKey.getPublicKey(curve);
        final publicKeyBytes = publicKey.data();
        final publicKeyHex = publicKeyBytes
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join();

        final derivationPathPtr =
            TWCoinType.TWCoinTypeDerivationPath(walletCoreCoinType);
        final derivationPath = TWStringImpl.toDartString(derivationPathPtr);
        TWStringImpl.delete(derivationPathPtr);

        final protocol = Protocol(
          publicKeyHex: publicKeyHex,
          address: address,
          derivationPath: derivationPath,
          walletCoreCoinType: walletCoreCoinType,
          protocolType: chainId,
        );

        walletsByChainType.putIfAbsent(chainType, () => []).add(protocol);
      } catch (_) {
        continue;
      }
    }

    final wallets = <Wallet>[];
    for (final entry in walletsByChainType.entries) {
      final chainTypeStr = entry.key;
      final chainProtocols = entry.value;
      final chainType = _getChainTypeFromString(chainTypeStr);
      final primaryProtocol = chainProtocols.first;
      final walletId =
          'wallet_${primaryProtocol.address.substring(0, 10)}_$now';

      wallets.add(Wallet(
        id: walletId,
        address: primaryProtocol.address,
        type: type,
        chainType: chainType,
        createdAt: now,
        updatedAt: now,
        walletCoreCoinType: primaryProtocol.walletCoreCoinType,
        defaultPublicKey: primaryProtocol.publicKeyHex,
        defaultAddress: primaryProtocol.address,
        derivationPath: primaryProtocol.derivationPath,
        protocolAccounts: chainProtocols,
      ));
    }
    return wallets;
  }

  static int _getCurveForCoinType(int walletCoreCoinType) {
    if (walletCoreCoinType == TWCoinType.TWCoinTypeSolana) {
      return TWCurve.TWCurveED25519;
    }
    return TWCurve.TWCurveSECP256k1;
  }

  static ChainType _getChainTypeFromString(String chainTypeStr) {
    if (chainTypeStr == 'Ethereum') return ChainType.evm;
    if (chainTypeStr == 'Bitcoin') return ChainType.btc;
    return ChainType.other;
  }

  static String _normalizeMnemonicBip39(String mnemonic) {
    if (mnemonic.isEmpty) return mnemonic;
    return unorm.nfkd(
      mnemonic.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' '),
    );
  }

  static String _placeholderAddress(List<Object> seed) {

    final raw = seed.join('');
    final hash = raw.hashCode.abs().toRadixString(16).padLeft(10, '0');
    return '0x$hash${hash.split('').reversed.join('').substring(0, 24)}';
  }
}
