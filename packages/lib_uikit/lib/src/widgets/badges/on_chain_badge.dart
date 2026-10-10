import 'package:flutter/material.dart';

enum NoteType {

  draft,

  local,

  onchain,
}

class NoteTypeBadge extends StatelessWidget {
  const NoteTypeBadge({
    super.key,
    required this.type,
    this.label,
  });

  final NoteType type;

  final String? label;

  static const Color _onchainColor = Color(0xFF059669); // emerald-600
  static const Color _localColor = Color(0xFF2563eb);   // blue-600
  static const Color _draftColor = Color(0xFFeab308);   // yellow-600/amber

  String get _defaultLabel {
    return switch (type) {
      NoteType.onchain => '已上链',
      NoteType.local => '本地',
      NoteType.draft => '草稿',
    };
  }

  (Color color, IconData icon) get _style {
    return switch (type) {
      NoteType.onchain => (_onchainColor, Icons.check),
      NoteType.local => (_localColor, Icons.description),
      NoteType.draft => (_draftColor, Icons.edit_note),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, icon) = _style;
    final text = label ?? _defaultLabel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class OnChainBadge extends StatelessWidget {
  const OnChainBadge({
    super.key,
    this.label = '已上链',
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return NoteTypeBadge(type: NoteType.onchain, label: label);
  }
}
