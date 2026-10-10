import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

typedef SaveType = NoteType;

class SaveOptionsDialog extends StatelessWidget {
  const SaveOptionsDialog({
    super.key,
    required this.currentChain,
    required this.onSave,
  });

  final Chain? currentChain;

  final Future<bool> Function(SaveType type) onSave;

  static Future<SaveType?> show(
    BuildContext context, {
    required Chain? currentChain,
    required Future<bool> Function(SaveType type) onSave,
  }) {
    return showDialog<SaveType>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SaveOptionsDialog(
        currentChain: currentChain,
        onSave: onSave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.saveOptionsTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.saveOptionsSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Options
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _SaveOptionCard(
                      type: SaveType.onchain,
                      icon: Icons.link,
                      title: l10n.saveOnChainTitle,
                      description: l10n.saveOnChainDescription,
                      color: const Color(0xFF059669),
                      features: [
                        l10n.saveOnChainFeature1,
                        l10n.saveOnChainFeature2,
                        l10n.saveOnChainFeature3,
                      ],
                      badge: l10n.saveBadgeSecure,
                      disabled: currentChain == null,
                      disabledReason: l10n.selectBlockchainFirst,
                      currentChain: currentChain,
                      onTap: (t) => _handleSave(context, t),
                    ),
                    const SizedBox(height: 12),
                    _SaveOptionCard(
                      type: SaveType.draft,
                      icon: Icons.edit_note,
                      title: l10n.saveDraftTitle,
                      description: l10n.saveDraftDescription,
                      color: const Color(0xFFeab308),
                      features: [
                        l10n.saveDraftFeature1,
                        l10n.saveDraftFeature2,
                        l10n.saveDraftFeature3,
                      ],
                      badge: l10n.saveBadgeRecommended,
                      onTap: (t) => _handleSave(context, t),
                    ),
                    const SizedBox(height: 12),
                    _SaveOptionCard(
                      type: SaveType.local,
                      icon: Icons.description,
                      title: l10n.saveLocalTitle,
                      description: l10n.saveLocalDescription,
                      color: const Color(0xFF2563eb),
                      features: [
                        l10n.saveLocalFeature1,
                        l10n.saveLocalFeature2,
                        l10n.saveLocalFeature3,
                      ],
                      badge: null,
                      onTap: (t) => _handleSave(context, t),
                    ),
                  ],
                ),
              ),
            ),
            // Cancel button
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave(BuildContext context, SaveType type) async {
    final completed = await onSave(type);
    if (!context.mounted) return;
    if (completed) {
      Navigator.of(context).pop(type);
    } else {
      Navigator.of(context).pop();
    }
  }
}

class _SaveOptionCard extends StatefulWidget {
  const _SaveOptionCard({
    required this.type,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.features,
    required this.onTap,
    this.badge,
    this.disabled = false,
    this.disabledReason,
    this.currentChain,
  });

  final SaveType type;
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<String> features;
  final String? badge;
  final bool disabled;
  final String? disabledReason;
  final Chain? currentChain;
  final Future<void> Function(SaveType type) onTap;

  @override
  State<_SaveOptionCard> createState() => _SaveOptionCardState();
}

class _SaveOptionCardState extends State<_SaveOptionCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.disabled || _isLoading;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : () => _onTap(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color,
                      widget.color.withValues(alpha: 0.8),
                    ],
                  ),
                borderRadius: BorderRadius.circular(12),
                ),
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(widget.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.badge != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: widget.color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.badge!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: widget.features.map((f) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: widget.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check, size: 12, color: widget.color),
                              const SizedBox(width: 4),
                              Text(
                                f,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: widget.color,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    if (widget.disabled && widget.disabledReason != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 14, color: Colors.orange.shade700),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.disabledReason!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (widget.type == SaveType.onchain &&
                        widget.currentChain != null) ...[
                      const SizedBox(height: 8),
                      Builder(
                        builder: (ctx) {
                          final l10n = AppLocalizations.of(ctx)!;
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Row(
                              children: [
                                ChainNetworkLogo(
                                  chainLogoUrl: widget.currentChain!.chainLogo,
                                  fallbackColor: widget.currentChain!.colorValue,
                                  fallbackLabel: widget.currentChain!.icon ??
                                      widget.currentChain!.name.substring(0, 1),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.saveWillPublishToChain(
                                      widget.currentChain!.displayNameOrName,
                                    ),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTap() async {
    setState(() => _isLoading = true);
    try {
      await widget.onTap(widget.type);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
