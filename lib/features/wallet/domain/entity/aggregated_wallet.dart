import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';

class AggregatedWallet {
  AggregatedWallet({
    required this.wallets,
    this.currentWalletId,
    this.updatedAt,
    this.id,
    this.walletIndex,
    this.walletName,
    required this.walletType,
    this.encryptCore,
    this.hadBackup = false,
    this.totalAmountUsd = 0.0,
    this.derivationIndex = 0,
  }) : assert(
         currentWalletId == null || wallets.any((w) => w.id == currentWalletId),
         'currentWalletId must be in wallets',
       );

  final List<Wallet> wallets;

  final String? currentWalletId;

  final int? updatedAt;

  final int? id;

  final int? walletIndex;

  final String? walletName;

  final WalletType walletType;

  final String? encryptCore;

  final bool hadBackup;

  final double totalAmountUsd;

  final int derivationIndex;

  Wallet? get currentWallet {
    if (currentWalletId == null) return null;
    for (final w in wallets) {
      if (w.id == currentWalletId) return w;
    }
    return null;
  }

  bool get hasAny => wallets.isNotEmpty;

  Wallet? walletById(String id) {
    try {
      return wallets.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  AggregatedWallet addWallet(Wallet wallet, {bool setAsCurrent = true}) {
    if (wallets.any((w) => w.id == wallet.id)) return this;
    final next = [...wallets, wallet];
    final nextCurrent = setAsCurrent ? wallet.id : currentWalletId;
    final ts = DateTime.now().millisecondsSinceEpoch;
    return AggregatedWallet(
      wallets: next,
      currentWalletId: nextCurrent,
      updatedAt: ts,
      id: id,
      walletIndex: walletIndex,
      walletName: walletName,
      walletType: walletType,
      encryptCore: encryptCore,
      hadBackup: hadBackup,
      totalAmountUsd: totalAmountUsd,
      derivationIndex: derivationIndex,
    );
  }

  AggregatedWallet removeWallet(String id) {
    final next = wallets.where((w) => w.id != id).toList();
    final nextCurrent = currentWalletId == id
        ? (next.isNotEmpty ? next.first.id : null)
        : currentWalletId;
    return AggregatedWallet(
      wallets: next,
      currentWalletId: nextCurrent,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      id: this.id,
      walletIndex: walletIndex,
      walletName: walletName,
      walletType: walletType,
      encryptCore: encryptCore,
      hadBackup: hadBackup,
      totalAmountUsd: totalAmountUsd,
      derivationIndex: derivationIndex,
    );
  }

  AggregatedWallet setCurrentWallet(String? id) {
    if (id != null && walletById(id) == null) return this;
    return AggregatedWallet(
      wallets: wallets,
      currentWalletId: id,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      id: this.id,
      walletIndex: walletIndex,
      walletName: walletName,
      walletType: walletType,
      encryptCore: encryptCore,
      hadBackup: hadBackup,
      totalAmountUsd: totalAmountUsd,
      derivationIndex: derivationIndex,
    );
  }

  AggregatedWallet updateWallet(Wallet wallet) {
    final index = wallets.indexWhere((w) => w.id == wallet.id);
    if (index < 0) return this;
    final next = List<Wallet>.from(wallets)..[index] = wallet;
    return AggregatedWallet(
      wallets: next,
      currentWalletId: currentWalletId,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      id: this.id,
      walletIndex: walletIndex,
      walletName: walletName,
      walletType: walletType,
      encryptCore: encryptCore,
      hadBackup: hadBackup,
      totalAmountUsd: totalAmountUsd,
      derivationIndex: derivationIndex,
    );
  }

  AggregatedWallet copyWith({
    List<Wallet>? wallets,
    String? currentWalletId,
    int? updatedAt,
    int? id,
    int? walletIndex,
    String? walletName,
    WalletType? walletType,
    String? encryptStr,
    bool? hadBackup,
    double? totalAmountUsd,
    int? derivationIndex,
  }) {
    return AggregatedWallet(
      wallets: wallets ?? this.wallets,
      currentWalletId: currentWalletId ?? this.currentWalletId,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      walletIndex: walletIndex ?? this.walletIndex,
      walletName: walletName ?? this.walletName,
      walletType: walletType ?? this.walletType,
      encryptCore: encryptStr ?? this.encryptCore,
      hadBackup: hadBackup ?? this.hadBackup,
      totalAmountUsd: totalAmountUsd ?? this.totalAmountUsd,
      derivationIndex: derivationIndex ?? this.derivationIndex,
    );
  }
}
