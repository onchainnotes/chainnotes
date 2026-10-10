import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/providers.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/app/theme/app_design_tokens.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/home/application/notes_provider.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain_type.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';
import 'package:chain_notes/common/config/app_display_switches.dart';
import 'package:chain_notes/common/storage/preference_keys.dart';
import 'package:chain_notes/features/wallet/presentation/views/wallet_selector_dialog_item_view.dart';
import 'package:chain_notes/features/wallet/utils/wallet_aggregated_lookup.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletSelectorItem {
  const WalletSelectorItem({
    required this.address,
    required this.name,
    required this.balance,
    required this.isImported,
    required this.isBackedUp,
  });

  final String address;
  final String name;
  final String balance;
  final bool isImported;
  final bool isBackedUp;

  Map<String, dynamic> toJson() => {
        'address': address,
        'name': name,
        'balance': balance,
        'isImported': isImported,
        'isBackedUp': isBackedUp,
      };

  static WalletSelectorItem fromJson(Map<String, dynamic> json) {
    return WalletSelectorItem(
      address: json['address'] as String? ?? '',
      name: json['name'] as String? ?? '',
      balance: json['balance'] as String? ??
          AppDisplaySwitches.walletFiatBalanceLabel(0),
      isImported: json['isImported'] as bool? ?? false,
      isBackedUp: json['isBackedUp'] as bool? ?? false,
    );
  }

  WalletSelectorItem copyWith({
    String? address,
    String? name,
    String? balance,
    bool? isImported,
    bool? isBackedUp,
  }) {
    return WalletSelectorItem(
      address: address ?? this.address,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      isImported: isImported ?? this.isImported,
      isBackedUp: isBackedUp ?? this.isBackedUp,
    );
  }
}

void refreshHomeContext(
  ProviderContainer container, {
  bool refreshChain = true,
}) {
  if (refreshChain) {
    container.invalidate(currentChainProvider);
  }
  container.invalidate(notesProvider);
  container.read(homeWalletContextTickProvider.notifier).state++;
}

Future<String?> loadCurrentWalletAddress() async {
  final prefs = await SharedPreferences.getInstance();
  var addr = prefs.getString(PreferenceKeys.currentWallet);
  if (addr != null && addr.isNotEmpty) return addr;
  try {
    final list = WalletUtils.getRealmManager().loadAllAggregatedWallets();
    for (final agg in list) {
      final evmWallet =
          agg.wallets.where((w) => w.chainType == ChainType.evm).firstOrNull;
      final rep = evmWallet?.address ?? agg.wallets.firstOrNull?.address;
      if (rep != null && rep.isNotEmpty) {
        await prefs.setString(PreferenceKeys.currentWallet, rep);
        return rep;
      }
    }
  } catch (_) {}
  return null;
}

Future<void> saveCurrentWalletAddress(String address) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(PreferenceKeys.currentWallet, address);
}

Future<int?> loadCurrentAggregatedWalletId() async {
  final addr = await loadCurrentWalletAddress();
  if (addr == null || addr.isEmpty) return null;
  try {
    final list = WalletUtils.getRealmManager().loadAllAggregatedWallets();
    for (final agg in list) {
      final representativeAddress = agg.currentWallet?.address ??
          (agg.wallets.isNotEmpty ? agg.wallets.first.address : null);
      final anyMatch =
          (representativeAddress != null &&
              _addrEquals(representativeAddress, addr)) ||
          agg.wallets.any(
            (w) =>
                _addrEquals(w.address, addr) ||
                w.protocolAccounts.any((p) => _addrEquals(p.address, addr)),
          );
      if (anyMatch && agg.id != null) return agg.id;
    }
  } catch (_) {}
  return null;
}

class CurrentWalletDisplayInfo {
  const CurrentWalletDisplayInfo({
    this.walletName,
    this.protocolAddress,
  });

  final String? walletName;
  final String? protocolAddress;
}

const int _kEvmCoinType = 60;

bool _addrEquals(String a, String b) {
  if (a == b) return true;
  if (a.startsWith('0x') && b.startsWith('0x')) {
    return a.toLowerCase() == b.toLowerCase();
  }
  return false;
}

