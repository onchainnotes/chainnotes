import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/features/wallet/data/datasource/realm/wallet_realm_manager.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain_type.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/wallet_type.dart';

class WalletDbDataPage extends StatefulWidget {
  const WalletDbDataPage({super.key});

  @override
  State<WalletDbDataPage> createState() => _WalletDbDataPageState();
}

class _WalletDbDataPageState extends State<WalletDbDataPage> {
  List<AggregatedWallet> _list = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() => _loading = true);
    final manager = WalletRealmManager();
    final list = manager.loadAllAggregatedWallets();
    if (mounted) {
      setState(() {
        _list = list;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('数据库笔记账户数据'),
        leading: BackIconButton(
          onPressed: () => Navigator.of(context).pop(),
          backgroundColor: Colors.transparent,
        ),
        actions: [
          RefreshIconButton(
            onPressed: _load,
            isLoading: _loading,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _list.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_off_rounded,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无笔记账户数据',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _load();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return _AggregatedWalletCard(aggregated: _list[index]);
                },
              ),
            ),
    );
  }
}

class _AggregatedWalletCard extends StatelessWidget {
  const _AggregatedWalletCard({required this.aggregated});

  final AggregatedWallet aggregated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          aggregated.walletName ?? '聚合笔记账户',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'dbId: ${aggregated.id} · 类型: ${aggregated.walletType.displayName} · 当前: ${aggregated.currentWalletId ?? "-"} · 共 ${aggregated.wallets.length} 个子笔记账户',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ),
        children: [
          _buildMeta(context, theme),
          ...aggregated.wallets.map((w) => _WalletTile(wallet: w)),
        ],
      ),
    );
  }

  Widget _buildMeta(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _metaRow('walletIndex', aggregated.walletIndex?.toString() ?? '-'),
          _metaRow(
            'updatedAt',
            aggregated.updatedAt != null
                ? DateTime.fromMillisecondsSinceEpoch(
                    aggregated.updatedAt!,
                  ).toIso8601String()
                : '-',
          ),
          _metaRow('hadBackup', aggregated.hadBackup.toString()),
          _metaRow('totalAmountUsd', aggregated.totalAmountUsd.toString()),
          _metaRow('derivationIndex', aggregated.derivationIndex.toString()),
          if (aggregated.encryptCore != null &&
              aggregated.encryptCore!.isNotEmpty)
            _metaRow('encryptCore', '${aggregated.encryptCore!.length} 字符'),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: SelectableText(value, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _WalletTile extends StatelessWidget {
  const _WalletTile({required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(
        wallet.displayName,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          '${wallet.chainType.displayName} · ${wallet.type.displayName} · ${wallet.protocolAccounts.length} 协议',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('id', wallet.id),
              _row('address', wallet.address),
              _row('chainType', wallet.chainType.displayName),
              _row('type', wallet.type.displayName),
              if (wallet.derivationPath != null)
                _row('derivationPath', wallet.derivationPath!),
              if (wallet.defaultPublicKey != null)
                _row('defaultPublicKey', _short(wallet.defaultPublicKey!, 24)),
              _row(
                'createdAt',
                DateTime.fromMillisecondsSinceEpoch(
                  wallet.createdAt,
                ).toIso8601String(),
              ),
              if (wallet.protocolAccounts.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '协议笔记账户 (${wallet.protocolAccounts.length})',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                ...wallet.protocolAccounts
                    .take(5)
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${p.address} · coinType ${p.walletCoreCoinType}',
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                if (wallet.protocolAccounts.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '... 共 ${wallet.protocolAccounts.length} 个',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 11),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  String _short(String s, int maxLen) {
    if (s.length <= maxLen) return s;
    return '${s.substring(0, maxLen)}...';
  }
}
