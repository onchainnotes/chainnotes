import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:chain_notes/common/config/app_display_switches.dart';
import 'package:chain_notes/common/storage/preference_keys.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/features/wallet/utils/wallet_aggregated_lookup.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'wallet_management_provider.g.dart';

enum WalletManagementDeleteOutcome {

  blockedCurrentMustSwitch,

  lastWalletCleared,

  oneWalletRemoved,
}

@immutable
class WalletManagementUiState {
  const WalletManagementUiState({
    this.wallets = const [],
    this.currentWallet,
    this.selectedWallet,
    this.editingName = '',
    this.showEditDialog = false,
    this.showDeleteDialog = false,
    this.showCreateDialog = false,
  });

  final List<WalletSelectorItem> wallets;
  final String? currentWallet;
  final String? selectedWallet;
  final String editingName;
  final bool showEditDialog;
  final bool showDeleteDialog;
  final bool showCreateDialog;

  WalletManagementUiState copyWith({
    List<WalletSelectorItem>? wallets,
    String? currentWallet,
    bool clearCurrentWallet = false,
    String? selectedWallet,
    bool clearSelectedWallet = false,
    String? editingName,
    bool? showEditDialog,
    bool? showDeleteDialog,
    bool? showCreateDialog,
  }) {
    return WalletManagementUiState(
      wallets: wallets ?? this.wallets,
      currentWallet:
          clearCurrentWallet ? null : (currentWallet ?? this.currentWallet),
      selectedWallet: clearSelectedWallet
          ? null
          : (selectedWallet ?? this.selectedWallet),
      editingName: editingName ?? this.editingName,
      showEditDialog: showEditDialog ?? this.showEditDialog,
      showDeleteDialog: showDeleteDialog ?? this.showDeleteDialog,
      showCreateDialog: showCreateDialog ?? this.showCreateDialog,
    );
  }
}

List<Map<String, dynamic>> walletManagementRealAddresses(
  String representativeAddress,
) {
  try {
    final manager = WalletUtils.getRealmManager();
    final aggregatedList = manager.loadAllAggregatedWallets();
    for (final agg in aggregatedList) {
      final match = agg.wallets.any(
        (w) =>
            w.address == representativeAddress ||
            w.protocolAccounts.any((p) => p.address == representativeAddress),
      );
      if (!match) continue;
      final currentId = agg.currentWalletId;
      final result = <Map<String, dynamic>>[];
      for (final w in agg.wallets) {
        result.add({
          'path': w.derivationPath ?? "m/44'/60'/0'/0/0",
          'address': w.address,
          'balance':
              AppDisplaySwitches.walletFiatBalanceLabel(w.totalAmountUsd),
          'isDefault': w.id == currentId,
        });
      }
      if (result.isNotEmpty) return result;
    }
  } catch (_) {}
  return [
    {
      'path': "m/44'/60'/0'/0/0",
      'address': representativeAddress,
      'balance': AppDisplaySwitches.walletFiatBalanceLabel(0),
      'isDefault': true,
    },
  ];
}

bool walletManagementCanShowViewMnemonic(
  String address,
  WalletSelectorItem wallet,
) {
  final agg = walletManagementAggregatedForRepresentativeAddress(address);
  if (agg != null) {
    return agg.walletType != WalletType.importedPrivateKey;
  }
  return !wallet.isImported;
}

String? walletManagementViewMnemonicMessage(
  AppLocalizations l10n,
  String address,
  List<WalletSelectorItem> wallets,
) {
  WalletSelectorItem? w;
  for (final e in wallets) {
    if (e.address == address) {
      w = e;
      break;
    }
  }
  if (w == null) return null;

  final agg = walletManagementAggregatedForRepresentativeAddress(address);
  if (agg != null) {
    if (agg.walletType == WalletType.importedPrivateKey) {
      return l10n.walletImportedCannotViewMnemonic;
    }
  } else if (w.isImported) {

    return l10n.walletImportedCannotViewMnemonic;
  }

  if (!w.isBackedUp) return l10n.walletViewMnemonicCompleteBackupFirst;
  return null;
}

String? walletManagementViewPrivateKeyMessage(
  AppLocalizations l10n,
  String address,
  List<WalletSelectorItem> wallets,
) {
  WalletSelectorItem? w;
  for (final e in wallets) {
    if (e.address == address) {
      w = e;
      break;
    }
  }
  if (w == null) return null;
  if (!w.isBackedUp) return l10n.walletViewMnemonicCompleteBackupFirst;
  return null;
}

@Riverpod(keepAlive: false)
class WalletManagementController extends _$WalletManagementController {
  @override
  WalletManagementUiState build() {
    return const WalletManagementUiState();
  }

