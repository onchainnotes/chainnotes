import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/settings/application/network_detail_provider.dart';
import 'package:chain_notes/features/settings/domain/network_rpc_defaults.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

String _networkProbeSnackMessage(AppLocalizations l10n, RpcNodeUi n) {
  if (n.probeStatus != RpcProbeStatus.online) {
    return l10n.networkNodeConnectionFailed;
  }
  final ms = n.latencyMs;
  if (ms != null) {
    return l10n.networkNodeProbeOkLatency(ms);
  }
  return l10n.networkNodeProbeOk;
}

class NetworkDetailPage extends ConsumerWidget {
  const NetworkDetailPage({super.key, required this.chain});

  final Chain chain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(networkDetailControllerProvider(chain.id));
    final notifier =
        ref.read(networkDetailControllerProvider(chain.id).notifier);

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final pageBg =
        isDark ? brand.settingsBackground : const Color(0xFFf0fdf4);
    final progressColor =
        isDark ? brand.settingsAccent : const Color(0xFF059669);
    return async.when(
      loading: () => Scaffold(
        backgroundColor: pageBg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailHeader(
              chain: chain,
              onBack: () => context.pop(),
              nodeCount: 0,
              l10n: l10n,
            ),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(color: progressColor),
              ),
            ),
          ],
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: pageBg,
        body: Column(
          children: [
            _DetailHeader(
              chain: chain,
              onBack: () => context.pop(),
              nodeCount: 0,
              l10n: l10n,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.networkLoadFailed(e.toString())),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => ref.invalidate(
                            networkDetailControllerProvider(chain.id)),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      data: (view) => _NetworkDetailBody(
        chain: chain,
        view: view,
        notifier: notifier,
        l10n: l10n,
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.chain,
    required this.onBack,
    required this.nodeCount,
    required this.l10n,
  });

  final Chain chain;
  final VoidCallback onBack;
  final int nodeCount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    const lightHeaderGradient = LinearGradient(
      colors: [Color(0xFF059669), Color(0xFF0d9488)],
    );
    final fallbackLabel = (chain.icon != null && chain.icon!.isNotEmpty)
        ? chain.icon!
        : (chain.displayNameOrName.isNotEmpty
            ? chain.displayNameOrName[0]
            : '?');

    return PageHeaderWithBack(
      onBack: onBack,
      title: chain.name,
      subtitle: l10n.networkDetailHeaderNodeCount(nodeCount),
      backgroundGradient:
          isDark ? brand.settingsHeaderGradient : lightHeaderGradient,
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 14),
      backBackgroundColor: Colors.white12,
      backIconColor: isDark ? brand.onSettingsHeader : Colors.white,
      titleLeading: ChainNetworkLogo(
        chainLogoUrl: chain.chainLogo,
        fallbackColor: chain.colorValue,
        fallbackLabel: fallbackLabel,
        size: 40,
      ),
      spacingAfterTitleLeading: 12,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        color: isDark ? brand.onSettingsHeader : Colors.white,
        fontWeight: FontWeight.w800,
      ),
      subtitleStyle: theme.textTheme.bodySmall?.copyWith(
        color: isDark
            ? brand.onSettingsHeaderSoft.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.85),
      ),
    );
  }
}

class _NetworkDetailBody extends ConsumerStatefulWidget {
  const _NetworkDetailBody({
    required this.chain,
    required this.view,
    required this.notifier,
    required this.l10n,
  });

  final Chain chain;
  final NetworkDetailViewState view;
  final NetworkDetailController notifier;
  final AppLocalizations l10n;

  @override
  ConsumerState<_NetworkDetailBody> createState() => _NetworkDetailBodyState();
}

