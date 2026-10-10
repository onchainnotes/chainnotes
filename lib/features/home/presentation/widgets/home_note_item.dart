import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/note/data/service/ipfs_service.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

const Color _onchainBadgeColor = Color(0xFF059669);
const Color _localBadgeColor = Color(0xFF2563eb);
const Color _draftBadgeColor = Color(0xFFeab308);

class HomeNoteItem extends StatefulWidget {
  const HomeNoteItem({
    super.key,
    required this.note,
    this.onTap,
    this.chainName,
    this.chainIcon,
    this.chainColorValue,
    this.chainLogoUrl,
  });

  final Note note;
  final VoidCallback? onTap;

  final String? chainName;

  final String? chainIcon;

  final int? chainColorValue;

  final String? chainLogoUrl;

  @override
  State<HomeNoteItem> createState() => _HomeNoteItemState();
}

class _HomeNoteItemState extends State<HomeNoteItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final note = widget.note;
    final preview = note.content.length > 60
        ? '${note.content.substring(0, 60)}...'
        : note.content;
    final date = DateTime.fromMillisecondsSinceEpoch(note.createdAtOrUpdated);
    final dateStr = '${date.month}月${date.day}日';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Listener(
          onPointerDown: (_) => setState(() => _isPressed = true),
          onPointerUp: (_) => setState(() => _isPressed = false),
          onPointerCancel: (_) => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.98 : 1,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: _isPressed ? 4 : 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildThumbnail(theme),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      note.title,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  _buildStatusBadge(theme, l10n),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                preview,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF6b7280),
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              _buildMetaRow(theme, dateStr),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(ThemeData theme) {
    if (widget.note.imageUrls.isNotEmpty) {
      return CachedNetworkImageBox(
        imageUrl: widget.note.imageUrls.first,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8),
        errorWidget: _buildPlaceholder(theme),
        ipfsToHttp: (uri) => IpfsService.instance.ipfsToHttp(uri),
      );
    }
    return _buildPlaceholder(theme);
  }

  Widget _buildPlaceholder(ThemeData theme) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (isDark) {
      return Container(
        width: 64,
        height: 64,
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
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.description_outlined,
          size: 24,
          color: scheme.onSurfaceVariant.withValues(alpha: 0.55),
        ),
      );
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFeff6ff), Color(0xFFccfbf1)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.description_outlined, size: 24, color: Colors.grey[300]),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, AppLocalizations l10n) {

    final type = widget.note.onChain ? NoteType.onchain : widget.note.type;
    final (label, color) = switch (type) {
      NoteType.onchain => (l10n.noteTypeOnChain, _onchainBadgeColor),
      NoteType.local => (l10n.noteTypeLocal, _localBadgeColor),
      NoteType.draft => (l10n.noteTypeDraft, _draftBadgeColor),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      constraints: const BoxConstraints(minHeight: 22),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildMetaRow(ThemeData theme, String dateStr) {
    final metaColor = Colors.grey[400]!;
    return Row(
      children: [
        Icon(Icons.access_time, size: 12, color: metaColor),
        const SizedBox(width: 4),
        AutoSizeText(
          dateStr,
          maxFontSize: 12,
          style: theme.textTheme.bodySmall?.copyWith(
            color: metaColor,
          ),
          minFontSize: 8,
        ),
        if (widget.note.imageUrls.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text('•', style: TextStyle(color: metaColor, fontSize: 12)),
          const SizedBox(width: 4),
          Icon(Icons.image_outlined, size: 12, color: metaColor),
          const SizedBox(width: 2),
          AutoSizeText(
            '${widget.note.imageUrls.length}',
            maxFontSize: 12,
            minFontSize: 8,
            style: theme.textTheme.bodySmall?.copyWith(
              color: metaColor,
              fontSize: 12,
            ),
          ),
        ],
        if (widget.chainName != null && widget.chainName!.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text('•', style: TextStyle(color: metaColor, fontSize: 12)),
          const SizedBox(width: 4),
          Flexible(child: _buildChainChip(metaColor)),
        ],
      ],
    );
  }

  Widget _buildChainChip(Color metaColor) {
    final fbColor = widget.chainColorValue ?? 0xFF9ca3af;
    final fbLabel = widget.chainIcon ?? '⛓';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChainNetworkLogo(
          chainLogoUrl: widget.chainLogoUrl,
          fallbackColor: fbColor,
          fallbackLabel: fbLabel,
          size: 16,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: AutoSizeText(
            widget.chainName!,
            maxFontSize: 12,
            minFontSize: 8,
            style: TextStyle(color: metaColor,),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
