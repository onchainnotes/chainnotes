import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class RichTextEditorCard extends StatefulWidget {
  const RichTextEditorCard({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.placeholder,
    this.disabled = false,
    this.minHeight = 300,
    this.ipfsToHttp,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final bool disabled;
  final double minHeight;

  final String Function(String uri)? ipfsToHttp;

  @override
  State<RichTextEditorCard> createState() => _RichTextEditorCardState();
}

class _RichTextEditorCardState extends State<RichTextEditorCard> {
  bool _showPreview = false;

  static const Color _green100 = Color(0xFFdcfce7);

  void _insertAtCursor(String text) {
    final ctrl = widget.controller;
    final sel = ctrl.selection;
    final current = ctrl.text;
    final len = current.length;
    var start = sel.start.clamp(0, len);
    var end = sel.end.clamp(0, len);
    if (start > end) end = start;
    final newText = current.substring(0, start) + text + current.substring(end);
    ctrl.text = newText;
    ctrl.selection = TextSelection.collapsed(offset: start + text.length);
    widget.onChanged(newText);
  }

  static final RegExp _imagePattern = RegExp(r'!\[([^\]]*)\]\(([^)]+)\)');

  Widget _buildPreviewContent(ThemeData theme, String content) {
    final style = theme.textTheme.bodyLarge?.copyWith(height: 1.5) ?? const TextStyle();
    final matches = _imagePattern.allMatches(content);
    if (matches.isEmpty) {
      return SelectableText(content, style: style);
    }

    final children = <Widget>[];
    int lastEnd = 0;

    for (final m in matches) {
      if (m.start > lastEnd) {
        children.add(SelectableText(
          content.substring(lastEnd, m.start),
          style: style,
        ));
      }
      final url = m.group(2) ?? '';
      children.add(_buildPreviewImage(url, theme));
      lastEnd = m.end;
    }
    if (lastEnd < content.length) {
      children.add(SelectableText(
        content.substring(lastEnd),
        style: style,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children.map((w) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: w,
      )).toList(),
    );
  }

  Widget _buildPreviewImage(String url, ThemeData theme) {
    const maxHeight = 200.0;
    final isLocal = !url.startsWith('http://') &&
        !url.startsWith('https://') &&
        !url.startsWith('ipfs://');
    if (isLocal) {
      final path = url.startsWith('file://') ? url.substring(7) : url;
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: maxHeight),
          child: Image.file(
            File(path),
            fit: BoxFit.contain,
            width: double.infinity,
            errorBuilder: (_, __, ___) => _imageErrorWidget(theme),
          ),
        ),
      );
    }
    final httpUrl = url.startsWith('ipfs://') && widget.ipfsToHttp != null
        ? widget.ipfsToHttp!(url)
        : url;
    if (!httpUrl.startsWith('http')) {
      return _imageErrorWidget(theme);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: maxHeight),
        child: CachedNetworkImageBox(
          imageUrl: httpUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          ipfsToHttp: widget.ipfsToHttp,
          errorWidget: _imageErrorWidget(theme),
        ),
      ),
    );
  }

  Widget _imageErrorWidget(ThemeData theme) => Container(
    padding: const EdgeInsets.all(24),
    color: theme.colorScheme.surfaceContainerHighest,
    child: Icon(Icons.broken_image, size: 48, color: theme.colorScheme.onSurfaceVariant),
  );

  Future<void> _handleToolbarImagePick() async {
    if (widget.disabled) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    final l10n = AppLocalizations.of(context)!;

    _insertAtCursor('\n![${l10n.richTextMdImageAlt}](${picked.path})\n');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark
        ? theme.colorScheme.outline.withValues(alpha: 0.55)
        : _green100;
    final value = widget.controller.text;
    final lineCount = value.isEmpty ? 0 : value.split('\n').length;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.24 : 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _RichTextToolbar(
            l10n: l10n,
            onInsert: _insertAtCursor,
            onImagePick: _handleToolbarImagePick,
            disabled: widget.disabled,
          ),
          Container(
            color: brand.pageBackground,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showPreview ? l10n.richTextPreviewMode : l10n.richTextEditMode,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _showPreview = !_showPreview),
                  icon: Icon(
                    _showPreview ? Icons.edit_outlined : Icons.visibility_outlined,
                    size: 14,
                  ),
                  label: Text(_showPreview ? l10n.richTextEdit : l10n.richTextPreview),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 28),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    foregroundColor: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(minHeight: widget.minHeight),
            color: theme.colorScheme.surface,
            child: _showPreview
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: value.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(48),
                              child: Text(
                                l10n.noteNoContent,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        : _buildPreviewContent(theme, value),
                  )
                : TextField(
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    enabled: !widget.disabled,
                    maxLines: null,
                    minLines: (widget.minHeight / 24).ceil(),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.75),
                        height: 1.5,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                      isDense: true,
                      alignLabelWithHint: true,
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
          ),
          Container(
            color: brand.pageBackground,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.richTextLineCount(lineCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                Text(
                  l10n.richTextCharCount(value.length),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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

class _RichTextToolbar extends StatefulWidget {
  const _RichTextToolbar({
    required this.l10n,
    required this.onInsert,
    required this.onImagePick,
    required this.disabled,
  });

  final AppLocalizations l10n;
  final void Function(String text) onInsert;
  final VoidCallback onImagePick;
  final bool disabled;

  @override
  State<_RichTextToolbar> createState() => _RichTextToolbarState();
}

class _RichTextToolbarState extends State<_RichTextToolbar> {
  bool _showEmojiMenu = false;
  bool _showTemplateMenu = false;

  static const Color _green600 = Color(0xFF16a34a);

  static const List<String> _numberedEmojis = [
    '1️⃣',
    '2️⃣',
    '3️⃣',
    '4️⃣',
    '5️⃣',
  ];
  static const List<String> _statusEmojis = ['🟢', '🔵', '🟡', '🔴', '⚪'];
  static const List<String> _symbolEmojis = ['✓', '✗', '→', '★', '♥'];
  static const List<String> _faceEmojis = [
    '😊',
    '🎉',
    '💡',
    '🚀',
    '📝',
    '🔥',
    '⭐',
    '💪',
  ];

  List<({String name, List<String> emojis, String Function(String) action})> _emojiGroups(
    AppLocalizations l10n,
  ) {
    return [
      (
        name: l10n.richTextEmojiGroupNumberedTitle,
        emojis: _numberedEmojis,
        action: (e) => '$e ${l10n.richTextEmojiHeadingWord}\n',
      ),
      (
        name: l10n.richTextEmojiGroupStatus,
        emojis: _statusEmojis,
        action: (e) => '$e ${l10n.richTextEmojiBodyWord}\n',
      ),
      (
        name: l10n.richTextEmojiGroupSymbols,
        emojis: _symbolEmojis,
        action: (e) => '$e ${l10n.richTextEmojiBodyWord}\n',
      ),
      (
        name: l10n.richTextEmojiGroupEmoji,
        emojis: _faceEmojis,
        action: (e) => e,
      ),
    ];
  }

  List<({String name, String content})> _templates(AppLocalizations l10n) {
    return [
      (name: l10n.richTextTplStandardNoteName, content: l10n.richTextTplStandardNoteBody),
      (name: l10n.richTextTplTaskName, content: l10n.richTextTplTaskBody),
      (name: l10n.richTextTplStudyName, content: l10n.richTextTplStudyBody),
      (name: l10n.richTextTplIdeaName, content: l10n.richTextTplIdeaBody),
      (name: l10n.richTextTplProjectName, content: l10n.richTextTplProjectBody),
    ];
  }

  Widget _toolbarButton({
    required VoidCallback onPressed,
    required Widget icon,
    String? label,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                if (label != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = widget.l10n;
    final emojiGroups = _emojiGroups(l10n);
    final templates = _templates(l10n);

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              _toolbarButton(
                onPressed: () => widget.onInsert(l10n.richTextInsertNumberedHeading),
                icon: Icon(Icons.title, size: 18, color: _green600),
                label: l10n.richTextToolbarHeading,
                tooltip: l10n.richTextTooltipInsertHeading,
              ),
              _buildDivider(context),
              _toolbarButton(
                onPressed: () => widget.onInsert(l10n.richTextInsertBulletLines),
                icon: Icon(Icons.format_list_bulleted, size: 18, color: _green600),
                tooltip: l10n.richTextTooltipBulletList,
              ),
              _toolbarButton(
                onPressed: () => widget.onInsert(l10n.richTextInsertNumberedLines),
                icon: Icon(Icons.format_list_numbered, size: 18, color: _green600),
                tooltip: l10n.richTextTooltipNumberedList,
              ),
              _toolbarButton(
                onPressed: () => widget.onInsert(l10n.richTextInsertStatusMarkers),
                icon: Icon(Icons.check_box_outlined, size: 18, color: _green600),
                tooltip: l10n.richTextTooltipStatusMarkers,
              ),
              _buildDivider(context),
              _toolbarButton(
                onPressed: () => setState(() {
                  _showEmojiMenu = !_showEmojiMenu;
                  if (_showEmojiMenu) _showTemplateMenu = false;
                }),
                icon: Icon(Icons.emoji_emotions_outlined, size: 18, color: _green600),
                label: l10n.richTextToolbarEmojiMenu,
                tooltip: l10n.richTextTooltipInsertEmoji,
              ),
              _toolbarButton(
                onPressed: () => setState(() {
                  _showTemplateMenu = !_showTemplateMenu;
                  if (_showTemplateMenu) _showEmojiMenu = false;
                }),
                icon: Icon(Icons.auto_awesome, size: 18, color: _green600),
                label: l10n.richTextToolbarTemplate,
                tooltip: l10n.richTextTooltipQuickTemplate,
              ),
              _buildDivider(context),
              _toolbarButton(
                onPressed: widget.onImagePick,
                icon: Icon(Icons.image_outlined, size: 18, color: _green600),
                tooltip: l10n.richTextTooltipAddImage,
              ),
            ],
          ),
          if (_showEmojiMenu) _buildEmojiMenu(theme, emojiGroups),
          if (_showTemplateMenu) _buildTemplateMenu(theme, templates),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              l10n.richTextToolbarBottomHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: outline.withValues(alpha: 0.45),
    );
  }

  Widget _buildEmojiMenu(
    ThemeData theme,
    List<({String name, List<String> emojis, String Function(String) action})> groups,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: theme.brightness == Brightness.dark ? 0.65 : 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 260),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: groups.map((g) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    g.name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: g.emojis.map((e) {
                      return InkWell(
                        onTap: () {
                          widget.onInsert(g.action(e));
                          setState(() => _showEmojiMenu = false);
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(e, style: const TextStyle(fontSize: 20)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTemplateMenu(
    ThemeData theme,
    List<({String name, String content})> templates,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: theme.brightness == Brightness.dark ? 0.65 : 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: templates.map((t) {
            return InkWell(
              onTap: () {
                widget.onInsert(t.content);
                setState(() => _showTemplateMenu = false);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.content.split('\n').first,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