class _NetworkDetailBodyState extends ConsumerState<_NetworkDetailBody> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chain = widget.chain;
    final view = widget.view;
    final notifier = widget.notifier;
    final l10n = widget.l10n;
    final active = view.activeNode;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final pageBg =
        isDark ? brand.settingsBackground : const Color(0xFFf0fdf4);
    final accent =
        isDark ? brand.settingsAccent : const Color(0xFF059669);

    return Scaffold(
      backgroundColor: pageBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DetailHeader(
            chain: chain,
            onBack: () => context.pop(),
            nodeCount: view.nodes.length,
            l10n: l10n,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _ActiveNodeCard(
                  theme: theme,
                  l10n: l10n,
                  active: active,
                  testingId: view.testingNodeId,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () =>
                            _showAddDialog(context, chain, notifier, l10n),
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: Text(l10n.networkNodeAdd),
                      ),
                    ),
                    if (active != null) ...[
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: view.testingNodeId == active.id
                            ? null
                            : () async {
                                await notifier.testNode(active.id);
                                if (!context.mounted) return;
                                final latest = ref.read(
                                    networkDetailControllerProvider(chain.id));
                                if (latest case AsyncData(:final value)) {
                                  RpcNodeUi? n;
                                  for (final e in value.nodes) {
                                    if (e.id == active.id) {
                                      n = e;
                                      break;
                                    }
                                  }
                                  if (n != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          _networkProbeSnackMessage(l10n, n),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accent,
                          side: BorderSide(color: accent, width: 2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                        child: view.testingNodeId == active.id
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: accent,
                                ),
                              )
                            : const Icon(Icons.monitor_heart_outlined),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.networkAllNodesTitle(view.nodes.length),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ...view.nodes.map((node) => _NodeTile(
                      l10n: l10n,
                      chainId: chain.id,
                      node: node,
                      testingId: view.testingNodeId,
                      notifier: notifier,
                    )),
                const SizedBox(height: 8),
                _TipsCard(theme: theme, l10n: l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(
    BuildContext context,
    Chain chain,
    NetworkDetailController notifier,
    AppLocalizations l10n,
  ) async {
    final preset = kDefaultRpcPresets[chain.id];
    final fromDemo = ChainFromDemo.rpcAddressesOrderedForChainId(chain.id);
    final trimmedRpc = chain.rpcUrl?.trim();
    final exampleUrl = (preset != null && preset.isNotEmpty)
        ? preset.first.url
        : (fromDemo.isNotEmpty
            ? fromDemo.first
            : (trimmedRpc != null && trimmedRpc.isNotEmpty ? trimmedRpc : null));

    await showDialog<void>(
      context: context,
      builder: (ctx) => _AddRpcNodeDialog(
        chain: chain,
        notifier: notifier,
        exampleUrl: exampleUrl,
        parentContext: context,
        l10n: l10n,
      ),
    );
  }
}

class _AddRpcNodeDialog extends StatefulWidget {
  const _AddRpcNodeDialog({
    required this.chain,
    required this.notifier,
    required this.parentContext,
    required this.l10n,
    this.exampleUrl,
  });

  final Chain chain;
  final NetworkDetailController notifier;
  final BuildContext parentContext;
  final AppLocalizations l10n;
  final String? exampleUrl;

  @override
  State<_AddRpcNodeDialog> createState() => _AddRpcNodeDialogState();
}

class _AddRpcNodeDialogState extends State<_AddRpcNodeDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _urlCtrl;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _urlCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final scheme = theme.colorScheme;
    final chain = widget.chain;
    return AlertDialog(
      title: Row(
        children: [
          ChainNetworkLogo(
            chainLogoUrl: chain.chainLogo,
            fallbackColor: chain.colorValue,
            fallbackLabel: (chain.icon != null && chain.icon!.isNotEmpty)
                ? chain.icon!
                : (chain.name.isNotEmpty ? chain.name[0] : '?'),
            size: 32,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.networkAddRpcDialogTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.networkAddRpcDialogSubtitle(chain.name),
              style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280),
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.networkNodeNameLabel,
                hintText: l10n.networkNodeNameHint,
                border: const OutlineInputBorder(),
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlCtrl,
              decoration: InputDecoration(
                labelText: l10n.networkRpcUrlLabel,
                hintText: l10n.networkRpcUrlHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            if (widget.exampleUrl != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: brand.pageBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? scheme.outlineVariant
                        : const Color(0xFFe5e7eb),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.networkExampleRpcLabel,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      widget.exampleUrl!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submitting
              ? null
              : () async {
                  final name = _nameCtrl.text;
                  final url = _urlCtrl.text;
                  if (name.trim().isEmpty || url.trim().isEmpty) {
                    ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                      SnackBar(content: Text(l10n.networkNodeNameRpcRequired)),
                    );
                    return;
                  }
                  setState(() => _submitting = true);
                  try {
                    await widget.notifier.addCustomNode(name: name, url: url);
                    if (context.mounted) Navigator.pop(context);
                    if (widget.parentContext.mounted) {
                      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                        SnackBar(content: Text(l10n.networkNodeAdded)),
                      );
                    }
                  } on FormatException catch (e) {
                    if (widget.parentContext.mounted) {
                      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.message == kNetworkDetailErrInvalidRpcUrl
                                ? l10n.networkRpcUrlInvalid
                                : e.message,
                          ),
                        ),
                      );
                    }
                  } on StateError catch (e) {
                    if (widget.parentContext.mounted) {
                      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.message == kNetworkDetailErrNodeDuplicate
                                ? l10n.networkNodeDuplicate
                                : e.message,
                          ),
                        ),
                      );
                    }
                  } finally {
                    if (mounted) setState(() => _submitting = false);
                  }
                },
          child: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.networkConfirmAddNode),
        ),
      ],
    );
  }
}

