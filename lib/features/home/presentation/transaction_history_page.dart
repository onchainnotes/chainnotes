import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/home/application/transaction_history_provider.dart';
import 'package:chain_notes/features/home/presentation/widgets/transaction_history_item.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({
    super.key,
    required this.onBack,
    this.currentChain,
    this.onChainChange,
  });

  final VoidCallback onBack;
  final Chain? currentChain;
  final ValueChanged<Chain>? onChainChange;

  @override
  ConsumerState<TransactionHistoryPage> createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState
    extends ConsumerState<TransactionHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionHistoryControllerProvider.notifier).load(
            parentChain: widget.currentChain,
          );
    });
  }

  @override
  void didUpdateWidget(covariant TransactionHistoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentChain?.id != widget.currentChain?.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(transactionHistoryControllerProvider.notifier).load(
              parentChain: widget.currentChain,
            );
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.transactionHistoryCopied),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openTxInExplorer(String explorerBase, String txHash) async {
    final l10n = AppLocalizations.of(context)!;
    final base = explorerBase.replaceAll(RegExp(r'/+$'), '');
    final url = '$base/tx/$txHash';
    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.transactionHistoryExplorerInvalidUrl),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.transactionHistoryExplorerLaunchFailed),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(l10n.transactionHistoryExplorerOpenError(e.toString())),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleRefresh() async {
    final l10n = AppLocalizations.of(context)!;
    final showSnack = await ref
        .read(transactionHistoryControllerProvider.notifier)
        .load(
          parentChain: widget.currentChain,
          showRefreshSnack: true,
        );
    if (mounted && showSnack) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.transactionHistoryRefreshed),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onChainSelected(Chain chain) {
    ref.read(transactionHistoryControllerProvider.notifier).setInternalChain(chain);
    widget.onChainChange?.call(chain);
    ref.read(transactionHistoryControllerProvider.notifier).load(
          parentChain: chain,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final ui = ref.watch(transactionHistoryControllerProvider);
    final notifier = ref.read(transactionHistoryControllerProvider.notifier);
    final filtered = ui.filteredTransactions;
    final displayChain = transactionHistoryEffectiveChain(
      widget.currentChain,
      ui.internalSelectedChain,
    );

    final headerBg = scheme.surface;
    final headerIconBg =
        isDark ? scheme.surfaceContainerHighest : Colors.grey[100]!;
    final headerIconFg =
        isDark ? scheme.onSurface : const Color(0xFF374151);
    final subtitleMuted =
        isDark ? scheme.onSurfaceVariant : Colors.grey[600]!;
    final statTotalColor =
        isDark ? scheme.onSurface : Colors.grey[800]!;

    return Scaffold(
      backgroundColor: brand.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness:
                  isDark ? Brightness.dark : Brightness.light,
              systemStatusBarContrastEnforced: false,
            ),
            child: ColoredBox(
              color: headerBg,
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          BackIconButton(
                            onPressed: widget.onBack,
                            backgroundColor: headerIconBg,
                            iconColor: headerIconFg,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.homeTransactionHistory,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: scheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  l10n.transactionHistorySubtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: subtitleMuted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          RefreshIconButton(
                            onPressed: _handleRefresh,
                            isLoading: ui.isRefreshing,
                            backgroundColor: headerIconBg,
                            iconColor: headerIconFg,
                            progressColor: headerIconFg,
                          ),
                          const SizedBox(width: 8),
                          _buildChainSelector(theme, displayChain, l10n),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          _buildStatItem(
                            l10n.transactionHistoryStatTotal,
                            '${ui.statTotal}',
                            theme.textTheme,
                            statTotalColor,
                          ),
                          _buildStatItem(
                            l10n.transactionHistoryStatSuccess,
                            '${ui.statSuccess}',
                            theme.textTheme,
                            const Color(0xFF16a34a),
                          ),
                          _buildStatItem(
                            l10n.transactionHistoryStatPending,
                            '${ui.statPending}',
                            theme.textTheme,
                            const Color(0xFFca8a04),
                          ),
                          _buildStatItem(
                            l10n.transactionHistoryStatFailed,
                            '${ui.statFailed}',
                            theme.textTheme,
                            const Color(0xFFdc2626),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                              l10n.transactionHistoryFilterAll,
                              ui.filter == TransactionHistoryListFilter.all,
                              () => notifier.setFilter(
                                  TransactionHistoryListFilter.all),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              l10n.transactionHistoryFilterSend,
                              ui.filter == TransactionHistoryListFilter.send,
                              () => notifier.setFilter(
                                  TransactionHistoryListFilter.send),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              l10n.transactionHistoryFilterReceive,
                              ui.filter ==
                                  TransactionHistoryListFilter.receive,
                              () => notifier.setFilter(
                                TransactionHistoryListFilter.receive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: ui.listLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ui.loadError != null
                      ? _buildErrorState(theme, l10n, _loadErrorMessage(l10n, ui.loadError!))
                      : filtered.isEmpty
                          ? _buildEmptyState(theme, l10n, ui.filter)
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                8,
                                16,
                                24,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: TransactionHistoryItem(
                                    transaction: filtered[index],
                                    l10n: l10n,
                                    effectiveChain: displayChain,
                                    onCopy: _copyToClipboard,
                                    onOpenTxInExplorer: _openTxInExplorer,
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChainSelector(
    ThemeData theme,
    Chain? chain,
    AppLocalizations l10n,
  ) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final picker = ref.watch(transactionHistoryPickerChainsProvider);
    return PopupMenuButton<Chain>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? scheme.outlineVariant : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChainNetworkLogo(
              chainLogoUrl: chain?.chainLogo,
              fallbackColor: chain?.colorValue ?? 0xFF6b7280,
              fallbackLabel: chain?.icon ??
                  (chain?.displayNameOrName.isNotEmpty == true
                      ? chain!.displayNameOrName[0]
                      : '?'),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              chain?.displayNameOrName ?? l10n.transactionHistorySelectChain,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      itemBuilder: (context) {
        return picker.map((c) {
          return PopupMenuItem<Chain>(
            value: c,
            onTap: () => _onChainSelected(c),
            child: Row(
              children: [
                ChainNetworkLogo(
                  chainLogoUrl: c.chainLogo,
                  fallbackColor: c.colorValue,
                  fallbackLabel: c.icon ??
                      (c.displayNameOrName.isNotEmpty
                          ? c.displayNameOrName[0]
                          : '?'),
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c.displayNameOrName,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      if (c.description != null)
                        Text(c.description!,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                if (chain?.id == c.id)
                  const Icon(Icons.check_circle,
                      color: Color(0xFF16a34a), size: 20),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildStatItem(
      String label, String value, TextTheme textTheme, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFF059669).withValues(alpha: 0.2),
      checkmarkColor: const Color(0xFF059669),
    );
  }

  String _loadErrorMessage(AppLocalizations l10n, String code) {
    if (code == transactionHistoryLoadErrorConnectEvm) {
      return l10n.transactionHistoryConnectEvm;
    }
    if (code == transactionHistoryLoadErrorUnsupportedNetwork) {
      return l10n.transactionHistoryUnsupportedNetwork;
    }
    return code;
  }

  Widget _buildErrorState(
    ThemeData theme,
    AppLocalizations l10n,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_outlined, size: 48, color: Colors.grey[600]),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref
                  .read(transactionHistoryControllerProvider.notifier)
                  .load(parentChain: widget.currentChain),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeData theme,
    AppLocalizations l10n,
    TransactionHistoryListFilter filter,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.filter_list_rounded,
                  size: 40, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.transactionHistoryEmptyTitle,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              filter != TransactionHistoryListFilter.all
                  ? l10n.transactionHistoryEmptyHintFiltered
                  : l10n.transactionHistoryEmptyHintAll,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}
