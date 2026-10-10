import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

const List<int> kMnemonicLengths = [12, 15, 18, 21, 24];

class WalletMnemonicWordCountChipButton extends StatelessWidget {
  const WalletMnemonicWordCountChipButton({
    super.key,
    required this.wordCount,
    required this.onWordCountChanged,
  });

  final int wordCount;
  final ValueChanged<int> onWordCountChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark
        ? theme.colorScheme.onSurfaceVariant
        : const Color(0xFF6b7280);
    final hoverBg = isDark
        ? theme.colorScheme.onSurface.withValues(alpha: 0.06)
        : const Color(0xFFf3f4f6);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final selected = await showWalletMnemonicWordCountDialog(
            context,
            currentCount: wordCount,
          );
          if (selected != null && selected != wordCount) {
            onWordCountChanged(selected);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.walletImportWordCountSwitched(selected)),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        },
        borderRadius: BorderRadius.circular(6),
        hoverColor: hoverBg,
        splashColor: hoverBg,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune_rounded, size: 14, color: labelColor),
              const SizedBox(width: 4),
              Text(
                l10n.walletImportWordCountN(wordCount),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                  height: 1.2,
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: labelColor),
            ],
          ),
        ),
      ),
    );
  }
}

Future<int?> showWalletMnemonicWordCountDialog(
  BuildContext context, {
  required int currentCount,
}) {
  return showDialog<int>(
    context: context,
    builder: (dialogContext) => _WalletMnemonicWordCountDialog(
      currentCount: currentCount,
    ),
  );
}

class _WalletMnemonicWordCountDialog extends StatelessWidget {
  const _WalletMnemonicWordCountDialog({required this.currentCount});

  final int currentCount;

  String _securityLevel(AppLocalizations l10n, int count) {
    return switch (count) {
      12 => l10n.walletImportWordCountSecurityStandard,
      15 => l10n.walletImportWordCountSecurityEnhanced,
      18 => l10n.walletImportWordCountSecurityAdvanced,
      21 => l10n.walletImportWordCountSecurityProfessional,
      _ => l10n.walletImportWordCountSecurityMaximum,
    };
  }

  Color _securityColor(int count) {
    return switch (count) {
      12 => const Color(0xFF2563eb),
      15 => const Color(0xFF16a34a),
      18 => const Color(0xFFca8a04),
      21 => const Color(0xFFea580c),
      _ => const Color(0xFFdc2626),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.9;
    const dialogMaxWidth = 384.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth.clamp(280, dialogMaxWidth),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.tag_rounded, size: 20, color: Color(0xFF16a34a)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.walletImportWordCountDialogTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.walletImportWordCountDialogDesc,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? theme.colorScheme.onSurfaceVariant
                      : const Color(0xFF6b7280),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              ...kMnemonicLengths.map((count) {
                final selected = currentCount == count;
                final securityColor = _securityColor(count);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(count),
                      borderRadius: BorderRadius.circular(12),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: selected
                              ? (isDark
                                    ? const Color(0xFF14532d).withValues(alpha: 0.35)
                                    : const Color(0xFFf0fdf4))
                              : (isDark
                                    ? theme.colorScheme.surfaceContainerHighest
                                    : Colors.white),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF16a34a)
                                : (isDark
                                      ? theme.colorScheme.outline
                                      : const Color(0xFFe5e7eb)),
                            width: 2,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: selected
                                    ? const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF22c55e),
                                          Color(0xFF0d9488),
                                        ],
                                      )
                                    : null,
                                color: selected
                                    ? null
                                    : (isDark
                                          ? theme.colorScheme.surfaceContainerHigh
                                          : const Color(0xFFf3f4f6)),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? Colors.white
                                      : (isDark
                                            ? theme.colorScheme.onSurfaceVariant
                                            : const Color(0xFF4b5563)),
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
                                          l10n.walletImportWordCountOptionLabel(count),
                                          style: theme.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? theme.colorScheme.onSurface
                                                : const Color(0xFF111827),
                                          ),
                                        ),
                                      ),
                                      if (selected) ...[
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.check_rounded,
                                          size: 16,
                                          color: Color(0xFF16a34a),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.walletImportWordCountSecurityLabel,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: isDark
                                              ? theme.colorScheme.onSurfaceVariant
                                              : const Color(0xFF6b7280),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        _securityLevel(l10n, count),
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: securityColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
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
                  ),
                );
              }),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1e3a8a).withValues(alpha: 0.25)
                      : const Color(0xFFeff6ff),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF3b82f6).withValues(alpha: 0.35)
                        : const Color(0xFFbfdbfe),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF93c5fd)
                          : const Color(0xFF2563eb),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.walletImportWordCountDialogTip,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? const Color(0xFFdbeafe)
                              : const Color(0xFF1e3a8a),
                          height: 1.45,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