Future<CurrentWalletDisplayInfo> loadCurrentWalletDisplayInfo(
  String? currentAddress,
  int? currentChainId,
) async {
  if (currentAddress == null || currentAddress.isEmpty) {
    return const CurrentWalletDisplayInfo();
  }
  try {
    final manager = WalletUtils.getRealmManager();
    final aggregatedList = manager.loadAllAggregatedWallets();
    for (final agg in aggregatedList) {
      final representativeAddress = agg.currentWallet?.address ??
          (agg.wallets.isNotEmpty ? agg.wallets.first.address : null);
      final anyMatch =
          (representativeAddress != null &&
              _addrEquals(representativeAddress, currentAddress)) ||
          agg.wallets.any(
            (w) =>
                _addrEquals(w.address, currentAddress) ||
                w.protocolAccounts
                    .any((p) => _addrEquals(p.address, currentAddress)),
          );
      if (!anyMatch) continue;

      final walletName = agg.walletName;
      String? protocolAddress;

      if (currentChainId != null) {
        for (final w in agg.wallets) {
          for (final p in w.protocolAccounts) {
            if (p.protocolType == currentChainId) {
              protocolAddress = p.address;
              break;
            }
          }
          if (protocolAddress != null) break;
        }
        if (protocolAddress == null) {
          for (final w in agg.wallets) {
            for (final p in w.protocolAccounts) {
              if (p.walletCoreCoinType == _kEvmCoinType) {
                protocolAddress = p.address;
                break;
              }
            }
            if (protocolAddress != null) break;
          }
        }
      }
      protocolAddress ??= representativeAddress ?? currentAddress;

      return CurrentWalletDisplayInfo(
        walletName: walletName,
        protocolAddress: protocolAddress,
      );
    }
    return CurrentWalletDisplayInfo(
      walletName: null,
      protocolAddress: currentAddress,
    );
  } catch (_) {}
  return CurrentWalletDisplayInfo(
    walletName: null,
    protocolAddress: currentAddress,
  );
}

Future<void> saveWalletSelectorItemsToPrefs(List<WalletSelectorItem> list) async {
  final prefs = await SharedPreferences.getInstance();
  final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
  await prefs.setString(PreferenceKeys.wallets, encoded);
}