class _ActiveNodeCard extends StatelessWidget {
  const _ActiveNodeCard({
    required this.theme,
    required this.l10n,
    required this.active,
    required this.testingId,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final RpcNodeUi? active;
  final String? testingId;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final l10n = this.l10n;
    final borderColor =
        isDark ? scheme.outlineVariant : const Color(0xFF86efac);
    final labelColor =
        isDark ? const Color(0xFF86efac) : const Color(0xFF15803d);
    final metaColor =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);
    final BoxDecoration decoration;
    if (isDark) {
      decoration = BoxDecoration(
        color: Color.alphaBlend(
          brand.settingsAccent.withValues(alpha: 0.22),
          scheme.surfaceContainerHighest,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      );
    } else {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFecfdf5), Color(0xFFf0fdfa)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF86efac), width: 2),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: decoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: brand.settingsAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.networkCurrentNodeTitle,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: labelColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: brand.settingsAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l10n.networkNodeActiveBadge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (active != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    active!.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 10,
                    children: [
                      if (active!.probeStatus == RpcProbeStatus.online)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 14,
                              color: isDark
                                  ? const Color(0xFF4ade80)
                                  : Colors.green[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.networkNodeOnline,
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFF86efac)
                                    : Colors.green[800],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      if (active!.probeStatus == RpcProbeStatus.offline)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_off_rounded,
                              size: 14,
                              color: isDark
                                  ? const Color(0xFFf87171)
                                  : Colors.red[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.networkNodeOffline,
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFfecaca)
                                    : Colors.red[800],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      if (testingId == active!.id)
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: brand.settingsAccent,
                          ),
                        ),
                      if (active!.latencyMs != null)
                        Text(
                          l10n.networkNodeLatencyMs(active!.latencyMs!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: metaColor,
                          ),
                        ),
                    ],
                  ),
                ] else
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      l10n.networkNoNodeSelected,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: metaColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NodeTile extends ConsumerStatefulWidget {
  const _NodeTile({
    required this.l10n,
    required this.chainId,
    required this.node,
    required this.testingId,
    required this.notifier,
  });

  final AppLocalizations l10n;
  final String chainId;
  final RpcNodeUi node;
  final String? testingId;
  final NetworkDetailController notifier;

  @override
  ConsumerState<_NodeTile> createState() => _NodeTileState();
}

