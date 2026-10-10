import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/note/application/note_on_chain_confirm_provider.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:chain_notes/features/note/application/note_on_chain_confirm_provider.dart'
    show
        NoteOnChainConfirmArgs,
        NoteOnChainConfirmPop,
        NoteOnChainConfirmResult,
        NotePublishResult;

({String label, IconData icon, Color color, Color bg, String time})
    noteOnChainConfirmGasVisual(
  AppLocalizations l10n,
  NoteOnChainUiGasSpeed s,
  bool isDark,
) {
  final base = noteOnChainGasVisual(s, isDark);
  final label = switch (s) {
    NoteOnChainUiGasSpeed.slow => l10n.noteOnChainConfirmGasSlow,
    NoteOnChainUiGasSpeed.fast => l10n.noteOnChainConfirmGasFast,
    NoteOnChainUiGasSpeed.normal => l10n.noteOnChainConfirmGasNormal,
  };
  final time = switch (s) {
    NoteOnChainUiGasSpeed.slow => l10n.noteOnChainConfirmGasTimeSlow,
    NoteOnChainUiGasSpeed.fast => l10n.noteOnChainConfirmGasTimeFast,
    NoteOnChainUiGasSpeed.normal => l10n.noteOnChainConfirmGasTimeNormal,
  };
  return (
    label: label,
    icon: base.icon,
    color: base.color,
    bg: base.bg,
    time: time,
  );
}

Future<bool> showGasOnChainRiskConfirmDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return AlertDialog(
        title: Text(l10n.gasOnChainConfirmDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.gasOnChainConfirmDialogBody),
              const SizedBox(height: 16),
              Text(
                l10n.gasOnChainConfirmDialogQuestion,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

class NoteOnChainConfirmPage extends ConsumerStatefulWidget {
  const NoteOnChainConfirmPage({
    super.key,
    required this.args,
    this.onExecutePublish,
  });

  final NoteOnChainConfirmArgs args;

  final Future<NotePublishResult> Function(String masterKeyBase64)?
      onExecutePublish;

  @override
  ConsumerState<NoteOnChainConfirmPage> createState() =>
      _NoteOnChainConfirmPageState();
}

class _NoteOnChainConfirmPageState extends ConsumerState<NoteOnChainConfirmPage> {
  bool _confirmBusy = false;

  static const _headerGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF0d9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.transactionHistoryCopied),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onGasRowTap() {
    context.pop(const NoteOnChainConfirmPop.requestChangeGas());
  }

  Future<void> _openContractInExplorer(String? explorerUrl, String address) async {
    final trimmed = explorerUrl?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.noteOnChainConfirmNoExplorer),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final base = trimmed.replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.tryParse('$base/address/$address');
    if (uri == null) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.transactionHistoryExplorerInvalidUrl),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.transactionHistoryExplorerLaunchFailed),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.transactionHistoryExplorerLaunchFailed),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleConfirm() async {
    if (_confirmBusy) return;
    final args = widget.args;
    final intentOnly = args.intentOnly;
    final publish = widget.onExecutePublish;

    if (intentOnly) {
      final masterKey = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const PasswordVerifyDialog(
          purpose: PasswordVerifyPurpose.mintNft,
        ),
      );
      if (!mounted || masterKey == null) return;
      context.pop(const NoteOnChainConfirmPop.confirmed());
      return;
    }

    if (publish != null) {
      final agreed = await showGasOnChainRiskConfirmDialog(context);
      if (!mounted || !agreed) return;
      final masterKey = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const PasswordVerifyDialog(
          purpose: PasswordVerifyPurpose.mintNft,
        ),
      );
      if (!mounted || masterKey == null) return;
      setState(() => _confirmBusy = true);
      try {
        final r = await publish(masterKey);
        if (!mounted) return;
        if (r.ok && r.txHash != null && r.txHash!.isNotEmpty) {
          context.pop(NoteOnChainConfirmPop.afterMint(r.txHash!));
        } else if (r.ok && mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.noteOnChainConfirmMintStatusUncertain),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (_) {

      } finally {
        if (mounted) setState(() => _confirmBusy = false);
      }
      return;
    }

    context.pop(const NoteOnChainConfirmPop.confirmed());
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(noteOnChainConfirmControllerProvider(widget.args));
    final notifier =
        ref.read(noteOnChainConfirmControllerProvider(widget.args).notifier);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final gasUi = noteOnChainUiGasSpeed(ui.args.gasSpeed);
    final gasV = noteOnChainConfirmGasVisual(l10n, gasUi, isDark);
    final sym = ui.args.chain.symbol;
    final net = ui.args.chain.displayNameOrName;
    final from = ui.args.fromAddress;
    final to = ui.toContractAddress;
    final paramSummaryJson = noteOnChainMintParamSummaryJson(
      l10n: l10n,
      args: ui.args,
      displayTitle: ui.displayTitle,
      contentHashHex: ui.resolvedHashHex,
      contractAddress: ui.toContractAddress,
    );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFf9fafb),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeaderWithBack(
            onBack: () => context.pop(const NoteOnChainConfirmPop.cancelled()),
            title: l10n.noteOnChainConfirmPageTitle,
            subtitle: l10n.noteOnChainConfirmPageSubtitle,
            backgroundGradient: _headerGradient,
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 14),
            backBackgroundColor: Colors.white12,
            backIconColor: Colors.white,
            titleStyle: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            subtitleStyle: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
            trailing: Material(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  net,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _OnChainTipCard(isDark: isDark, l10n: l10n),
                const SizedBox(height: 16),
                _NoteContentCard(
                  isDark: isDark,
                  scheme: scheme,
                  theme: theme,
                  l10n: l10n,
                  title: ui.displayTitle,
                  preview: ui.contentPreview,
                  hashHex: ui.resolvedHashHex,
                  hashExpanded: ui.showNoteHash,
                  onToggleHash: notifier.toggleShowNoteHash,
                  onCopyHash: () => _copy(ui.resolvedHashHex),
                ),
                const SizedBox(height: 16),
                _NetworkFeeCard(
                  isDark: isDark,
                  scheme: scheme,
                  theme: theme,
                  l10n: l10n,
                  gas: gasV,
                  isGasQuoteLoading: ui.isGasQuoteLoading,
                  gasPrice: ui.quotedGasPrice ?? ui.args.gasPrice,
                  gasLimit: ui.quotedGasLimit ?? ui.args.gasLimit,
                  totalGasFee: ui.quotedTotalGasFee ?? ui.args.totalGasFee,
                  token: sym,
                  onGasTap: _onGasRowTap,
                ),
                const SizedBox(height: 16),
                _ChainDetailsExpandCard(
                  isDark: isDark,
                  scheme: scheme,
                  theme: theme,
                  l10n: l10n,
                  expanded: ui.showChainDetails,
                  onToggle: notifier.toggleShowChainDetails,
                  from: from,
                  to: to,
                  contractLabel: ui.args.contractDisplayName,
                  onOpenContractDetail: () =>
                      _openContractInExplorer(ui.args.chain.explorerUrl, to),
                  formatAddress: noteOnChainFormatAddress,
                  avatarFromAddr: noteOnChainAvatarFromAddr,
                  onCopyFrom: () => _copy(from),
                  onCopyTo: () => _copy(to),
                ),
                const SizedBox(height: 16),
                _AdvancedExpandCard(
                  isDark: isDark,
                  scheme: scheme,
                  theme: theme,
                  l10n: l10n,
                  expanded: ui.showAdvanced,
                  onToggle: notifier.toggleShowAdvanced,
                  network: net,
                  displayNonce: ui.displayNonce,
                  paramSummarySectionTitle:
                      l10n.onChainConfirmParamSummarySectionTitle,
                  paramSummaryJson: paramSummaryJson,
                  onCopyParamSummary: () => _copy(paramSummaryJson),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _confirmBusy
                            ? null
                            : () =>
                                context.pop(const NoteOnChainConfirmPop.cancelled()),
                        child: Text(l10n.cancel),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 14,
                          ),
                        ),
                        onPressed: _confirmBusy ? null : _handleConfirm,
                        child: _confirmBusy
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_rounded, size: 20),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: AutoSizeText(
                                      l10n.noteOnChainConfirmSignButton,
                                      maxLines: 1,
                                      minFontSize: 10,
                                      stepGranularity: 0.5,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            height: 1.0,
                                          ) ??
                                          const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            height: 1.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnChainTipCard extends StatelessWidget {
  const _OnChainTipCard({required this.isDark, required this.l10n});

  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: isDark
          ? const Color(0xFF14532d).withValues(alpha: 0.35)
          : const Color(0xFFf0fdf4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? const Color(0xFF166534) : const Color(0xFFbbf7d0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 22,
              color: isDark ? const Color(0xFF4ade80) : const Color(0xFF059669),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.noteOnChainConfirmTipTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: isDark ? const Color(0xFFbbf7d0) : const Color(0xFF14532d),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.noteOnChainConfirmTipBody,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: isDark ? const Color(0xFF86efac) : const Color(0xFF166534),
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

class _NoteContentCard extends StatelessWidget {
  const _NoteContentCard({
    required this.isDark,
    required this.scheme,
    required this.theme,
    required this.l10n,
    required this.title,
    required this.preview,
    required this.hashHex,
    required this.hashExpanded,
    required this.onToggleHash,
    required this.onCopyHash,
  });

  final bool isDark;
  final ColorScheme scheme;
  final ThemeData theme;
  final AppLocalizations l10n;
  final String title;
  final String preview;
  final String hashHex;
  final bool hashExpanded;
  final VoidCallback onToggleHash;
  final VoidCallback onCopyHash;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.description_outlined,
                    size: 20, color: const Color(0xFF059669)),
                const SizedBox(width: 8),
                Text(
                  l10n.noteOnChainConfirmNoteContentSection,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF14532d).withValues(alpha: 0.25),
                          const Color(0xFF134e4a).withValues(alpha: 0.2),
                        ]
                      : [
                          const Color(0xFFecfdf5),
                          const Color(0xFFccfbf1),
                        ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.noteOnChainConfirmNoteTitleLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? scheme.onSurfaceVariant : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.noteOnChainConfirmContentPreview,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? scheme.onSurfaceVariant : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              constraints: const BoxConstraints(maxHeight: 128),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1f2937) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  preview,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? scheme.onSurfaceVariant : const Color(0xFF374151),
                    height: 1.35,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: scheme.outlineVariant),
            InkWell(
              onTap: onToggleHash,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.tag, size: 18, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.noteOnChainConfirmNoteHashLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      hashExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            if (hashExpanded) ...[
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            isDark ? const Color(0xFF1f2937) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: SelectableText(
                        hashHex,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onCopyHash,
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashedUnderlinePainter extends CustomPainter {
  _DashedUnderlinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    const dash = 3.0;
    const gap = 2.0;
    var x = 0.0;
    final y = size.height * 0.5;
    while (x < size.width) {
      final end = (x + dash).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, y), Offset(end, y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedUnderlinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ContractNameExplorerLink extends StatelessWidget {
  const _ContractNameExplorerLink({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  static const _linkBlue = Color(0xFF2563eb);

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium;
    final style = baseStyle?.copyWith(
          color: _linkBlue,
          fontWeight: FontWeight.w600,
        );
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: SizedBox(
              width: constraints.maxWidth,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.clip,
                        style: style,
                      ),
                      SizedBox(
                        height: 3,
                        child: CustomPaint(
                          painter:
                              _DashedUnderlinePainter(color: _linkBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NoteOnChainContractOwnershipHint extends StatelessWidget {
  const _NoteOnChainContractOwnershipHint({
    required this.isDark,
    required this.text,
  });

  final bool isDark;
  final String text;

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? const Color(0xFF14532d).withValues(alpha: 0.2)
        : const Color(0xFFf0fdf4);
    final border =
        isDark ? const Color(0xFF166534) : const Color(0xFFbbf7d0);
    final iconColor =
        isDark ? const Color(0xFF4ade80) : const Color(0xFF16a34a);
    final textColor =
        isDark ? const Color(0xFF86efac) : const Color(0xFF15803d);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shield_outlined, size: 16, color: iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChainDetailsExpandCard extends StatelessWidget {
  const _ChainDetailsExpandCard({
    required this.isDark,
    required this.scheme,
    required this.theme,
    required this.l10n,
    required this.expanded,
    required this.onToggle,
    required this.from,
    required this.to,
    required this.contractLabel,
    required this.onOpenContractDetail,
    required this.formatAddress,
    required this.avatarFromAddr,
    required this.onCopyFrom,
    required this.onCopyTo,
  });

  final bool isDark;
  final ColorScheme scheme;
  final ThemeData theme;
  final AppLocalizations l10n;
  final bool expanded;
  final VoidCallback onToggle;
  final String from;
  final String to;
  final String contractLabel;
  final VoidCallback onOpenContractDetail;
  final String Function(String) formatAddress;
  final String Function(String) avatarFromAddr;
  final VoidCallback onCopyFrom;
  final VoidCallback onCopyTo;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.layers_outlined,
                          size: 20, color: const Color(0xFF2563eb)),
                      const SizedBox(width: 8),
                      Text(
                        l10n.noteOnChainConfirmChainDetailsSection,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            Divider(height: 1, color: scheme.outlineVariant),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: isDark
                  ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                  : Colors.grey.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.noteOnChainConfirmMyWallet,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF059669), Color(0xFF0d9488)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          avatarFromAddr(from),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          formatAddress(from),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onCopyFrom,
                        icon: const Icon(Icons.copy_rounded, size: 20),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark
                            ? scheme.surfaceContainerHighest
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noteOnChainConfirmTargetContract,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF9333ea), Color(0xFF2563eb)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '📝',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ContractNameExplorerLink(
                              label: contractLabel,
                              onTap: onOpenContractDetail,
                            ),
                            Text(
                              formatAddress(to),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onCopyTo,
                        icon: const Icon(Icons.copy_rounded, size: 20),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _NoteOnChainContractOwnershipHint(
                    isDark: isDark,
                    text: l10n.noteOnChainConfirmContractOwnershipHint,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.noteOnChainConfirmNoteRecipientAddress(from.trim()),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.4,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NetworkFeeCard extends StatelessWidget {
  const _NetworkFeeCard({
    required this.isDark,
    required this.scheme,
    required this.theme,
    required this.l10n,
    required this.gas,
    required this.isGasQuoteLoading,
    required this.gasPrice,
    required this.gasLimit,
    required this.totalGasFee,
    required this.token,
    required this.onGasTap,
  });

  final bool isDark;
  final ColorScheme scheme;
  final ThemeData theme;
  final AppLocalizations l10n;
  final ({String label, IconData icon, Color color, Color bg, String time}) gas;
  final bool isGasQuoteLoading;
  final String gasPrice;
  final String gasLimit;
  final String totalGasFee;
  final String token;
  final VoidCallback onGasTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department_rounded,
                    size: 20, color: const Color(0xFFea580c)),
                const SizedBox(width: 8),
                Text(
                  l10n.noteOnChainConfirmNetworkFee,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (isGasQuoteLoading)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onGasTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF60a5fa)
                          : const Color(0xFF2563eb),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: gas.bg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(gas.icon, color: gas.color, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gas.label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              gas.time,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$totalGasFee $token',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$gasPrice Gwei',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _kv(theme, scheme, l10n.noteOnChainConfirmGasPriceLabel,
                '$gasPrice Gwei'),
            _kv(theme, scheme, l10n.noteOnChainConfirmGasLimitLabel, gasLimit),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.noteOnChainConfirmOnChainFee,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$totalGasFee $token',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF4ade80) : const Color(0xFF059669),
                      ),
                    ),
                    Text(
                      l10n.noteOnChainConfirmGasOnlyHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(ThemeData theme, ColorScheme scheme, String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            k,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          Text(
            v,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvancedExpandCard extends StatelessWidget {
  const _AdvancedExpandCard({
    required this.isDark,
    required this.scheme,
    required this.theme,
    required this.l10n,
    required this.expanded,
    required this.onToggle,
    required this.network,
    required this.displayNonce,
    required this.paramSummarySectionTitle,
    required this.paramSummaryJson,
    required this.onCopyParamSummary,
  });

  final bool isDark;
  final ColorScheme scheme;
  final ThemeData theme;
  final AppLocalizations l10n;
  final bool expanded;
  final VoidCallback onToggle;
  final String network;
  final String displayNonce;
  final String paramSummarySectionTitle;
  final String paramSummaryJson;
  final VoidCallback onCopyParamSummary;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.noteOnChainConfirmAdvancedSection,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            Divider(height: 1, color: scheme.outlineVariant),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: isDark
                  ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                  : Colors.grey.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _advRow(scheme, l10n.noteOnChainConfirmNonceLabel, displayNonce),
                  _advRow(
                      scheme, l10n.noteOnChainConfirmNetworkLabel, network),
                  const SizedBox(height: 8),
                  Divider(color: scheme.outlineVariant),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.data_object_rounded,
                        size: 14,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          paramSummarySectionTitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxHeight: 360),
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(12, 12, 40, 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF111827) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: scheme.outlineVariant),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            paramSummaryJson,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              height: 1.35,
                              color: isDark
                                  ? scheme.onSurfaceVariant
                                  : const Color(0xFF374151),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          onPressed: onCopyParamSummary,
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _advRow(ColorScheme scheme, String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            k,
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
          ),
          Text(
            v,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