  Future<void> load({
    required String defaultWalletDisplayName,
    required String demoWallet1Name,
    required String demoWallet2Name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getString(PreferenceKeys.currentWallet);
    var list = <WalletSelectorItem>[];

    try {
      final manager = WalletUtils.getRealmManager();
      final aggregatedList = manager.loadAllAggregatedWallets();
      if (aggregatedList.isNotEmpty) {
        for (final agg in aggregatedList) {
          final representativeAddress = agg.currentWallet?.address ??
              (agg.wallets.isNotEmpty ? agg.wallets.first.address : null);
          if (representativeAddress == null) continue;
          list.add(
            WalletSelectorItem(
              address: representativeAddress,
              name: agg.walletName ?? defaultWalletDisplayName,
              balance: AppDisplaySwitches.walletFiatBalanceLabel(
                agg.totalAmountUsd,
              ),
              isImported: agg.walletType != WalletType.created,
              isBackedUp: agg.hadBackup,
            ),
          );
        }
      }
    } catch (_) {}

    if (list.isEmpty) {
      final raw = prefs.getString(PreferenceKeys.wallets);
      if (raw != null) {
        try {
          final decoded = jsonDecode(raw) as List<dynamic>?;
          if (decoded != null) {
            list = decoded
                .map(
                  (e) => WalletSelectorItem.fromJson(
                    Map<String, dynamic>.from(e as Map<dynamic, dynamic>),
                  ),
                )
                .toList();
          }
        } catch (_) {}
      }
    }
    if (list.isEmpty) {
      list = [
        WalletSelectorItem(
          address: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1',
          name: demoWallet1Name,
          balance: AppDisplaySwitches.walletFiatBalanceLabel(0),
          isImported: false,
          isBackedUp: false,
        ),
        WalletSelectorItem(
          address: '0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199',
          name: demoWallet2Name,
          balance: AppDisplaySwitches.walletFiatBalanceLabel(0),
          isImported: true,
          isBackedUp: false,
        ),
      ];
      await _saveWalletsToPrefs(list);
    }
    state = state.copyWith(
      wallets: list,
      currentWallet: current ?? (list.isNotEmpty ? list.first.address : null),
    );
  }

  Future<void> _saveWalletsToPrefs(List<WalletSelectorItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      PreferenceKeys.wallets,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _setCurrentWalletPref(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.currentWallet, address);
  }

  void openEdit(String address) {
    WalletSelectorItem? w;
    for (final e in state.wallets) {
      if (e.address == address) {
        w = e;
        break;
      }
    }
    if (w == null) return;
    state = state.copyWith(
      selectedWallet: address,
      editingName: w.name,
      showEditDialog: true,
    );
  }

  void closeEditDialog() {
    state = state.copyWith(
      showEditDialog: false,
      clearSelectedWallet: true,
      editingName: '',
    );
  }

  Future<String?> saveEdit({
    String? name,
    required AppLocalizations l10n,
  }) async {
    final trimmed = (name ?? state.editingName).trim();
    if (trimmed.isEmpty) {
      return l10n.walletNameRequired;
    }
    final selected = state.selectedWallet;
    if (selected == null) return null;
    final next = state.wallets
        .map(
          (e) => e.address == selected ? e.copyWith(name: trimmed) : e,
        )
        .toList();
    await _saveWalletsToPrefs(next);

    try {
      final agg = walletManagementAggregatedForRepresentativeAddress(selected);
      if (agg != null) {
        final manager = WalletUtils.getRealmManager();
        manager.saveAggregatedWallet(
          agg.copyWith(
            walletName: trimmed,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );

        refreshHomeContext(ref.container, refreshChain: false);
      }
    } catch (_) {}

    state = state.copyWith(
      wallets: next,
      showEditDialog: false,
      clearSelectedWallet: true,
      editingName: '',
    );
    return null;
  }

  void openDelete(String address) {
    state = state.copyWith(
      selectedWallet: address,
      showDeleteDialog: true,
    );
  }

  void closeDeleteDialog() {
    state = state.copyWith(
      showDeleteDialog: false,
      clearSelectedWallet: true,
    );
  }

  Future<WalletManagementDeleteOutcome?> confirmDelete() async {
    final address = state.selectedWallet;
    if (address == null) {
      state = state.copyWith(showDeleteDialog: false);
      return null;
    }
    if (state.wallets.length > 1 && address == state.currentWallet) {
      return WalletManagementDeleteOutcome.blockedCurrentMustSwitch;
    }

    WalletUtils.deleteWalletByAddress(address);
    refreshHomeContext(ref.container);

    final next = state.wallets.where((w) => w.address != address).toList();
    if (next.isEmpty) {
      await WalletUtils.clearAllWalletData();
      refreshHomeContext(ref.container);
      state = state.copyWith(
        wallets: [],
        clearCurrentWallet: true,
        showDeleteDialog: false,
        clearSelectedWallet: true,
      );
      return WalletManagementDeleteOutcome.lastWalletCleared;
    }

    await _saveWalletsToPrefs(next);
    state = state.copyWith(
      wallets: next,
      showDeleteDialog: false,
      clearSelectedWallet: true,
    );
    return WalletManagementDeleteOutcome.oneWalletRemoved;
  }

  void openCreateDialog() {
    state = state.copyWith(showCreateDialog: true);
  }

  void closeCreateDialog() {
    state = state.copyWith(showCreateDialog: false);
  }

  Future<void> createWalletMock(String displayName) async {
    final rng = math.Random();
    final addr =
        '0x${List.generate(40, (_) => rng.nextInt(16).toRadixString(16)).join()}';
    final newItem = WalletSelectorItem(
      address: addr,
      name: displayName,
      balance: AppDisplaySwitches.walletFiatBalanceLabel(0),
      isImported: false,
      isBackedUp: false,
    );
    final next = [...state.wallets, newItem];
    await _saveWalletsToPrefs(next);
    state = state.copyWith(
      wallets: next,
      showCreateDialog: false,
    );
  }

  Future<void> switchWallet(String address) async {
    await _setCurrentWalletPref(address);
    state = state.copyWith(currentWallet: address);
  }

  Future<void> selectCurrentWallet(String address) async {
    await _setCurrentWalletPref(address);
    state = state.copyWith(currentWallet: address);
  }
}
