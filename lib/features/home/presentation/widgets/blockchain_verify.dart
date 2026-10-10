import 'package:flutter/material.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/note/data/service/ipfs_service.dart';

class BlockchainVerify extends StatelessWidget {
  const BlockchainVerify({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    if (!note.onChain ||
        note.blockchainHash == null ||
        note.blockchainHash!.isEmpty) {
      return const SizedBox.shrink();
    }

    return OutlinedButton.icon(
      onPressed: () => showDialog<void>(
        context: context,
        builder: (ctx) => _VerifyDialog(note: note),
      ),
      icon: const Icon(Icons.shield_outlined, size: 18),
      label: const Text('验证区块链'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class _VerifyDialog extends StatefulWidget {
  const _VerifyDialog({required this.note});

  final Note note;

  @override
  State<_VerifyDialog> createState() => _VerifyDialogState();
}

class _VerifyDialogState extends State<_VerifyDialog> {
  bool _isVerifying = false;
  ({bool verified, String message})? _result;

  Future<void> _verify() async {
    final note = widget.note;
    if (note.blockchainHash == null || note.blockchainHash!.isEmpty) return;

    setState(() {
      _isVerifying = true;
      _result = null;
    });

    try {

      if (note.contentHash == null || note.contentHash!.isEmpty) {
        if (mounted) {
          setState(() {
            _result = (
              verified: false,
              message: '该笔记为旧版上链，未存储内容哈希，暂不支持验证。'
                  '请重新铸造笔记以启用验证功能。',
            );
          });
        }
        return;
      }

      final computedHash = IpfsService.instance.computeNoteContentHash(
        title: note.title,
        content: note.content,
        imageIpfsUrls: note.imageUrls,
        author: note.author ?? '',
        createdAtMs: note.createdAtOrUpdated,
      );

      final isValid = computedHash == note.contentHash;

      if (mounted) {
        setState(() {
          _result = (
            verified: isValid,
            message: isValid
                ? '✓ 验证成功！笔记内容与链上记录完全匹配，未被篡改。'
                : '✗ 验证失败！笔记内容已被修改，与链上记录不匹配。',
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _result = (verified: false, message: '验证过程出错，请稍后重试。');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('区块链验证'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '验证笔记内容是否与区块链上的记录一致',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.5,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '交易哈希',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    widget.note.blockchainHash!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isVerifying ? null : _verify,
                icon: _isVerifying
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.shield_outlined, size: 18),
                label: Text(_isVerifying ? '验证中...' : '开始验证'),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _result!.verified
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _result!.verified
                        ? Colors.green.shade200
                        : Colors.red.shade200,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _result!.verified ? Icons.check_circle : Icons.cancel,
                      size: 20,
                      color: _result!.verified
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _result!.message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _result!.verified
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            ...<String>[
              '• 验证原理：铸造时将笔记内容哈希存储，验证时重新计算并对比',
              '• 若本地内容与铸造时一致，则 contentHash 匹配',
              '• 区块链交易哈希可于区块浏览器查询',
            ].map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  line,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
      ],
    );
  }
}
