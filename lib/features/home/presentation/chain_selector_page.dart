import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/features/home/application/chain_selector_provider.dart';
import 'package:chain_notes/features/home/presentation/chain_selector_avg_gas_display.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

Color _chainSelectorRowBackground(
  ThemeData theme, {
  required bool isSelected,
  required Color lightSelected,
}) {
  final scheme = theme.colorScheme;
  if (theme.brightness == Brightness.light) {
    return isSelected ? lightSelected : scheme.surface;
  }
  if (isSelected) {
    return Color.alphaBlend(
      scheme.primary.withValues(alpha: 0.22),
      scheme.surfaceContainerHighest,
    );
  }
  return scheme.surfaceContainerHighest;
}

class ChainSelectorPage extends ConsumerStatefulWidget {
  const ChainSelectorPage({
    super.key,
    required this.currentChain,
    required this.onBack,
    required this.onChainSelect,
    this.showAllChainsOption = false,
    this.currentChainId,
  });

  final Chain? currentChain;
  final VoidCallback onBack;

  final ValueChanged<Chain?> onChainSelect;

  final bool showAllChainsOption;

  final int? currentChainId;

  @override
  ConsumerState<ChainSelectorPage> createState() => _ChainSelectorPageState();
}

class _ChainSelectorPageState extends ConsumerState<ChainSelectorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color _blue600 = Color(0xFF2563eb);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleSelectChain(Chain chain) {
    widget.onChainSelect(chain);
  }

  void _handleSelectAllChains() {
    widget.onChainSelect(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final mainnetChains = ref.watch(chainSelectorMainnetChainsProvider);
    final testnetChains = ref.watch(chainSelectorTestnetChainsProvider);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeaderWithBack(
              onBack: widget.onBack,
              title: l10n.selectNetwork,
              subtitle: l10n.selectNetworkSubtitle,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              backBackgroundColor: isDark
                  ? scheme.surfaceContainerHighest
                  : Colors.grey[100],
              backIconColor:
                  isDark ? scheme.onSurface : const Color(0xFF374151),
              leadingIcon: Icons.menu_book_outlined,
              leadingIconColor:
                  isDark ? scheme.onSurfaceVariant : Colors.grey[600],
              leadingIconSize: 22,
              spacingAfterTitleLeading: 8,
              subtitleSpacing: 4,
              titleStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: isDark ? scheme.onSurface : null,
              ),
              trailing: IconButton(
                onPressed: () => context.push(AppRoutes.networkSettings),
                icon: const Icon(Icons.hub_outlined, size: 22),
                iconSize: 22,
                color: isDark ? scheme.primary : _blue600,
                tooltip: l10n.networkSettingsTitle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 40,
                  height: 40,
                ),
                alignment: Alignment.center,
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

            TabBar(
              controller: _tabController,
              labelStyle: theme.textTheme.labelLarge,
              indicatorColor: _blue600,
              labelColor: _blue600,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              tabs: [
                Tab(text: l10n.chainSelectorMainnetTab),
                Tab(text: l10n.chainSelectorTestnetTab),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ChainList(
                    chains: mainnetChains,
                    currentChain: widget.currentChain,
                    currentChainId: widget.currentChainId,
                    onSelect: _handleSelectChain,
                    showAllChainsOption: widget.showAllChainsOption,
                    onSelectAllChains: widget.showAllChainsOption ? _handleSelectAllChains : null,
                  ),
                  _ChainList(
                    chains: testnetChains,
                    currentChain: widget.currentChain,
                    currentChainId: widget.currentChainId,
                    onSelect: _handleSelectChain,
                    onSelectAllChains: widget.showAllChainsOption ? _handleSelectAllChains : null,
                    showAllChainsOption: widget.showAllChainsOption,
                    showTestnetNotice: true,
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: (Theme.of(context).extension<AppBrandTheme>() ??
                        AppBrandTheme.light)
                    .pageBackground,
                border: Border(top: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.chainSelectorFooterHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChainList extends StatelessWidget {
  const _ChainList({
    required this.chains,
    required this.currentChain,
    required this.onSelect,
    this.currentChainId,
    this.showAllChainsOption = false,
    this.onSelectAllChains,
    this.showTestnetNotice = false,
  });

  final List<Chain> chains;
  final Chain? currentChain;
  final int? currentChainId;
  final ValueChanged<Chain> onSelect;
  final bool showAllChainsOption;
  final VoidCallback? onSelectAllChains;
  final bool showTestnetNotice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        if (showAllChainsOption && onSelectAllChains != null) ...[
          _AllChainsCard(
            isSelected: chainSelectorIsAllChainsRowSelected(
              showAllChainsOption: showAllChainsOption,
              currentChainId: currentChainId,
            ),
            onTap: onSelectAllChains!,
          ),
          const SizedBox(height: 8),
        ],
        if (showTestnetNotice) ...[
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.chainSelectorTestnetNoticeTitle,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade900,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.chainSelectorTestnetNoticeBody,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        ...chains.map(
          (chain) => _ChainCard(
            chain: chain,
            isSelected: chainSelectorIsChainRowSelected(
              chain: chain,
              currentChain: currentChain,
              currentChainId: currentChainId,
              showAllChainsOption: showAllChainsOption,
            ),
            onTap: () => onSelect(chain),
          ),
        ),
      ],
    );
  }
}

class _AllChainsCard extends StatelessWidget {
  const _AllChainsCard({
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  static const Color _blue500 = Color(0xFF3b82f6);
  static const Color _blue50 = Color(0xFFeff6ff);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bg = _chainSelectorRowBackground(
      theme,
      isSelected: isSelected,
      lightSelected: _blue50,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: _blue500, width: 2) : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9ca3af), Color(0xFF4b5563)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.public,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.chainSelectorAllChainsTitle,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.check_circle, size: 18, color: _blue500),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.chainSelectorAllChainsSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChainCard extends ConsumerWidget {
  const _ChainCard({
    required this.chain,
    required this.isSelected,
    required this.onTap,
  });

  final Chain chain;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _blue500 = Color(0xFF3b82f6);
  static const Color _blue50 = Color(0xFFeff6ff);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bg = _chainSelectorRowBackground(
      theme,
      isSelected: isSelected,
      lightSelected: _blue50,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 0 : 0,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: _blue500, width: 2) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChainNetworkLogo(
                      chainLogoUrl: chain.chainLogo,
                      fallbackColor: chain.colorValue,
                      fallbackLabel: chain.icon ??
                          (chain.name.isNotEmpty ? chain.name[0] : '?'),
                      size: 48,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  chain.displayNameOrName.isNotEmpty
                                      ? chain.displayNameOrName
                                      : '-',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: _blue500,
                                ),
                              ],
                            ],
                          ),
                          if (chain.chainId != null)
                            Text(
                              l10n.chainSelectorChainIdLabel(chain.chainId!),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _blue500,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.chainSelectorCurrentBadge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                if (chain.description != null &&
                    chain.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    chain.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      l10n.chainSelectorGasLabel(
                        localizedAvgGasCostForSelector(chain, l10n),
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 12),
                      Icon(
                        Icons.speed_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ref
                            .watch(chainSelectorRpcLatencyProvider(chain.id))
                            .when(
                              data: (ms) => ms != null
                                  ? l10n.networkNodeLatencyMs(ms)
                                  : '—',
                              loading: () => '…',
                              error: (_, _) => '—',
                            ),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),
                    Icon(Icons.circle, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      chain.symbol.isNotEmpty ? chain.symbol : '-',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (chain.isTestnet) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.chainSelectorTestnetChainWarning,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