Future<List<WalletSelectorItem>> loadWalletSelectorItemList(
  AppLocalizations l10n, {
  String? currentWalletHint,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final current = prefs.getString(PreferenceKeys.currentWallet);
  var list = <WalletSelectorItem>[];

  try {
    final manager = WalletUtils.getRealmManager();
    final aggregatedList = manager.loadAllAggregatedWallets();
    if (aggregatedList.isNotEmpty) {
      for (final agg in aggregatedList) {
        final representativeAddress =
            agg.currentWallet?.address ??
            (agg.wallets.isNotEmpty ? agg.wallets.first.address : null);
        if (representativeAddress == null) continue;
        list.add(
          WalletSelectorItem(
            address: representativeAddress,
            name: agg.walletName ?? l10n.profileDefaultWalletName,
            balance:
                AppDisplaySwitches.walletFiatBalanceLabel(agg.totalAmountUsd),
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
    final defaultAddress =
        currentWalletHint ??
        current ??
        '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(40, '0')}';
    list = [
      WalletSelectorItem(
        address: defaultAddress,
        name: l10n.walletNumberedName(1),
        balance: AppDisplaySwitches.walletFiatBalanceLabel(0),
        isImported: false,
        isBackedUp: false,
      ),
    ];
    await saveWalletSelectorItemsToPrefs(list);
    if (current == null) {
      await prefs.setString(PreferenceKeys.currentWallet, defaultAddress);
    }
  }
  return list;
}

const Color _kWalletSelectorBlue600 = Color(0xFF2563eb);

Future<void> showWalletSelector(
  BuildContext context, {
  required String? currentWallet,
  required void Function(String address) onWalletChanged,
  required void Function(String address) onBackup,
  VoidCallback? onImportWallet,
  void Function(String masterKeyBase64)? onNavigateToCreateWallet,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      final scheme = Theme.of(ctx).colorScheme;
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      final dialogSurface =
          isDark ? scheme.surfaceContainerHigh : Colors.white;
      return Dialog(
        backgroundColor: dialogSurface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.sizeOf(ctx).height * 0.8,
          ),
          child: _WalletSelectorDialogPage(
            currentWallet: currentWallet,
            onWalletChanged: onWalletChanged,
            onBackup: onBackup,
            onImportWallet: onImportWallet,
            onNavigateToCreateWallet: onNavigateToCreateWallet,
          ),
        ),
      );
    },
  );
}

class _WalletSelectorDialogPage extends StatefulWidget {
  const _WalletSelectorDialogPage({
    required this.currentWallet,
    required this.onWalletChanged,
    required this.onBackup,
    this.onImportWallet,
    this.onNavigateToCreateWallet,
  });

  final String? currentWallet;
  final void Function(String address) onWalletChanged;
  final void Function(String address) onBackup;
  final VoidCallback? onImportWallet;
  final void Function(String masterKeyBase64)? onNavigateToCreateWallet;

  @override
  State<_WalletSelectorDialogPage> createState() =>
      _WalletSelectorDialogPageState();
}

class _WalletSelectorDialogPageState extends State<_WalletSelectorDialogPage> {
  late Future<List<WalletSelectorItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchItems();
  }

  Future<List<WalletSelectorItem>> _fetchItems() async {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final l10n = await AppLocalizations.delegate.load(locale);
    return loadWalletSelectorItemList(
      l10n,
      currentWalletHint: widget.currentWallet,
    );
  }

  void _refreshItems() {
    setState(() {
      _itemsFuture = _fetchItems();
    });
  }

  Future<void> _openEdit(List<WalletSelectorItem> wallets, String address) async {
    final w = wallets.cast<WalletSelectorItem?>().firstWhere(
          (e) => e?.address == address,
          orElse: () => null,
        );
    if (w == null || !mounted) return;
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => EditWalletNameDialog(
        initialName: w.name,
        onSave: (value) => Navigator.of(ctx).pop(value),
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
    if (name == null || name.trim().isEmpty || !mounted) return;
    final trimmed = name.trim();
    final next = wallets
        .map((e) => e.address == address ? e.copyWith(name: trimmed) : e)
        .toList();
    await saveWalletSelectorItemsToPrefs(next);

    try {
      final agg = walletManagementAggregatedForRepresentativeAddress(address);
      if (agg != null) {
        WalletUtils.getRealmManager().saveAggregatedWallet(
          agg.copyWith(
            walletName: trimmed,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    } catch (_) {}

    if (!mounted) return;
    refreshHomeContext(ProviderScope.containerOf(context), refreshChain: false);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.walletNameUpdated)),
    );
  }

  Future<void> _confirmDelete(
    List<WalletSelectorItem> wallets,
    String address,
    String? currentWallet,
  ) async {
    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final loc = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(loc.walletDeleteConfirmTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.walletDeleteConfirmLine1, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                loc.walletDeleteConfirmLine2Notes,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6b7280),
                  fontSize: 14,
                ),
              ),
              if (wallets.length > 1 &&
                  currentWallet != null &&
                  _addrEquals(address, currentWallet)) ...[
                const SizedBox(height: 8),
                Text(
                  loc.walletDeleteCannotCurrent,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFdc2626),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
              if (wallets.length <= 1) ...[
                const SizedBox(height: 8),
                Text(
                  loc.walletDeleteLastHint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6b7280),
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(loc.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFdc2626),
                foregroundColor: Colors.white,
              ),
              child: Text(loc.deleteWallet),
            ),
          ],
        );
      },
    );
    if (confirm != true || !mounted) return;

    final hasDataKey = await SecureStorageService.instance.hasDataKey();
    if (!mounted) return;
    if (hasDataKey) {
      final masterKeyBase64 = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const PasswordVerifyDialog(
          purpose: PasswordVerifyPurpose.deleteWallet,
        ),
      );
      if (masterKeyBase64 == null || !mounted) return;
    }

    if (wallets.length > 1 &&
        currentWallet != null &&
        _addrEquals(address, currentWallet)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cannotDeleteCurrentWallet),
        ),
      );
      return;
    }

    WalletUtils.deleteWalletByAddress(address);
    if (!mounted) return;

    final next = wallets
        .where((w) => !_addrEquals(w.address, address))
        .toList();
    if (next.isEmpty) {
      await WalletUtils.clearAllWalletData();
      refreshHomeContext(ProviderScope.containerOf(context));
      if (!mounted) return;
      Navigator.of(context).pop();
      context.go(AppRoutes.guide);
    } else {
      refreshHomeContext(ProviderScope.containerOf(context));
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final refreshed = await loadWalletSelectorItemList(
        l10n,
        currentWalletHint: widget.currentWallet,
      );
      await saveWalletSelectorItemsToPrefs(refreshed);
      if (!mounted) return;
      setState(() {
        _itemsFuture = Future.value(refreshed);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.walletDeleted)),
      );
    }
  }

  Future<void> _startCreateWalletFlow() async {
    final hasDataKey = await SecureStorageService.instance.hasDataKey();
    if (!mounted) return;
    if (hasDataKey) {
      final masterKeyBase64 = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const PasswordVerifyDialog(
          purpose: PasswordVerifyPurpose.createWallet,
        ),
      );
      if (masterKeyBase64 == null || !mounted) return;
      Navigator.of(context).pop();
      if (widget.onNavigateToCreateWallet != null) {
        widget.onNavigateToCreateWallet!(masterKeyBase64);
      } else {
        context.pushReplacement(
          AppRoutes.loading,
          extra: <String, dynamic>{
            'message': AppLocalizations.of(context)!.walletBootstrapCreating,
            'masterKeyBase64': masterKeyBase64,
            'createNewWallet': true,
          },
        );
      }
    } else {
      Navigator.of(context).pop();
      context.push(AppRoutes.createWalletPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final surface = isDark ? scheme.surfaceContainerHigh : Colors.white;
    final dialogDividerColor = isDark
        ? scheme.outline
        : AppDesignTokens.lightCardSubtleBorder;
    final subtleText =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);

    return Material(
      color: surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 10),
            decoration: BoxDecoration(
              color: surface,
              border: Border(bottom: BorderSide(color: dialogDividerColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 20,
                      color: _kWalletSelectorBlue600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.walletSelectorTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 22),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(40, 40),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.walletSelectorSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subtleText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<WalletSelectorItem>>(
              future: _itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      '${snapshot.error}',
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                }
                final wallets = snapshot.data ?? [];
                if (wallets.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.walletErrNoWalletYet,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                final current = widget.currentWallet;
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  itemCount: wallets.length,
                  itemBuilder: (context, i) => WalletSelectorDialogItemView(
                    theme: theme,
                    scheme: scheme,
                    isDark: isDark,
                    wallet: wallets[i],
                    isCurrent: current != null &&
                        _addrEquals(wallets[i].address, current),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                        PreferenceKeys.currentWallet,
                        wallets[i].address,
                      );
                      widget.onWalletChanged(wallets[i].address);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.walletSwitched)),
                      );
                      Navigator.of(context).pop();
                    },
                    onEdit: () => _openEdit(wallets, wallets[i].address),
                    onCopy: () {
                      Clipboard.setData(
                        ClipboardData(text: wallets[i].address),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.addressCopied)),
                      );
                    },
                    onDelete: wallets.length <= 1 ||
                            current == null ||
                            !_addrEquals(wallets[i].address, current)
                        ? () => _confirmDelete(
                              wallets,
                              wallets[i].address,
                              current,
                            )
                        : null,
                    onBackup: () {
                      Navigator.of(context).pop();
                      widget.onBackup(wallets[i].address);
                    },
                  ),
                );
              },
            ),
          ),
          _WalletSelectorDialogFooter(
            theme: theme,
            scheme: scheme,
            isDark: isDark,
            dividerColor: dialogDividerColor,
            onCreateWallet: _startCreateWalletFlow,
            onImport: () {
              Navigator.of(context).pop();
              widget.onImportWallet?.call();
            },
          ),
        ],
      ),
    );
  }
}

