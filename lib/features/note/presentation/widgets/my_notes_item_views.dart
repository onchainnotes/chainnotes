import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/note/data/service/ipfs_service.dart';

Widget _myNotesImagePlaceholder(
  ThemeData theme, {
  required double width,
  required double height,
  required double iconSize,
}) {
  final scheme = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;

  if (isDark) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.surfaceContainerHigh,
            scheme.surfaceContainerHighest,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.description_outlined,
        size: iconSize,
        color: scheme.onSurfaceVariant.withValues(alpha: 0.55),
      ),
    );
  }

  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFeff6ff), Color(0xFFccfbf1)],
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    alignment: Alignment.center,
    child: Icon(
      Icons.description_outlined,
      size: iconSize,
      color: Colors.grey[300],
    ),
  );
}

class MyNotesGridItemView extends StatelessWidget {
  const MyNotesGridItemView({
    super.key,
    required this.note,
    required this.formatDate,
    required this.getPreview,
    required this.noteTypeBadge,
    required this.onTap,
    this.chainName,
    this.chainIcon,
    this.chainColorValue,
    this.chainLogoUrl,
  });

  final Note note;
  final String Function(int) formatDate;
  final String Function(String, [int]) getPreview;
  final Widget Function(NoteType) noteTypeBadge;
  final VoidCallback onTap;
  final String? chainName;
  final String? chainIcon;
  final int? chainColorValue;
  final String? chainLogoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              note.imageUrls.isNotEmpty
                  ? CachedNetworkImageBox(
                      imageUrl: note.imageUrls.first,
                      width: double.infinity,
                      height: 128,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(8),
                      errorWidget: _placeholder(theme),
                      ipfsToHttp: (uri) =>
                          IpfsService.instance.ipfsToHttp(uri),
                    )
                  : _placeholder(theme),
              const SizedBox(height: 12),
              Text(
                note.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                getPreview(note.content, 80),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF4b5563),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDate(note.createdAtOrUpdated),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6b7280),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (note.imageUrls.isNotEmpty)
                          _MiniBadgeView(
                            label: '${note.imageUrls.length}',
                            color: Colors.teal,
                            icon: Icons.image,
                          ),
                        if (note.imageUrls.isNotEmpty) const SizedBox(width: 4),
                        noteTypeBadge(note.onChain ? NoteType.onchain : note.type),
                        if (chainName != null && chainName!.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Flexible(
                            child: _MyNotesChainChipView(
                              chainName: chainName!,
                              chainIcon: chainIcon ?? '⛓',
                              chainColorValue: chainColorValue,
                              chainLogoUrl: chainLogoUrl,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return _myNotesImagePlaceholder(
      theme,
      width: double.infinity,
      height: 128,
      iconSize: 40,
    );
  }
}

class MyNotesListItemView extends StatelessWidget {
  const MyNotesListItemView({
    super.key,
    required this.note,
    required this.formatDate,
    required this.getPreview,
    required this.noteTypeBadge,
    required this.onTap,
    this.chainName,
    this.chainIcon,
    this.chainColorValue,
    this.chainLogoUrl,
  });

  final Note note;
  final String Function(int) formatDate;
  final String Function(String, [int]) getPreview;
  final Widget Function(NoteType) noteTypeBadge;
  final VoidCallback onTap;
  final String? chainName;
  final String? chainIcon;
  final int? chainColorValue;
  final String? chainLogoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              note.imageUrls.isNotEmpty
                  ? CachedNetworkImageBox(
                      imageUrl: note.imageUrls.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(8),
                      errorWidget: _placeholder(theme),
                      ipfsToHttp: (uri) => IpfsService.instance.ipfsToHttp(uri),
                    )
                  : _placeholder(theme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            note.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        noteTypeBadge(note.onChain ? NoteType.onchain : note.type),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      getPreview(note.content, 100),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4b5563),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: AutoSizeText(
                            formatDate(note.createdAtOrUpdated),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF6b7280),
                            ),
                            maxLines: 1,
                            minFontSize: 8,
                            maxFontSize: 12,
                          ),
                        ),
                        if (note.imageUrls.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.image, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          AutoSizeText(
                            '${note.imageUrls.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF6b7280),
                            ),
                            minFontSize: 8,
                            maxFontSize: 12,

                          ),
                        ],
                        const SizedBox(width: 12),
                        Icon(
                          Icons.description,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: AutoSizeText(
                            '${note.content.length}字',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF6b7280),
                            ),
                            maxLines: 1,
                            minFontSize: 8,
                            maxFontSize: 12,
                          ),
                        ),
                        if (chainName != null && chainName!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text('•', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: _MyNotesChainChipView(
                              chainName: chainName!,
                              chainIcon: chainIcon ?? '⛓',
                              chainColorValue: chainColorValue,
                              chainLogoUrl: chainLogoUrl,
                            ),
                          ),
                        ],
                      ],
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

  Widget _placeholder(ThemeData theme) {
    return _myNotesImagePlaceholder(theme, width: 80, height: 80, iconSize: 28);
  }
}

