import 'package:flutter/material.dart';
import 'package:chain_notes/common/config/app_display_switches.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

const Color _kWalletSelectorBlue50 = Color(0xFFeff6ff);
const Color _kWalletSelectorTeal500 = Color(0xFF14b8a6);
const Color _kWalletSelectorBlue600 = Color(0xFF2563eb);

String _walletSelectorShortAddress(String address) {
  if (address.length < 10) return address;
  return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
}

class WalletSelectorDialogItemView extends StatelessWidget {
  const WalletSelectorDialogItemView({super.key,
    required this.theme,
    required this.scheme,
    required this.isDark,
    required this.wallet,
    required this.isCurrent,
    required this.onTap,
    required this.onEdit,
    required this.onCopy,
    this.onDelete,
    required this.onBackup,
  });

  final ThemeData theme;
  final ColorScheme scheme;
  final bool isDark;
  final WalletSelectorItem wallet;
  final bool isCurrent;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onCopy;

  final VoidCallback? onDelete;
  final VoidCallback onBackup;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardBg = isCurrent
        ? (isDark
        ? Color.alphaBlend(
      _kWalletSelectorBlue600.withValues(alpha: 0.18),
      scheme.surfaceContainerHighest,
    )
        : _kWalletSelectorBlue50)
        : (isDark ? scheme.surface : Colors.white);

    final cardBorder =
    isCurrent ? Border.all(color: _kWalletSelectorBlue600, width: 2) : null;

    final shadow = isDark || isCurrent
        ? <BoxShadow>[]
        : [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];

    final chipBg =
    isDark ? scheme.surfaceContainerHighest : const Color(0xFFf3f4f6);
    final addrColor =
    isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);
    final balanceColor =
    isDark ? scheme.onSurface : const Color(0xFF374151);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: cardBorder,
              boxShadow: shadow,
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
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? scheme.surface : Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF3b82f6), _kWalletSelectorTeal500],
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
                          fontSize: 14,
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: scheme.onSurface,
                                  ),
                                ),
                              ),
                              if (isCurrent) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.check_rounded,
                                    size: 16, color: _kWalletSelectorBlue600),
                              ],
                              if (wallet.isImported) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chipBg,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    l10n.imported,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 12,
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _walletSelectorShortAddress(wallet.address),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              color: addrColor,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppDisplaySwitches.displayStoredWalletBalance(
                              wallet.balance,
                            ),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: balanceColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_outlined, size: 14),
                          style: IconButton.styleFrom(
                            foregroundColor: _kWalletSelectorBlue600,
                            minimumSize: const Size(28, 28),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        IconButton(
                          onPressed: onCopy,
                          icon: const Icon(Icons.copy_rounded, size: 14),
                          style: IconButton.styleFrom(
                            foregroundColor: scheme.onSurfaceVariant,
                            minimumSize: const Size(28, 28),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        if (onDelete != null)
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 14,
                            ),
                            style: IconButton.styleFrom(
                              foregroundColor: const Color(0xFFdc2626),
                              minimumSize: const Size(28, 28),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (!wallet.isBackedUp) ...[
                  const SizedBox(height: 8),
                  _WalletSelectorBackupBanner(
                    theme: theme,
                    isDark: isDark,
                    onBackup: onBackup,
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  _WalletSelectorBackedUpRow(theme: theme, isDark: isDark, l10n: l10n),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletSelectorBackupBanner extends StatelessWidget {
  const _WalletSelectorBackupBanner({
    required this.theme,
    required this.isDark,
    required this.onBackup,
  });

  final ThemeData theme;
  final bool isDark;
  final VoidCallback onBackup;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = theme.colorScheme;
    final bg = isDark
        ? Color.alphaBlend(
      Colors.amber.withValues(alpha: 0.12),
      scheme.surfaceContainerHighest,
    )
        : const Color(0xFFfefce8);
    final borderColor =
    isDark ? Colors.amber.withValues(alpha: 0.45) : const Color(0xFFfde047);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onBackup,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: isDark ? Colors.amber.shade400 : Colors.amber.shade700,
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
                            ? Colors.amber.shade100
                            : const Color(0xFF92400e),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      l10n.walletBackupPromptLine2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? Colors.amber.shade200
                            : const Color(0xFFb45309),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: isDark ? Colors.amber.shade400 : Colors.amber.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletSelectorBackedUpRow extends StatelessWidget {
  const _WalletSelectorBackedUpRow({
    required this.theme,
    required this.isDark,
    required this.l10n,
  });

  final ThemeData theme;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final bg = isDark
        ? Color.alphaBlend(
      Colors.green.withValues(alpha: 0.12),
      scheme.surfaceContainerHighest,
    )
        : const Color(0xFFf0fdf4);
    final border =
    isDark ? Colors.green.withValues(alpha: 0.4) : const Color(0xFF86efac);
    final fg = isDark ? Colors.green.shade300 : Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_rounded, size: 16, color: fg),
          const SizedBox(width: 8),
          Text(
            l10n.backedUp,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: fg,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