class _NodeTileState extends ConsumerState<_NodeTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = widget.l10n;
    final node = widget.node;
    final highlight = node.isActive;
    final cardBg = highlight
        ? (isDark
            ? Color.alphaBlend(
                const Color(0xFF22c55e).withValues(alpha: 0.22),
                scheme.surfaceContainerHighest,
              )
            : const Color(0xFFecfdf5))
        : (isDark ? scheme.surfaceContainerHighest : Colors.white);
    final borderColor = highlight
        ? (isDark ? const Color(0xFF4ade80) : const Color(0xFF22c55e))
        : (isDark ? scheme.outlineVariant : const Color(0xFFe5e7eb));
    final urlBoxBg =
        isDark ? scheme.surfaceContainerHigh : const Color(0xFFf3f4f6);
    final urlTextColor =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563);
    final metaGrey =
        isDark ? scheme.onSurfaceVariant : Colors.grey[600]!;
    final brand = theme.extension<AppBrandTheme>() ??
        (isDark ? AppBrandTheme.dark : AppBrandTheme.light);
    final accent =
        isDark ? brand.settingsAccent : const Color(0xFF059669);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            node.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (node.isDefault) ...[
                          const SizedBox(width: 6),
                          _tinyBadge(
                            l10n.defaultBadge,
                            isDark
                                ? scheme.surfaceContainerHigh
                                : const Color(0xFFf3f4f6),
                            isDark
                                ? scheme.onSurfaceVariant
                                : const Color(0xFF374151),
                          ),
                        ],
                        if (node.isActive) ...[
                          const SizedBox(width: 6),
                          _tinyBadge(
                            l10n.networkNodeInUseBadge,
                            const Color(0xFF059669),
                            Colors.white,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (node.probeStatus == RpcProbeStatus.online)
                    Row(
                      children: [
                        Icon(
                          Icons.wifi_rounded,
                          size: 14,
                          color: isDark
                              ? const Color(0xFF4ade80)
                              : Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.networkNodeOnline,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF86efac)
                                : Colors.green[800],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (node.probeStatus == RpcProbeStatus.offline)
                    Row(
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 14,
                          color: isDark
                              ? const Color(0xFFf87171)
                              : Colors.red[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.networkNodeOffline,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFFfecaca)
                                : Colors.red[800],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (node.latencyMs != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      '${node.latencyMs}ms',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? scheme.onSurfaceVariant
                            : const Color(0xFF6b7280),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: urlBoxBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        rpcUrlForDisplayAndCopy(node),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontFamily: 'monospace',
                          color: urlTextColor,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    color: metaGrey,
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: rpcUrlForDisplayAndCopy(node)),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.networkRpcCopied)),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (!node.isActive)
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () async {
                          await widget.notifier.setActiveNode(node.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.networkNodeSwitched)),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.star_rounded, size: 16),
                        label: Text(l10n.networkNodeSetDefault),
                      ),
                    ),
                  if (!node.isActive) const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accent,
                        side: BorderSide(color: accent, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: widget.testingId == node.id
                          ? null
                          : () async {
                              await widget.notifier.testNode(node.id);
                              if (!context.mounted) return;
                              final latest = ref.read(
                                  networkDetailControllerProvider(
                                      widget.chainId));
                              if (latest case AsyncData(:final value)) {
                                RpcNodeUi? n;
                                for (final e in value.nodes) {
                                  if (e.id == node.id) {
                                    n = e;
                                    break;
                                  }
                                }
                                if (n != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _networkProbeSnackMessage(l10n, n),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                      icon: widget.testingId == node.id
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: accent,
                              ),
                            )
                          : const Icon(Icons.speed_rounded, size: 16),
                      label: Text(l10n.networkNodeTest),
                    ),
                  ),
                  if (!node.isDefault) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      style: IconButton.styleFrom(
                        foregroundColor: isDark
                            ? const Color(0xFFfca5a5)
                            : Colors.red.shade700,
                        side: BorderSide(
                          color: isDark
                              ? Colors.red.shade900.withValues(alpha: 0.6)
                              : Colors.red.shade200,
                        ),
                      ),
                      onPressed: () {
                        if (widget.notifier.canDelete(node.id)) {
                          widget.notifier.deleteNode(node.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.networkNodeDeleted)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                node.isDefault
                                    ? l10n.networkCannotDeleteDefaultNode
                                    : l10n.networkDeleteSwitchNodeFirst,
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _tinyBadge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.theme, required this.l10n});

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final l10n = this.l10n;
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.18),
            scheme.surfaceContainerHighest,
          )
        : const Color(0xFFeff6ff);
    final border =
        isDark ? scheme.outlineVariant : const Color(0xFFbfdbfe);
    final titleColor = isDark ? scheme.onSurface : const Color(0xFF1e3a8a);
    final bodyColor =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF1e3a8a);
    final bulletColor = isDark ? scheme.primary : const Color(0xFF1e40af);
    final iconColor = isDark ? scheme.primary : Colors.blue.shade700;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.networkTipsTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 8),
                _line(l10n.networkTipsLine1, bulletColor, bodyColor),
                _line(l10n.networkTipsLine2, bulletColor, bodyColor),
                _line(l10n.networkTipsLine3, bulletColor, bodyColor),
                _line(l10n.networkTipsLine4, bulletColor, bodyColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _line(String s, Color bulletColor, Color bodyColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: bulletColor)),
          Expanded(
            child: Text(
              s,
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                color: bodyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