class _WalletSelectorDialogFooter extends StatelessWidget {
  const _WalletSelectorDialogFooter({
    required this.theme,
    required this.scheme,
    required this.isDark,
    required this.dividerColor,
    required this.onCreateWallet,
    required this.onImport,
  });

  final ThemeData theme;
  final ColorScheme scheme;
  final bool isDark;
  final Color dividerColor;
  final VoidCallback onCreateWallet;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final footerBg =
        isDark ? scheme.surfaceContainerLow : brand.pageBackground;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: footerBg,
        border: Border(top: BorderSide(color: dividerColor)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCreateWallet,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text(l10n.createNewWallet),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(fontSize: 14),
                foregroundColor: scheme.onSurface,
                side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.file_download_rounded, size: 16),
              label: Text(l10n.importWallet),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(fontSize: 14),
                foregroundColor: scheme.onSurface,
                side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditWalletNameDialog extends StatefulWidget {
  const EditWalletNameDialog({
    super.key,
    required this.initialName,
    required this.onSave,
    required this.onCancel,
  });

  final String initialName;
  final ValueChanged<String> onSave;
  final VoidCallback onCancel;

  @override
  State<EditWalletNameDialog> createState() => _EditWalletNameDialogState();
}

class _EditWalletNameDialogState extends State<EditWalletNameDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.editWalletNameTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.walletEditNameSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6b7280),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: l10n.walletNameFieldLabel,
              hintText: l10n.walletNameFieldHint,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            maxLength: 20,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) widget.onSave(value.trim());
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: widget.onCancel, child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () {
            final v = _controller.text.trim();
            if (v.isNotEmpty) widget.onSave(v);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
