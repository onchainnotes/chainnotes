import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:chain_notes/features/home/application/transaction_history_provider.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

String _formatTxAddress(String address) {
  if (address.isEmpty) return '';
  if (address.length < 10) return address;
  return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
}

String _formatTxTime(int timestamp, AppLocalizations l10n) {
  final diff = DateTime.now().millisecondsSinceEpoch - timestamp;
  final minutes = diff ~/ 60000;
  final hours = diff ~/ 3600000;
  final days = diff ~/ 86400000;
  if (minutes < 1) return l10n.transactionHistoryTimeJustNow;
  if (minutes < 60) return l10n.transactionHistoryTimeMinutesAgo(minutes);
  if (hours < 24) return l10n.transactionHistoryTimeHoursAgo(hours);
  return l10n.transactionHistoryTimeDaysAgo(days);
}

class TransactionHistoryItem extends StatelessWidget {
  const TransactionHistoryItem({
    super.key,
    required this.transaction,
    required this.l10n,
    this.effectiveChain,
    required this.onCopy,
    required this.onOpenTxInExplorer,
  });

  final TransactionRecord transaction;
  final AppLocalizations l10n;
  final Chain? effectiveChain;
  final void Function(String text) onCopy;
  final void Function(String explorerBase, String txHash) onOpenTxInExplorer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tx = transaction;
    final isReceive = tx.type == TransactionType.receive;
    final explorerBase = blockExplorerForChainId(effectiveChain?.chainId);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isReceive ? Colors.green[50] : Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isReceive
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    size: 20,
                    color: isReceive ? Colors.green[700] : Colors.red[700],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Flexible(
                                  child: AutoSizeText(
                                    isReceive
                                        ? l10n.transactionHistoryTypeReceive
                                        : l10n.transactionHistoryTypeSend,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    maxFontSize: 14,
                                    minFontSize: 8,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: _TransactionHistoryStatusBadge(
                                      status: tx.status,
                                      l10n: l10n,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                '${isReceive ? '+' : '-'}${tx.amount} ${tx.symbol}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isReceive
                                      ? const Color(0xFF16a34a)
                                      : Colors.grey[800],
                                ),
                                maxLines: 1,
                                maxFontSize: 18,
                                minFontSize: 10,
                                softWrap: false,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: AutoSizeText(
                              _formatTxTime(tx.timestamp, l10n),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              maxFontSize: 12,
                              minFontSize: 6,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: tx.gasFee != null &&
                                      tx.status == TransactionStatus.success
                                  ? Text(
                                      l10n.transactionHistoryGasLine(
                                        tx.gasFee!,
                                        tx.symbol,
                                      ),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      softWrap: false,
                                      textAlign: TextAlign.end,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _TransactionHistoryDetailRow(
              label: l10n.transactionHistoryDetailFrom,
              value: tx.from,
              onCopy: () => onCopy(tx.from),
            ),
            _TransactionHistoryDetailRow(
              label: l10n.transactionHistoryDetailTo,
              value: tx.to,
              onCopy: () => onCopy(tx.to),
            ),
            _TransactionHistoryDetailRow(
              label: l10n.transactionHistoryDetailTxHash,
              value: _formatTxAddress(tx.hash),
              onCopy: () => onCopy(tx.hash),
              onExternal: explorerBase != null
                  ? () => onOpenTxInExplorer(explorerBase, tx.hash)
                  : null,
            ),
            if (tx.blockNumber != null)
              _TransactionHistoryDetailRow(
                label: l10n.transactionHistoryDetailBlock,
                value: '#${tx.blockNumber}',
              ),
          ],
        ),
      ),
    );
  }
}

class _TransactionHistoryStatusBadge extends StatelessWidget {
  const _TransactionHistoryStatusBadge({
    required this.status,
    required this.l10n,
  });

  final TransactionStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    String label;
    Color bg;
    Color fg;
    switch (status) {
      case TransactionStatus.success:
        label = l10n.transactionHistoryStatusSuccess;
        bg = const Color(0xFFdcfce7);
        fg = const Color(0xFF166534);
        break;
      case TransactionStatus.failed:
        label = l10n.transactionHistoryStatusFailed;
        bg = const Color(0xFFfee2e2);
        fg = const Color(0xFFdc2626);
        break;
      case TransactionStatus.pending:
        label = l10n.transactionHistoryStatusPending;
        bg = const Color(0xFFfef3c7);
        fg = const Color(0xFFb45309);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}

class _TransactionHistoryDetailRow extends StatelessWidget {
  const _TransactionHistoryDetailRow({
    required this.label,
    required this.value,
    this.onCopy,
    this.onExternal,
  });

  final String label;
  final String value;
  final VoidCallback? onCopy;
  final VoidCallback? onExternal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onCopy != null)
            IconButton(
              onPressed: onCopy,
              icon: const Icon(Icons.copy_rounded, size: 16),
              style: IconButton.styleFrom(
                minimumSize: const Size(32, 32),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          if (onExternal != null)
            IconButton(
              onPressed: onExternal,
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              style: IconButton.styleFrom(
                minimumSize: const Size(32, 32),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }
}
