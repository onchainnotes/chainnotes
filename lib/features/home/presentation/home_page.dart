import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/providers.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/app/theme/app_design_tokens.dart';
import 'package:chain_notes/common/config/admob_config.dart';
import 'package:chain_notes/common/config/app_display_switches.dart';
import 'package:chain_notes/features/home/application/home_page_provider.dart';
import 'package:chain_notes/features/home/application/notes_provider.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/home/presentation/widgets/get_gas_modal.dart';
import 'package:chain_notes/features/home/presentation/widgets/home_note_item.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/app/router.dart';

const bool _kShowHomeGasChange24h = false;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
    this.onSelectNote,
    this.onCreateNote,
    this.onWalletChange,
    this.onNavigateToNotes,
    this.onOpenMnemonicExport,
    this.onNavigateToAbout,
    this.onOpenTransactionHistory,
  });

  final ValueChanged<Note>? onSelectNote;
  final VoidCallback? onCreateNote;

  final VoidCallback? onWalletChange;

  final void Function(List<Note> notes, Chain? currentChain)? onNavigateToNotes;
  final VoidCallback? onOpenMnemonicExport;
  final VoidCallback? onNavigateToAbout;

  final VoidCallback? onOpenTransactionHistory;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String get _gasChange24h => '--';

  bool get _gasIsPositive => true;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadAd();
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadAd() async {
    if (!mounted) return;

    final width = MediaQuery
        .sizeOf(context)
        .width
        .truncate();
    final adaptive =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width > 0 ? width : 360,
    );
    final AdSize size = adaptive ?? AdSize.banner;

    final hadPrevious = _bannerAd != null;
    _bannerAd?.dispose();
    _bannerAd = null;
    if (hadPrevious && mounted) setState(() {});

    final bannerAd = BannerAd(
      adUnitId: AdmobConfig.homeBannerAdUnitId,
      request: AdmobConfig.request,
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Called when an ad is successfully received.
          debugPrint("Ad was loaded.");
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdOpened: (Ad ad) {
          // Called when an ad opens an overlay that covers the screen.
          debugPrint("Ad was opened.");
        },
        onAdClosed: (Ad ad) {
          // Called when an ad removes an overlay that covers the screen.
          debugPrint("Ad was closed.");
        },
        onAdImpression: (Ad ad) {
          // Called when an impression occurs on the ad.
          debugPrint("Ad recorded an impression.");
        },
        onAdClicked: (Ad ad) {
          // Called when an a click event occurs on the ad.
          debugPrint("Ad was clicked.");
        },
        onAdWillDismissScreen: (Ad ad) {
          // iOS only. Called before dismissing a full screen view.
          debugPrint("Ad will be dismissed.");
        },
        onAdFailedToLoad: (ad, err) {
          // Called when an ad request failed.
          debugPrint(
            'Ad failed to load: code=${err.code}, domain=${err.domain}, '
                'message=${err.message}, responseInfo=${err.responseInfo}',
          );
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
  }

  String _gasBalanceFrom(HomePageUiState ui) =>
      _formatBalanceDisplay(ui.mainTokenBalance ?? '0');

  String _usdTotalApproxDisplay(HomePageUiState ui) {
    if (ui.mainTokenUsdUnitPrice == null) return '--';
    final raw = ui.mainTokenBalance;
    if (raw == null || raw.isEmpty) return '--';
    final b = double.tryParse(raw);
    if (b == null) return '--';
    return NumberFormat.currency(symbol: r'$', decimalDigits: 2)
        .format(b * ui.mainTokenUsdUnitPrice!);
  }

  String _usdUnitPriceDisplay(HomePageUiState ui) {
    final u = ui.mainTokenUsdUnitPrice;
    if (u == null) return '--';
    if (u >= 1) {
      return NumberFormat.currency(symbol: r'$', decimalDigits: 2).format(u);
    }
    return NumberFormat.currency(symbol: r'$', decimalDigits: 4).format(u);
  }

  Widget _homeFiatSubtitleRow(HomePageUiState ui, bool hide) {
    final usdTotalLabel = hide ? '****' : _usdTotalApproxDisplay(ui);
    final unitPriceLabel = hide ? '****' : _usdUnitPriceDisplay(ui);
    final hasUsd = !hide && ui.mainTokenUsdUnitPrice != null;
    return Row(
      children: [
        Text(
          hide ? '****' : _l10n.homeFiatApprox(usdTotalLabel),
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          width: 1,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.white.withOpacity(0.3),
        ),
        Text(
          !hasUsd
              ? (hide ? '****' : _l10n.homeUnitPriceUnavailable)
              : _l10n.homeUnitPrice(unitPriceLabel),
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        if (_kShowHomeGasChange24h) ...[
          const SizedBox(width: 8),
          Icon(
            _gasIsPositive ? Icons.trending_up : Icons.trending_down,
            size: 14,
            color: Colors.white,
          ),
          Text(
            _gasChange24h,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ],
    );
  }

  void _openTransactionHistory() {
    if (widget.onOpenTransactionHistory != null) {
      widget.onOpenTransactionHistory!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_l10n.homeTransactionHistoryNotConfigured),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatBalanceDisplay(String raw) {
    final v = double.tryParse(raw);
    if (v == null) return raw;
    if (v == 0) return '0';
    if (v >= 1000) return v.toStringAsFixed(2);
    if (v >= 1) return v.toStringAsFixed(4);
    if (v >= 0.0001) return v.toStringAsFixed(6);
    if (v > 0) return v.toStringAsExponential(2);
    return raw;
  }

  String _formatAddress(String? address) {
    if (address == null || address.isEmpty) return _l10n.profileNotConnected;
    if (address.length < 10) return address;
    return '${address.substring(0, 6)}...${address.substring(
        address.length - 4)}';
  }

  void _copyAddress(HomePageUiState ui) {
    final toCopy = ui.currentProtocolAddress ?? ui.currentWallet;
    if (toCopy != null) {
      Clipboard.setData(ClipboardData(text: toCopy));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.walletAddressCopiedShort)));
    }
  }

  Chain? _effectiveChain(Chain? fromProvider) {
    if (fromProvider != null) return fromProvider;
    return ChainFromDemo.mainnetChains.isNotEmpty
        ? ChainFromDemo.mainnetChains.first
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ui = ref.watch(homePageUiProvider);
    final chain = _effectiveChain(ref.watch(currentChainProvider));
    final notesAsync = ref.watch(notesProvider);
    final notes = notesAsync.value ?? [];
    final notesLoading = notesAsync.isLoading;
    final notesSyncing = ref.watch(notesSyncingProvider);
    final realmHasNotesForWalletAsync =
        ref.watch(realmHasNotesForCurrentWalletProvider);
    final realmHasNotesForWallet = realmHasNotesForWalletAsync.value ?? false;
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    return Scaffold(
      body: Container(
          width: double.infinity,
          color: brand.pageBackground,

          //   ),
          // ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(theme, ui, chain),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBalanceCard(theme, ui, chain),
                        const SizedBox(height: 16),
                        _buildAdBanner(theme),
                        const SizedBox(height: 20),
                        _buildRecentNotes(
                          theme,
                          notes: notes,
                          notesLoading: notesLoading,
                          notesSyncing: notesSyncing,
                          realmHasNotesForWallet: realmHasNotesForWallet,
                          chain: chain,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildHeader(ThemeData theme, HomePageUiState ui, Chain? chain) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _openWalletSelector,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF22c55e), Color(0xFF14b8a6)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        ui.currentWallet != null &&
                            ui.currentWallet!.length >= 4
                            ? ui.currentWallet!.substring(2, 4).toUpperCase()
                            : 'ME',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ui.currentWalletName ??
                              AppLocalizations.of(context)!
                                  .profileDefaultWalletName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6b7280),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                _formatAddress(
                                  ui.currentProtocolAddress ?? ui.currentWallet,
                                ),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (ui.currentProtocolAddress != null || ui.currentWallet != null)
            IconButton(
              onPressed: () => _copyAddress(ui),
              icon: const Icon(Icons.copy, size: 18),
              style: IconButton.styleFrom(
                foregroundColor: const Color(0xFF4b5563),
              ),
            ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: _openChainSelector,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 40),
            ),
            child: _buildChainButtonChild(theme, chain),
          ),
        ],
      ),
    );
  }

  Widget _buildChainButtonChild(ThemeData theme, Chain? chain) {
    if (chain != null) {
      final c = chain;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChainNetworkLogo(
            chainLogoUrl: c.chainLogo,
            fallbackColor: c.colorValue,
            fallbackLabel: c.icon ?? c.name.substring(0, 1),
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            c.name,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.account_balance_wallet, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          AppLocalizations.of(context)!.selectNetwork,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildBalanceCard(ThemeData theme, HomePageUiState ui, Chain? chain) {
    final hide = ui.hideBalance;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF059669), Color(0xFF0d9488)],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 36,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 44),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_gas_station,
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            chain != null
                                ? _l10n.homeGasBalanceTitle(chain.symbol)
                                : _l10n.homeTotalAssets,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              ref
                                  .read(homePageUiProvider.notifier)
                                  .toggleHideBalance(),
                          icon: Icon(
                            hide
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 18,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                        const SizedBox(width: 2),
                        RefreshIconButton(
                          onPressed: () =>
                              ref
                                  .read(homePageUiProvider.notifier)
                                  .refreshMainTokenBalance(),
                          isLoading: ui.balanceLoading,
                          backgroundColor: Colors.white.withOpacity(0.12),
                          iconColor: Colors.white,
                          progressColor: Colors.white,
                          iconSize: 14,
                          indicatorSize: 11,
                          indicatorStrokeWidth: 1.5,
                          tooltip: _l10n.homeRefreshBalance,
                          padding: const EdgeInsets.all(2),
                          minimumSize: const Size(26, 26),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                hide
                    ? Text.rich(
                        TextSpan(
                          text: '****',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: ' ${chain?.symbol ?? ''}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      )
                    : ui.balanceLoading
                    ? BalanceLoading(
                  variant: BalanceLoadingVariant.compact,
                  textColor: Colors.white,
                  message: _l10n.loadingDefault,
                )
                    : Text.rich(
                  TextSpan(
                    text: _gasBalanceFrom(ui),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${chain?.symbol ?? ''}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (AppDisplaySwitches.showFiatUsdValues)
                  _homeFiatSubtitleRow(ui, hide),
                if (chain != null && AppDisplaySwitches.showHomeGetGasEntry) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () => _openGetGasModal(ui, chain),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, size: 18),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _l10n.homeGetGas,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openGetGasModal(ui, chain),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _l10n.homeGasHelp,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Tooltip(
                message: _l10n.homeTransactionHistory,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openTransactionHistory,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdBanner(ThemeData theme) {
    return _bannerAd != null
        ? SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    )
        : const SizedBox.shrink();
  }

  void _refreshRecentNotes() {
    ref.invalidate(notesProvider);
  }

  Widget _buildRecentNotes(ThemeData theme, {
    required List<Note> notes,
    required bool notesLoading,
    required bool notesSyncing,
    required bool realmHasNotesForWallet,
    required Chain? chain,
  }) {
    final scheme = theme.colorScheme;
    final recentNotesCardBorderColor = theme.brightness == Brightness.dark
        ? scheme.outlineVariant
        : AppDesignTokens.lightCardSubtleBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      _l10n.homeRecentNotes,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!notesSyncing) ...[
                    const SizedBox(width: 8),
                    RefreshIconButton(
                      onPressed: _refreshRecentNotes,
                      iconSize: 18,
                      indicatorSize: 16,
                      tooltip: _l10n.homeRefreshRecentNotes,
                      padding: const EdgeInsets.all(4),
                      minimumSize: const Size(28, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                  if (notesSyncing) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _l10n.homeLoadingOnChainNotes,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () =>
                  widget.onNavigateToNotes?.call(
                    notes,
                    chain,
                  ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF059669),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 28),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.viewAll,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (notesLoading || (notes.isEmpty && realmHasNotesForWallet))
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: recentNotesCardBorderColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _l10n.homeSyncingOnChainNotes,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          if (notes.isEmpty)
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: recentNotesCardBorderColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFdcfce7), Color(0xFFccfbf1)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.description,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _l10n.noNotes,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _l10n.startCreateFirstNote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6b7280),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: widget.onCreateNote,
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: Text(AppLocalizations.of(context)!.createNote),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...notes.take(20).map((note) {
              final chain = note.chainId != null
                  ? ChainFromDemo.findByChainId(note.chainId!)
                  : null;
              return HomeNoteItem(
                note: note,
                onTap: () => widget.onSelectNote?.call(note),
                chainName: chain?.displayNameOrName,
                chainIcon: chain?.icon,
                chainColorValue: chain?.colorValue,
                chainLogoUrl: chain?.chainLogo,
              );
            }),
        if (notes.length > 20)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton(
              onPressed: () =>
                  widget.onNavigateToNotes?.call(
                    notes,
                    chain,
                  ),
              child: Text(
                AppLocalizations.of(context)!.notesCount(notes.length),
              ),
            ),
          ),
        if (notes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton.icon(
              onPressed: widget.onCreateNote,
              icon: const Icon(Icons.add, size: 16),
              label: Text(AppLocalizations.of(context)!.createNote),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF15803d),
                side: const BorderSide(color: Color(0xFF15803d)),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openChainSelector() async {
    final current = ref.read(currentChainProvider);
    final chain = await context.push<Chain?>(
      AppRoutes.chainSelector,
      extra: <String, dynamic>{'currentChain': current},
    );
    if (chain != null && mounted) {
      await ref.read(currentChainProvider.notifier).setChain(chain);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_l10n.switchedToChain(chain.displayNameOrName))),
      );
    }
  }

  void _openWalletSelector() {
    final ui = ref.read(homePageUiProvider);
    showWalletSelector(
      context,
      currentWallet: ui.currentWallet,
      onWalletChanged: (_) {
        widget.onWalletChange?.call();
      },
      onBackup: (address) async {
        final previous = await loadCurrentWalletAddress();
        await saveCurrentWalletAddress(address);
        if (!mounted) return;
        await context.push<bool?>(AppRoutes.mnemonicBackupFlow);
        if (!mounted) return;
        if (previous != null && previous.isNotEmpty) {
          await saveCurrentWalletAddress(previous);
        }
      },
      onImportWallet: () => context.push(AppRoutes.wallet),
      onNavigateToCreateWallet: (masterKeyBase64) {
        context.pushReplacement(
          AppRoutes.loading,
          extra: <String, dynamic>{
            'message': _l10n.walletBootstrapCreating,
            'masterKeyBase64': masterKeyBase64,
            'createNewWallet': true,
          },
        );
      },
    );
  }

  void _openGetGasModal(HomePageUiState ui, Chain chain) {
    showGetGasModal(
      context,
      chainName: chain.name,
      tokenSymbol: chain.symbol,
      walletAddress:
      ui.currentProtocolAddress ?? ui.currentWallet ?? '',
      faucetUrls: chain.faucetUrls,
    );
  }
}
