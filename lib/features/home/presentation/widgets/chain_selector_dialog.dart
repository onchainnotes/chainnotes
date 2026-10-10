import 'package:flutter/material.dart';
import 'package:chain_notes/features/home/presentation/chain_selector_avg_gas_display.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
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

void showChainSelector(
  BuildContext context, {
  required Chain? currentChain,
  required ValueChanged<Chain> onChainSelect,
}) {
  showDialog<void>(
    context: context,
    builder: (ctx) => _ChainSelectorDialog(
      currentChain: currentChain,
      onChainSelect: (chain) {
        onChainSelect(chain);
        Navigator.of(ctx).pop();
      },
      onClose: () => Navigator.of(ctx).pop(),
    ),
  );
}

class _ChainSelectorDialog extends StatefulWidget {
  const _ChainSelectorDialog({
    required this.currentChain,
    required this.onChainSelect,
    required this.onClose,
  });

  final Chain? currentChain;
  final ValueChanged<Chain> onChainSelect;
  final VoidCallback onClose;

  @override
  State<_ChainSelectorDialog> createState() => _ChainSelectorDialogState();
}

class _ChainSelectorDialogState extends State<_ChainSelectorDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.selectNetwork,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.selectNetworkSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TabBar(
              controller: _tabController,
              labelStyle: theme.textTheme.labelLarge,
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
                    chains: ChainFromDemo.mainnetChains,
                    currentChain: widget.currentChain,
                    onSelect: widget.onChainSelect,
                  ),
                  _ChainList(
                    chains: ChainFromDemo.testnetChains,
                    currentChain: widget.currentChain,
                    onSelect: widget.onChainSelect,
                    showTestnetNotice: true,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
              ),
              child: Row(
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
    this.showTestnetNotice = false,
  });

  final List<Chain> chains;
  final Chain? currentChain;
  final ValueChanged<Chain> onSelect;
  final bool showTestnetNotice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
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
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.chainSelectorTestnetNoticeBody,
                        style: theme.textTheme.bodySmall?.copyWith(
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
            isSelected: currentChain?.id == chain.id,
            onTap: () => onSelect(chain),
          ),
        ),
      ],
    );
  }
}

class _ChainCard extends StatelessWidget {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(chain.colorValue),
                            Color(chain.colorValue).withValues(alpha: 0.85),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        chain.icon ?? (chain.name.isNotEmpty ? chain.name[0] : '?'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                    const SizedBox(width: 12),
                    Icon(Icons.flash_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      chain.blockTime.isNotEmpty ? chain.blockTime : '-',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
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
