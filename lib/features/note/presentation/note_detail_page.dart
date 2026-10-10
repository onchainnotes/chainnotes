import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/features/home/application/notes_provider.dart';
import 'package:chain_notes/features/home/data/datasource/realm/note_realm_manager.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/home/presentation/widgets/blockchain_verify.dart';
import 'package:chain_notes/features/note/data/service/ipfs_service.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({
    super.key,
    required this.note,
    this.onBack,
    this.onEdit,
  });

  final Note note;
  final VoidCallback? onBack;

  final VoidCallback? onEdit;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late PageController _imagePageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  String _formatDate(int ms) {
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  String _normalizeImageRef(String url) {
    final u = url.trim();
    if (u.startsWith('file://')) return u.substring(7);
    return u;
  }

  List<String> _collectAllImages(Note note) {
    final all = <String>[];
    final seen = <String>{};
    void addUrl(String u) {
      if (u.trim().isEmpty) return;
      final k = _normalizeImageRef(u);
      if (seen.add(k)) all.add(u);
    }

    for (final u in note.imageUrls) {
      addUrl(u);
    }

    for (final m in _contentImagePattern.allMatches(note.content)) {
      addUrl(m.group(2) ?? '');
    }
    return all;
  }

  void _openImageViewer(Note note, String tappedUrl) {
    final allImages = _collectAllImages(note);
    if (allImages.isEmpty) return;
    final tappedKey = _normalizeImageRef(tappedUrl);
    var index = allImages.indexWhere((e) => _normalizeImageRef(e) == tappedKey);
    if (index < 0) index = 0;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _NoteImageViewerPage(
          imageUrls: allImages,
          initialIndex: index,
        ),
      ),
    );
  }

  bool _canDeleteNote(Note note) {
    return note.type == NoteType.draft || note.type == NoteType.local;
  }

  Future<void> _onDeleteNote(Note note) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dL10n.noteDeleteConfirmTitle),
          content: Text(dL10n.noteDeleteConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(dL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(dL10n.noteDeleteNote),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;
    try {
      NoteRealmManager.instance.deleteNote(note.id);
      if (!mounted) return;
      final container = ProviderScope.containerOf(context, listen: false);
      if (note.type == NoteType.local) {

        container.read(notesProvider.notifier).removeNoteFromList(note.id);
      } else {
        container.invalidate(notesProvider);
      }
      container.invalidate(realmHasAnyNotesProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noteDeletedSnackbar)),
      );
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noteDeleteFailed(e.toString()))),
      );
    }
  }

  static SystemUiOverlayStyle _overlayForTheme(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemStatusBarContrastEnforced: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final note = widget.note;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayForTheme(theme),
      child: Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: scheme.surface,
            child: SafeArea(
              bottom: false,
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  BackIconButton(
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    backgroundColor:
                        isDark ? scheme.surfaceContainerHighest : Colors.grey[100],
                    iconColor: isDark ? scheme.onSurface : const Color(0xFF374151),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: _canDeleteNote(note)
                        ? IconButton(
                            tooltip: l10n.noteDeleteNote,
                            onPressed: () => _onDeleteNote(note),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 26,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (note.imageUrls.isNotEmpty) _buildImageSection(theme, note),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (note.onChain)
                                    _Badge(
                                      label: l10n.noteTypeOnChain,
                                      color: const Color(0xFF059669),
                                      icon: Icons.link,
                                    ),
                                  if (note.type == NoteType.draft && !note.onChain)
                                    _Badge(
                                      label: l10n.noteTypeDraft,
                                      color: Colors.amber,
                                    ),
                                  if (note.type == NoteType.local && !note.onChain)
                                    _Badge(
                                      label: l10n.noteTypeLocal,
                                      color: Colors.blue,
                                    ),
                                  if (note.chainId != null) ...[
                                    if (note.onChain ||
                                        note.type == NoteType.draft ||
                                        note.type == NoteType.local)
                                      const SizedBox(width: 12),
                                    _ChainChip(chainId: note.chainId!),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.noteCreatedAt(
                                  _formatDate(note.createdAtOrUpdated),
                                ),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (note.content.isEmpty)
                            Text(
                              l10n.noteNoContent,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          else
                            _buildContentWithImages(theme, note),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildFooter(theme, note, l10n),
    ),
    );
  }

  Widget _buildImageWidget({
    required ThemeData theme,
    required String pathOrUrl,
    required double height,
  }) {
    final isNetwork = pathOrUrl.startsWith('http://') ||
        pathOrUrl.startsWith('https://');
    final isIpfs = pathOrUrl.startsWith('ipfs://');

    final errorWidget = Container(
      width: double.infinity,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image,
        size: 48,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );

    if (isNetwork || isIpfs) {
      return CachedNetworkImageBox(
        imageUrl: pathOrUrl,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorWidget: errorWidget,
        ipfsToHttp: (uri) => IpfsService.instance.ipfsToHttp(uri),
      );
    }

    final file = File(pathOrUrl);
    return Image.file(
      file,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
      errorBuilder: (_, __, ___) => errorWidget,
    );
  }

  static final RegExp _contentImagePattern = RegExp(r'!\[([^\]]*)\]\(([^)]+)\)');

  Widget _buildContentWithImages(ThemeData theme, Note note) {
    final content = note.content;
    final style = theme.textTheme.bodyLarge?.copyWith(height: 1.5) ?? const TextStyle();
    final matches = _contentImagePattern.allMatches(content);
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
      children.add(_buildContentImage(theme, url, note));
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
        padding: const EdgeInsets.only(bottom: 12),
        child: w,
      )).toList(),
    );
  }

  Widget _buildContentImage(ThemeData theme, String url, Note note) {
    const maxHeight = 280.0;
    final isLocal = !url.startsWith('http://') &&
        !url.startsWith('https://') &&
        !url.startsWith('ipfs://');

    final errorWidget = Container(
      padding: const EdgeInsets.all(24),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.broken_image, size: 48, color: theme.colorScheme.onSurfaceVariant),
    );

    if (isLocal) {
      final path = url.startsWith('file://') ? url.substring(7) : url;
      return GestureDetector(
        onTap: () => _openImageViewer(note, url),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: maxHeight),
            child: Image.file(
              File(path),
              fit: BoxFit.contain,
              width: double.infinity,
              errorBuilder: (_, __, ___) => errorWidget,
            ),
          ),
        ),
      );
    }

    final httpUrl = url.startsWith('ipfs://')
        ? IpfsService.instance.ipfsToHttp(url)
        : url;
    if (!httpUrl.startsWith('http')) {
      return errorWidget;
    }

    return GestureDetector(
      onTap: () => _openImageViewer(note, url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: maxHeight),
          child: CachedNetworkImageBox(
            imageUrl: httpUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            ipfsToHttp: (uri) => IpfsService.instance.ipfsToHttp(uri),
            errorWidget: errorWidget,
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme, Note note) {
    const height = 300.0;
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _imagePageController,
            onPageChanged: (i) => setState(() => _currentImageIndex = i),
            itemCount: note.imageUrls.length,
            itemBuilder: (context, i) {
              final url = note.imageUrls[i];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _openImageViewer(note, url),
                child: _buildImageWidget(
                  theme: theme,
                  pathOrUrl: url,
                  height: height,
                ),
              );
            },
          ),
          if (note.imageUrls.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  note.imageUrls.length,
                  (i) => GestureDetector(
                    onTap: () {
                      _imagePageController.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == i
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditNoteButton(
    AppLocalizations l10n,
    Note note,
  ) {
    final style = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
    const icon = Icon(Icons.edit_outlined, size: 20);
    final label = Text(l10n.editNote);

    final button = FilledButton.icon(
      onPressed: note.onChain
          ? null
          : widget.onEdit ??
              () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.editNoteOpenByRoute)),
                );
              },
      icon: icon,
      label: label,
      style: style,
    );

    if (!note.onChain) return button;

    return Tooltip(
      message: l10n.noteDetailEditDisabledOnChain,
      triggerMode: TooltipTriggerMode.longPress,
      waitDuration: const Duration(milliseconds: 400),
      child: button,
    );
  }

  Widget _buildFooter(
    ThemeData theme,
    Note note,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (note.onChain) ...[
              BlockchainVerify(note: note),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: _buildEditNoteButton(l10n, note),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChainChip extends StatelessWidget {
  const _ChainChip({required this.chainId});

  final int chainId;

  @override
  Widget build(BuildContext context) {
    final chain = ChainFromDemo.findByChainId(chainId);
    if (chain == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final metaColor = theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChainNetworkLogo(
          chainLogoUrl: chain.chainLogo,
          fallbackColor: chain.colorValue,
          fallbackLabel: chain.icon ??
              (chain.displayNameOrName.isNotEmpty
                  ? chain.displayNameOrName[0]
                  : '⛓'),
          size: 20,
        ),
        const SizedBox(width: 6),
        Text(
          chain.displayNameOrName,
          style: theme.textTheme.bodySmall?.copyWith(
            color: metaColor,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}

class _NoteImageViewerPage extends StatefulWidget {
  const _NoteImageViewerPage({
    required this.imageUrls,
    required this.initialIndex,
  });

  final List<String> imageUrls;
  final int initialIndex;

  @override
  State<_NoteImageViewerPage> createState() => _NoteImageViewerPageState();
}

class _NoteImageViewerPageState extends State<_NoteImageViewerPage> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.imageUrls.length - 1);
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _toHttp(String url) {
    if (url.startsWith('ipfs://')) return IpfsService.instance.ipfsToHttp(url);
    return url;
  }

  static const SystemUiOverlayStyle _viewerOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _viewerOverlay,
      child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        systemOverlayStyle: _viewerOverlay,
        title: Text('${_index + 1}/${widget.imageUrls.length}'),
      ),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (i) => setState(() => _index = i),

        reverse: false,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, i) {
          final url = widget.imageUrls[i];
          final isLocal = !url.startsWith('http://') &&
              !url.startsWith('https://') &&
              !url.startsWith('ipfs://');
          final error = Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: Colors.white54, size: 48),
          );
          final image = isLocal
              ? Image.file(
                  File(url.startsWith('file://') ? url.substring(7) : url),
                  errorBuilder: (_, __, ___) => error,
                )
              : CachedNetworkImageBox(
                  imageUrl: _toHttp(url),
                  fit: BoxFit.contain,
                  ipfsToHttp: (uri) => IpfsService.instance.ipfsToHttp(uri),
                  errorWidget: error,
                  placeholder: const Center(
                    child: CircularProgressIndicator(color: Colors.white70),
                  ),
                );
          return InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Center(
              child: image,
            ),
          );
        },
      ),
    ),
    );
  }
}