class MyNotesTimelineItemView extends StatelessWidget {
  const MyNotesTimelineItemView({
    super.key,
    required this.note,
    required this.formatDateTime,
    required this.getPreview,
    required this.noteTypeBadge,
    required this.onTap,
    this.chainName,
    this.chainIcon,
    this.chainColorValue,
    this.chainLogoUrl,
  });

  final Note note;
  final String Function(int) formatDateTime;
  final String Function(String, [int]) getPreview;
  final Widget Function(NoteType) noteTypeBadge;
  final VoidCallback onTap;
  final String? chainName;
  final String? chainIcon;
  final int? chainColorValue;
  final String? chainLogoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timePart =
        formatDateTime(note.createdAtOrUpdated).split(' ').length > 1
        ? formatDateTime(note.createdAtOrUpdated).split(' ')[1]
        : '';
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    timePart,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6b7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                getPreview(note.content, 100),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF4b5563),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (note.imageUrls.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: note.imageUrls.length > 3
                        ? 4
                        : note.imageUrls.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 6),
                    itemBuilder: (context, i) {
                      if (i == 3) {
                        final scheme = theme.colorScheme;
                        final isDark = theme.brightness == Brightness.dark;
                        return Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: isDark
                                ? scheme.surfaceContainerHighest
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: isDark
                                ? Border.all(
                                    color: scheme.outlineVariant
                                        .withValues(alpha: 0.6),
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '+${note.imageUrls.length - 3}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? scheme.onSurfaceVariant
                                  : const Color(0xFF6b7280),
                            ),
                          ),
                        );
                      }
                      return CachedNetworkImageBox(
                        imageUrl: note.imageUrls[i],
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(8),
                        errorWidget: _myNotesImagePlaceholder(
                          theme,
                          width: 64,
                          height: 64,
                          iconSize: 24,
                        ),
                        ipfsToHttp: (uri) => IpfsService.instance.ipfsToHttp(uri),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  noteTypeBadge(note.onChain ? NoteType.onchain : note.type),
                  const SizedBox(width: 8),
                  AutoSizeText(
                    '${note.content.length}字',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6b7280),
                    ),
                    maxFontSize: 12,
                    minFontSize: 8,
                  ),
                  if (chainName != null && chainName!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: _MyNotesChainChipView(
                        chainName: chainName!,
                        chainIcon: chainIcon ?? '⛓',
                        chainColorValue: chainColorValue,
                        chainLogoUrl: chainLogoUrl,
                      ),
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
}

class _MiniBadgeView extends StatelessWidget {
  const _MiniBadgeView({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyNotesChainChipView extends StatelessWidget {
  const _MyNotesChainChipView({
    required this.chainName,
    required this.chainIcon,
    this.chainColorValue,
    this.chainLogoUrl,
  });

  final String chainName;
  final String chainIcon;
  final int? chainColorValue;
  final String? chainLogoUrl;

  @override
  Widget build(BuildContext context) {
    const metaColor = Color(0xFF9ca3af);
    final fbColor = chainColorValue ?? 0xFF9ca3af;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChainNetworkLogo(
          chainLogoUrl: chainLogoUrl,
          fallbackColor: fbColor,
          fallbackLabel: chainIcon,
          size: 16,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: AutoSizeText(
            chainName,
            maxLines: 1,
            style: const TextStyle(color: metaColor),
            overflow: TextOverflow.ellipsis,
            minFontSize: 8,
            maxFontSize: 12,
          ),
        ),
      ],
    );
  }
}
