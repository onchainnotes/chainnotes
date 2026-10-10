import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试页面'),
        leading: BackIconButton(
          onPressed: () => context.pop(),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(theme, '功能测试'),
          const SizedBox(height: 8),
          _buildTestCard(
            theme,
            icon: Icons.lightbulb_outline_rounded,
            title: '去引导页',
            subtitle: '跳转到引导页（创建/恢复笔记账户入口）',
            onTap: () {
              context.go(AppRoutes.guide);
            },
          ),
          const SizedBox(height: 12),
          _buildTestCard(
            theme,
            icon: Icons.lock_rounded,
            title: '设置密码',
            subtitle: '测试笔记账户密码设置功能',
            onTap: () {
              context.push(AppRoutes.createWalletPassword);
            },
          ),
          const SizedBox(height: 12),
          _buildTestCard(
            theme,
            icon: Icons.account_balance_wallet_rounded,
            title: '笔记账户管理',
            subtitle: '测试笔记账户管理功能',
            onTap: () {
              context.push(AppRoutes.walletManagement);
            },
          ),
          const SizedBox(height: 12),
          _buildTestCard(
            theme,
            icon: Icons.storage_rounded,
            title: '数据库笔记账户数据',
            subtitle: '查看当前 app 所有 Realm 笔记账户数据',
            onTap: () {
              context.push(AppRoutes.walletDbData);
            },
          ),
          const SizedBox(height: 12),
          _buildTestCard(
            theme,
            icon: Icons.delete_forever_rounded,
            title: '清空所有笔记账户',
            subtitle: '删除 Realm 中所有聚合笔记账户（不可恢复）',
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('清空所有笔记账户'),
                  content: const Text('将删除 Realm 中所有笔记账户数据，此操作不可恢复。确定继续？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text(
                        '确定清空',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                WalletUtils.deleteAllWallets();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('已清空所有笔记账户')));
              }
            },
          ),
          const SizedBox(height: 12),
          _buildTestCard(
            theme,
            icon: Icons.download_rounded,
            title: '恢复笔记账户',
            subtitle: '测试笔记账户恢复功能',
            onTap: () {
              context.push(AppRoutes.wallet);
            },
          ),
          const SizedBox(height: 12),
          _buildTestCard(
            theme,
            icon: Icons.info_outline_rounded,
            title: '关于我们',
            subtitle: '查看关于我们页面',
            onTap: () {
              context.push(AppRoutes.about);
            },
          ),
          const SizedBox(height: 12),
          _buildTestCard(
            theme,
            icon: Icons.receipt_long_rounded,
            title: '创建笔记记录',
            subtitle: '查看创建笔记记录页（与 Web 一致）',
            onTap: () {
              context.push(AppRoutes.transactionHistory);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTestCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFdcfce7), Color(0xFFccfbf1)],
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 24, color: const Color(0xFF059669)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
