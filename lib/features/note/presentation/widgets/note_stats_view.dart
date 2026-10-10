import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class NoteStatsView extends StatelessWidget {
  const NoteStatsView({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = notes.length;
    final onChain = notes.where((n) => n.onChain).length;
    final totalImages = notes.fold<int>(0, (s, n) => s + n.imageUrls.length);
    final totalWords = notes.fold<int>(0, (s, n) => s + n.content.length);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
          children: [
            _StatCardView(
              icon: Icons.description_outlined,
              value: '$total',
              label: l10n.noteStatsTotalNotes,
              color: const Color(0xFF2563EB),
            ),
            _StatCardView(
              icon: Icons.link,
              value: '$onChain',
              label: l10n.noteStatsOnChainCount,
              color: const Color(0xFF059669),
            ),
            _StatCardView(
              icon: Icons.image_outlined,
              value: '$totalImages',
              label: l10n.noteStatsImages,
              color: const Color(0xFF0d9488),
            ),
            _StatCardView(
              icon: Icons.bar_chart_outlined,
              value: totalWords >= 1000
                  ? '${(totalWords / 1000).round()}k'
                  : '$totalWords',
              label: l10n.noteStatsChars,
              color: const Color(0xFFea580c),
            ),
          ],
        );
      },
    );
  }
}

class _StatCardView extends StatelessWidget {
  const _StatCardView({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 14,
                    ),
                  ),
                  AutoSizeText(
                    label,
                    maxLines: 1,
                    minFontSize: 8,
                    stepGranularity: 0.5,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
