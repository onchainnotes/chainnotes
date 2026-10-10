import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void showGetGasModal(
  BuildContext context, {
  required String chainName,
  required String tokenSymbol,
  required String walletAddress,
  List<String>? faucetUrls,
}) {
  showDialog<void>(
    context: context,
    builder: (ctx) => _GetGasDialog(
      chainName: chainName,
      tokenSymbol: tokenSymbol,
      walletAddress: walletAddress,
      faucetUrls: faucetUrls ?? const [],
      onClose: () => Navigator.of(ctx).pop(),
    ),
  );
}

class _GetGasDialog extends StatefulWidget {
  const _GetGasDialog({
    required this.chainName,
    required this.tokenSymbol,
    required this.walletAddress,
    required this.faucetUrls,
    required this.onClose,
  });

  final String chainName;
  final String tokenSymbol;
  final String walletAddress;
  final List<String> faucetUrls;
  final VoidCallback onClose;

  @override
  State<_GetGasDialog> createState() => _GetGasDialogState();
}

class _GetGasDialogState extends State<_GetGasDialog> {
  bool _copied = false;

  bool _showQrPanel = true;

  void _copyAddress() {
    Clipboard.setData(ClipboardData(text: widget.walletAddress));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.getGasAddressCopied)),
    );
  }

  Future<void> _goToFaucet(String url) async {
    final l10n = AppLocalizations.of(context)!;
    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.getGasInvalidLink)),
        );
      }
      return;
    }
    try {

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched && mounted) {
        widget.onClose();
      } else if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.getGasCouldNotOpenLink)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.getGasOpenFailed(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.getGasDialogTitle(widget.tokenSymbol)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.getGasDialogSubtitle(widget.chainName),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            _GasOptionCard(
              icon: Icons.download,
              iconColor: Colors.blue,
              title: l10n.getGasOptionReceiveTitle,
              badge: l10n.getGasBadgeRecommended,
              badgeColor: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.getGasReceiveHint(widget.tokenSymbol),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.getGasWalletAddressLabel,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => setState(
                                () => _showQrPanel = !_showQrPanel,
                              ),
                              icon: Icon(
                                _showQrPanel
                                    ? Icons.visibility_off_outlined
                                    : Icons.qr_code,
                                size: 16,
                              ),
                              label: Text(
                                _showQrPanel
                                    ? l10n.getGasHideQr
                                    : l10n.getGasShowQr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                minimumSize: const Size(0, 28),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                child: Text(
                                  widget.walletAddress,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _copyAddress,
                              icon: Icon(
                                _copied ? Icons.check : Icons.copy,
                                size: 18,
                                color: _copied ? Colors.green : null,
                              ),
                              style: IconButton.styleFrom(
                                minimumSize: const Size(32, 32),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        if (_showQrPanel) ...[
                          const SizedBox(height: 12),
                          Center(
                            child: Container(
                              width: 168,
                              height: 168,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: widget.walletAddress.trim().isEmpty
                                  ? Icon(
                                      Icons.qr_code_2,
                                      size: 72,
                                      color: Colors.grey[400],
                                    )
                                  : QrImageView(
                                      data: widget.walletAddress.trim(),
                                      version: QrVersions.auto,
                                      size: 152,
                                      gapless: true,
                                      backgroundColor: Colors.white,
                                      eyeStyle: const QrEyeStyle(
                                        eyeShape: QrEyeShape.square,
                                        color: Color(0xFF111827),
                                      ),
                                      dataModuleStyle: const QrDataModuleStyle(
                                        dataModuleShape:
                                            QrDataModuleShape.square,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('⚠️', style: theme.textTheme.bodySmall),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                l10n.getGasTransferWarning(widget.chainName),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.amber.shade800,
                                ),
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
            if (widget.faucetUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              _GasOptionCard(
                icon: Icons.water_drop,
                iconColor: Colors.teal,
                title: l10n.getGasFaucetTitle,
                badge: l10n.getGasBadgeFree,
                badgeColor: Colors.teal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.getGasFaucetHint(widget.tokenSymbol),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.faucetUrls.asMap().entries.map((e) {
                      final i = e.key + 1;
                      final url = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: InkWell(
                          onTap: () => _goToFaucet(url),
                          borderRadius: BorderRadius.circular(6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.open_in_new,
                                size: 14,
                                color: Colors.teal.shade700,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l10n.getGasFaucetOpen(i),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.teal.shade700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
            if (kDebugMode) ...[
              const SizedBox(height: 12),
              Opacity(
                opacity: 0.6,
                child: _GasOptionCard(
                  icon: Icons.open_in_new,
                  iconColor: Colors.green,
                  title: l10n.getGasBuyExchangeTitle,
                  badge: l10n.getGasBadgeComingSoon,
                  badgeColor: Colors.grey,
                  child: Text(
                    l10n.getGasBuyExchangeHint(widget.tokenSymbol),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onClose,
          child: Text(l10n.getGasDialogCancel),
        ),
      ],
    );
  }
}

class _GasOptionCard extends StatelessWidget {
  const _GasOptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.badge,
    this.badgeColor,
    required this.child,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? badge;
  final Color? badgeColor;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: (badgeColor ?? theme.colorScheme.primary)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: badgeColor ?? theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                child,
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: content,
        ),
      );
    }
    return content;
  }
}
