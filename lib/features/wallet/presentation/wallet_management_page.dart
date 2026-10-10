import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/common/config/app_display_switches.dart';
import 'package:chain_notes/features/wallet/application/wallet_management_provider.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';

class WalletManagementPage extends ConsumerStatefulWidget {
  const WalletManagementPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  ConsumerState<WalletManagementPage> createState() =>
      _WalletManagementPageState();
}

class _WalletManagementPageState extends ConsumerState<WalletManagementPage> {
  final TextEditingController _editNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _reloadWalletList();
    });
  }

  void _reloadWalletList() {
    final l10n = AppLocalizations.of(context)!;
    ref.read(walletManagementControllerProvider.notifier).load(
          defaultWalletDisplayName: l10n.profileDefaultWalletName,
          demoWallet1Name: l10n.walletNumberedName(1),
          demoWallet2Name: l10n.walletDemoPrimaryName,
        );
  }

  @override
  void dispose() {
    _editNameController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else if (context.mounted) {
      context.pop();
    }
  }

  Future<void> _saveEdit() async {
    final l10n = AppLocalizations.of(context)!;
    final err = await ref
        .read(walletManagementControllerProvider.notifier)
        .saveEdit(name: _editNameController.text, l10n: l10n);
    if (!mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.walletNameUpdated)));
  }

  Future<void> _confirmDelete() async {

    final storage = SecureStorageService.instance;
    final hasDataKey = await storage.hasDataKey();
    if (!mounted) return;
    if (hasDataKey) {
      final masterKeyBase64 = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PasswordVerifyDialog(
          purpose: PasswordVerifyPurpose.deleteWallet,
        ),
      );
      if (masterKeyBase64 == null || !mounted) return;
    }

    final outcome = await ref
        .read(walletManagementControllerProvider.notifier)
        .confirmDelete();
    if (!mounted || outcome == null) return;
    final l10n = AppLocalizations.of(context)!;
    switch (outcome) {
      case WalletManagementDeleteOutcome.blockedCurrentMustSwitch:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.walletCannotDeleteSwitchFirst)),
        );
        break;
      case WalletManagementDeleteOutcome.lastWalletCleared:
        context.go(AppRoutes.guide);
        break;
      case WalletManagementDeleteOutcome.oneWalletRemoved:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.walletDeleted)));
        break;
    }
  }

  Future<void> _startCreateWalletFlow() async {
    final storage = SecureStorageService.instance;
    final hasDataKey = await storage.hasDataKey();
    if (!mounted) return;

    if (hasDataKey) {
      final masterKeyBase64 = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const PasswordVerifyDialog(),
      );
      if (masterKeyBase64 == null || !mounted) return;
      context.pushReplacement(
        AppRoutes.loading,
        extra: <String, dynamic>{
          'message': AppLocalizations.of(context)!.walletBootstrapCreating,
          'masterKeyBase64': masterKeyBase64,
          'createNewWallet': true,
        },
      );
    } else {
      await context.push<String>(AppRoutes.createWalletPassword);
    }
  }

  Future<void> _createWallet() async {
    final l10n = AppLocalizations.of(context)!;
    final ui = ref.read(walletManagementControllerProvider);
    await ref.read(walletManagementControllerProvider.notifier).createWalletMock(
          l10n.walletNumberedName(ui.wallets.length + 1),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.walletCreated)));
  }

  Future<void> _viewMnemonic(String address) async {
    final l10n = AppLocalizations.of(context)!;
    final ui = ref.read(walletManagementControllerProvider);
    final msg = walletManagementViewMnemonicMessage(l10n, address, ui.wallets);
    if (msg != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    await ref.read(walletManagementControllerProvider.notifier).selectCurrentWallet(address);
    if (!mounted) return;
    await context.push<void>(AppRoutes.mnemonicExport);
  }

  Future<void> _viewPrivateKey(String address) async {
    final l10n = AppLocalizations.of(context)!;
    final ui = ref.read(walletManagementControllerProvider);
    final msg = walletManagementViewPrivateKeyMessage(l10n, address, ui.wallets);
    if (msg != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    await ref
        .read(walletManagementControllerProvider.notifier)
        .selectCurrentWallet(address);
    if (!mounted) return;
    await context.push<void>(
      AppRoutes.privateKeyExport,
      extra: <String, dynamic>{'walletAddress': address},
    );
  }

  Future<void> _switchWallet(String address) async {
    await ref.read(walletManagementControllerProvider.notifier).switchWallet(address);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.walletSwitched)));
  }

  void _viewAddresses(String address) {
    final ui = ref.read(walletManagementControllerProvider);
    String? name;
    for (final e in ui.wallets) {
      if (e.address == address) {
        name = e.name;
        break;
      }
    }
    final addrs = walletManagementRealAddresses(address);
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _AddressListDialog(
        walletName: name ?? '',
        addrs: addrs,
        blue600: _blue600,
      ),
    );
  }

  static const Color _blue600 = Color(0xFF2563eb);
  static const Color _blue50 = Color(0xFFeff6ff);
  static const Color _teal500 = Color(0xFF14b8a6);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final ui = ref.watch(walletManagementControllerProvider);
    ref.listen(walletManagementControllerProvider, (prev, next) {
      if (next.showEditDialog && prev?.showEditDialog != true) {
        _editNameController.text = next.editingName;
        _editNameController.selection = TextSelection.collapsed(
          offset: _editNameController.text.length,
        );
      }
    });
    return Stack(
      children: [
        Scaffold(
          backgroundColor: brand.pageBackground,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: theme.brightness == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark,
                  statusBarBrightness: theme.brightness == Brightness.dark
                      ? Brightness.dark
                      : Brightness.light,
                  systemStatusBarContrastEnforced: false,
                ),
                child: ColoredBox(
                  color: theme.colorScheme.surface,
                  child: SafeArea(
                    bottom: false,
                    child: _buildHeader(theme),
                  ),
                ),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...ui.wallets.map((w) => _buildWalletCard(theme, w, ui)),
                        const SizedBox(height: 16),
                        _buildAddWalletButtons(theme),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ..._buildDialogs(theme, ui),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return PageHeaderWithBack(
      onBack: _onBack,
      title: l10n.walletManagement,
      subtitle: l10n.walletSelectorSubtitle,
    );
  }

  Widget _buildWalletCard(
    ThemeData theme,
    WalletSelectorItem wallet,
    WalletManagementUiState ui,
  ) {
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final l10n = AppLocalizations.of(context)!;
    final isCurrent = wallet.address == ui.currentWallet;
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark
        ? Color.alphaBlend(
            scheme.onSurface.withValues(alpha: 0.10),
            brand.pageBackground,
          )
        : (theme.cardTheme.color ?? scheme.surface);
    final defaultBorder =
        isDark ? scheme.outline.withValues(alpha: 0.45) : scheme.outlineVariant;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? _blue600 : defaultBorder,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.35)
                      : _blue600.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: cardBg, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                        blurRadius: 4,
                      ),
                    ],
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3b82f6), _teal500],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    wallet.address.length >= 4
                        ? wallet.address.substring(2, 4).toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              wallet.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => ref
                                .read(
                                  walletManagementControllerProvider.notifier,
                                )
                                .openEdit(wallet.address),
                            icon: const Icon(Icons.edit_outlined, size: 14),
                            style: IconButton.styleFrom(
                              minimumSize: const Size(24, 24),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: scheme.onSurfaceVariant,
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _blue600,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.current,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          if (wallet.isImported) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.imported,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppDisplaySwitches.displayStoredWalletBalance(
                          wallet.balance,
                        ),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: scheme.onSurfaceVariant,
                  ),
                  padding: EdgeInsets.zero,
                  onSelected: (value) async {
                    switch (value) {
                      case 'mnemonic':
                        await _viewMnemonic(wallet.address);
                        break;
                      case 'privateKey':
                        await _viewPrivateKey(wallet.address);
                        break;
                      case 'delete':
                        ref
                            .read(walletManagementControllerProvider.notifier)
                            .openDelete(wallet.address);
                        break;
                    }
                  },
                  itemBuilder: (menuContext) => [
                    if (wallet.isBackedUp &&
                        walletManagementCanShowViewMnemonic(
                          wallet.address,
                          wallet,
                        ))
                      PopupMenuItem<String>(
                        value: 'mnemonic',
                        child: ListTile(
                          leading: const Icon(Icons.vpn_key_rounded, size: 18),
                          title: Text(
                            l10n.viewMnemonic,
                            style: const TextStyle(fontSize: 14),
                          ),
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 24,
                        ),
                      ),
                    if (wallet.isBackedUp)
                      PopupMenuItem<String>(
                        value: 'privateKey',
                        child: ListTile(
                          leading: const Icon(Icons.key_rounded, size: 18),
                          title: Text(
                            l10n.viewPrivateKey,
                            style: const TextStyle(fontSize: 14),
                          ),
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 24,
                        ),
                      ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'delete',
                      enabled: ui.wallets.length == 1 ||
                          wallet.address != ui.currentWallet,
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color:
                              ui.wallets.length > 1 &&
                                      wallet.address == ui.currentWallet
                                  ? Colors.grey
                                  : const Color(0xFFdc2626),
                        ),
                        title: Text(
                          l10n.deleteWallet,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                ui.wallets.length > 1 &&
                                        wallet.address == ui.currentWallet
                                    ? Colors.grey
                                    : const Color(0xFFdc2626),
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 24,
                      ),
                    ),
                  ],
                ),
                if (!isCurrent)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: OutlinedButton(
                      onPressed: () => _switchWallet(wallet.address),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 32),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: Text(l10n.switchWallet),
                    ),
                  ),
              ],
            ),
            if (!wallet.isBackedUp) ...[
              const SizedBox(height: 12),
              Material(
                color: isDark ? const Color(0xFF422006) : const Color(0xFFfefce8),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () async {
                    final previous = await loadCurrentWalletAddress();
                    await saveCurrentWalletAddress(wallet.address);
                    if (!mounted) return;
                    await context.push<bool?>(AppRoutes.mnemonicBackupFlow);
                    if (!mounted) return;
                    if (previous != null && previous.isNotEmpty) {
                      await saveCurrentWalletAddress(previous);
                    }
                    if (mounted) {
                      _reloadWalletList();
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFfde047)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: isDark
                              ? const Color(0xFFfbbf24)
                              : Colors.amber.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.walletBackupPromptLine1,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFFfcd34d)
                                      : const Color(0xFF92400e),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                l10n.walletBackupPromptLine2,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? const Color(0xFFfde68a)
                                      : const Color(0xFFb45309),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: isDark
                              ? const Color(0xFFfbbf24)
                              : Colors.amber.shade700,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            if (wallet.isBackedUp) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF052e16)
                      : const Color(0xFFf0fdf4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF166534)
                        : const Color(0xFF86efac),
                  ),
                ),
                child: Row(
              children: [
                    Icon(
                      Icons.shield_rounded,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF86efac)
                          : Colors.green.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.backedUp,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFFbbf7d0)
                            : Colors.green.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _viewAddresses(wallet.address),
                icon: const Icon(Icons.place_rounded, size: 14),
                label: Text(
                  l10n.viewAddresses,
                  style: const TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddWalletButtons(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final outlineSide = BorderSide(color: scheme.outline, width: 2);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _startCreateWalletFlow,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              side: outlineSide,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: outlineSide,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Color.alphaBlend(
                            _blue600.withValues(alpha: 0.28),
                            brand.pageBackground,
                          )
                        : _blue50,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.add_rounded,
                    size: 20,
                    color: isDark ? scheme.primary : _blue600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.createWallet,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  l10n.walletCreateGenerateSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              await context.push<void>(AppRoutes.wallet);
              if (mounted) {
                _reloadWalletList();
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              side: outlineSide,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: outlineSide,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Color.alphaBlend(
                            _teal500.withValues(alpha: 0.28),
                            brand.pageBackground,
                          )
                        : const Color(0xFFccfbf1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.file_download_rounded,
                    size: 20,
                    color: isDark ? scheme.primary : _teal500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.importWallet,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  l10n.mnemonicOrPrivateKey,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDialogs(
    ThemeData theme,
    WalletManagementUiState ui,
  ) {
    return [
      if (ui.showEditDialog) _buildEditDialog(theme),
      if (ui.showDeleteDialog) _buildDeleteDialog(theme),
      if (ui.showCreateDialog) _buildCreateDialog(theme),
    ];
  }

  Widget _buildEditDialog(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return _dialog(
      title: l10n.editWalletName,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: _editNameController,
            decoration: InputDecoration(
              labelText: l10n.walletNameFieldLabel,
              hintText: l10n.walletNameFieldHint,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            maxLength: 20,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => ref
                      .read(walletManagementControllerProvider.notifier)
                      .closeEditDialog(),
                  child: Text(l10n.cancel),
                ),
              ),
              Expanded(
                child: FilledButton(
                  onPressed: _saveEdit,
                  child: Text(l10n.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteDialog(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return _dialog(
      title: l10n.deleteWallet,
      titleColor: const Color(0xFFdc2626),
      titleIcon: Icons.warning_amber_rounded,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.walletManagementDeleteIrreversible,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6b7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.walletDeleteConfirmLine2Notes,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6b7280),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFfef2f2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFfecaca)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.walletManagementDeleteWarningTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF991b1b),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.walletManagementDeleteAssetsLoss,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFb91c1c),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => ref
                      .read(walletManagementControllerProvider.notifier)
                      .closeDeleteDialog(),
                  child: Text(l10n.cancel),
                ),
              ),
              Expanded(
                child: FilledButton(
                  onPressed: _confirmDelete,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFdc2626),
                  ),
                  child: Text(l10n.confirmDelete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateDialog(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return _dialog(
      title: l10n.createNewWallet,
      description: l10n.walletCreateSystemDescription,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _blue50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF93c5fd)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.walletPasswordImportantNotice,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF1e3a8a),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.walletCreateBackupReminderBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF1d4ed8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => ref
                      .read(walletManagementControllerProvider.notifier)
                      .closeCreateDialog(),
                  child: Text(l10n.cancel),
                ),
              ),
              Expanded(
                child: FilledButton(
                  onPressed: _createWallet,
                  child: Text(l10n.createWallet),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dialog({
    required String title,
    String? description,
    IconData? titleIcon,
    Color? titleIconColor,
    Color? titleColor,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final media = MediaQuery.sizeOf(context);
    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              child: Container(color: Colors.black54),
            ),
          ),
          Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: media.width * 0.9,
              maxHeight: media.height * 0.85,
            ),
            child: AlertDialog(
              title: Row(
                children: [
                  if (titleIcon != null) ...[
                    Icon(
                      titleIcon,
                      size: 20,
                      color:
                          titleIconColor ??
                          titleColor ??
                          theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                  ),
                ],
              ),
              content: description != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6b7280),
                          ),
                        ),
                        child,
                      ],
                    )
                  : child,
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class _AddressListDialog extends StatefulWidget {
  const _AddressListDialog({
    required this.walletName,
    required this.addrs,
    required this.blue600,
  });

  final String walletName;
  final List<Map<String, dynamic>> addrs;
  final Color blue600;

  @override
  State<_AddressListDialog> createState() => _AddressListDialogState();
}

class _AddressListDialogState extends State<_AddressListDialog> {
  String? _copiedAddress;

  void _copyAddress(String addr) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: addr));
    setState(() => _copiedAddress = addr);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.addressCopied)),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedAddress = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.place_rounded, size: 20, color: widget.blue600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.walletAddressListTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.walletName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 320,
              child: SingleChildScrollView(
                child: Column(
                  children: widget.addrs.map<Widget>((a) {
                    final addr = a['address'] as String;
                    final isCopied = _copiedAddress == addr;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Color.alphaBlend(
                                scheme.onSurface.withValues(alpha: 0.10),
                                brand.pageBackground,
                              )
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? scheme.outline.withValues(alpha: 0.45)
                              : const Color(0xFFe5e7eb),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                a['path'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                              if (a['isDefault'] as bool) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.blue600,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    l10n.defaultBadge,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          SelectableText(
                            addr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppDisplaySwitches.displayStoredWalletBalance(
                              a['balance'] as String,
                            ),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _copyAddress(addr),
                              icon: Icon(
                                isCopied
                                    ? Icons.check_rounded
                                    : Icons.copy_rounded,
                                size: 14,
                                color: isCopied ? Colors.green : null,
                              ),
                              label: Text(
                                isCopied ? l10n.labelCopied : l10n.copyAddressButton,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isCopied ? Colors.green : null,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
