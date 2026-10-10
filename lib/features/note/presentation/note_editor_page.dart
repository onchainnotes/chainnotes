import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/note/application/note_editor_provider.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/features/home/data/service/gas_speed.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/home/presentation/widgets/blockchain_verify.dart';
import 'package:chain_notes/features/home/presentation/widgets/save_options_dialog.dart';
import 'package:chain_notes/features/note/presentation/note_on_chain_confirm_page.dart';
import 'package:chain_notes/features/note/presentation/widgets/rich_text_editor_card.dart';
import 'package:chain_notes/features/note/data/service/ipfs_service.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/shared/utils/permission_utils.dart';

class NoteEditorPage extends ConsumerStatefulWidget {
  const NoteEditorPage({
    super.key,
    required this.note,
    required this.onUpdateNote,
    required this.onPublishToBlockchain,
    this.onClose,
    this.currentChain,
    this.isEditing = false,
  });

  final Note note;

  final bool isEditing;
  final void Function(String id, Map<String, dynamic> updates) onUpdateNote;

  final Future<NotePublishResult> Function(
    String id,
    GasSpeed gasSpeed, {
    String? verifiedMasterKeyBase64,
    bool suppressSuccessNavigation,
  }) onPublishToBlockchain;
  final VoidCallback? onClose;
  final Chain? currentChain;

  @override
  ConsumerState<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends ConsumerState<NoteEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  static const Color _green600 = Color(0xFF16a34a);
  static const Color _teal600 = Color(0xFF0d9488);
  static const Color _emerald600 = Color(0xFF059669);
  static const Color _green50 = Color(0xFFf0fdf4);
  static const Color _green100 = Color(0xFFdcfce7);
  static const Color _green200 = Color(0xFFbbf7d0);
  static const Color _blue50 = Color(0xFFeff6ff);
  static const Color _blue200 = Color(0xFFbfdbfe);
  static const Color _blue600 = Color(0xFF2563eb);
  static const Color _amber50 = Color(0xFFfffbeb);
  static const Color _orange50 = Color(0xFFfff7ed);
  static const Color _amber200 = Color(0xFFfde68a);
  static const Color _amber600 = Color(0xFFd97706);
  static const Color _amber800 = Color(0xFF92400e);
  static const Color _amber900 = Color(0xFF78350f);
  static const Color _amber700 = Color(0xFFb45309);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void didUpdateWidget(NoteEditorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.id != widget.note.id) {
      _titleController.text = widget.note.title;
      _contentController.text = widget.note.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    ref.read(noteEditorProvider(widget.note).notifier)
      ..setTitle(_titleController.text)
      ..scheduleSave(
        originalNote: widget.note,
        onUpdateNote: widget.onUpdateNote,
      );
  }

  void _onContentChanged() {
    ref.read(noteEditorProvider(widget.note).notifier)
      ..setContent(_contentController.text)
      ..scheduleSave(
        originalNote: widget.note,
        onUpdateNote: widget.onUpdateNote,
      );
  }

  Future<void> _handleImageUpload() async {
    final hasPhoto = await PermissionUtils.getIsPhotoPermission();
    if (!mounted) return;
    if (!hasPhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.photosPermissionDeniedSnack)),
      );
      return;
    }

    final notifier = ref.read(noteEditorProvider(widget.note).notifier);
    notifier.setUploading(true);

    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (!mounted) return;
      notifier.setUploading(false);

      if (picked != null && picked.path.isNotEmpty) {
        notifier.addImage(picked.path);
        notifier.scheduleSave(
          originalNote: widget.note,
          onUpdateNote: widget.onUpdateNote,
        );
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noteImageAdded)),
        );
      }
    } catch (_) {
      if (mounted) {
        notifier.setUploading(false);
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noteImagePickFailed)),
        );
      }
    }
  }

  Widget _buildImageWidget(String pathOrUrl) {
    final isNetwork =
        pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://');
    final isIpfs = pathOrUrl.startsWith('ipfs://');
    if (isNetwork || isIpfs) {
      final url = isIpfs
          ? IpfsService.instance.ipfsToHttp(pathOrUrl)
          : pathOrUrl;
      return CachedNetworkImageBox(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        ipfsToHttp: (uri) => IpfsService.instance.ipfsToHttp(uri),
        errorWidget: Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image),
        ),
      );
    }
    return Image.file(
      File(pathOrUrl),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image),
      ),
    );
  }

  void _removeImage(int index) {
    final notifier = ref.read(noteEditorProvider(widget.note).notifier);
    notifier.removeImage(index);
    notifier.scheduleSave(
      originalNote: widget.note,
      onUpdateNote: widget.onUpdateNote,
    );
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.imageRemoved)),
    );
  }

  Future<void> _handlePublish() async {
    final notifier = ref.read(noteEditorProvider(widget.note).notifier);
    notifier
      ..setTitle(_titleController.text)
      ..setContent(_contentController.text);
    final editorState = ref.read(noteEditorProvider(widget.note));
    if (!editorState.canSave) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.titleContentRequired)),
      );
      return;
    }
    final chain = widget.currentChain;
    if (chain == null) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectBlockchainFirst)),
        );
      }
      return;
    }

    final gate = await _runOnChainConfirmGate();
    if (gate == null || !mounted) return;

  }

  Future<void> _handleSaveTap() async {
    final notifier = ref.read(noteEditorProvider(widget.note).notifier);
    final editorState = ref.read(noteEditorProvider(widget.note));
    if (!editorState.canSave) return;

    if (editorState.isNewNote) {
      final saveType = await SaveOptionsDialog.show(
        context,
        currentChain: widget.currentChain,
        onSave: (type) =>
            _performSaveByType(notifier, type),
      );
      if (saveType != null && mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    await notifier.save(onUpdateNote: widget.onUpdateNote);
  }

  Future<bool> _showIpfsUploadConfirmDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.ipfsUploadConfirmTitle),
        content: Text(l10n.ipfsUploadConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  int _estimateNoteSizeBytes(NoteEditorState editor) {
    final textBytes =
        utf8.encode(editor.title).length + utf8.encode(editor.content).length;
    var mediaBytes = 0;
    for (final u in editor.imageUrls) {
      if (u.startsWith('http://') ||
          u.startsWith('https://') ||
          u.startsWith('ipfs://')) {
        mediaBytes += utf8.encode(u).length;
      } else {
        try {
          final path = u.startsWith('file://') ? u.substring(7) : u;
          mediaBytes += File(path).lengthSync();
        } catch (_) {
          mediaBytes += utf8.encode(u).length;
        }
      }
    }
    final n = textBytes + mediaBytes;
    return n > 0 ? n : 1024;
  }

  Future<bool> _performSaveByType(
    NoteEditor notifier,
    SaveType type,
  ) async {
    if (type == SaveType.local) {
      await notifier.save(
        onUpdateNote: widget.onUpdateNote,
        type: NoteType.local,
        onChain: false,
        uploadToIpfs: false,
      );
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noteSavedToLocal)),
        );
      }
      return true;
    }
    if (type == NoteType.draft) {
      await notifier.save(
        onUpdateNote: widget.onUpdateNote,
        type: NoteType.draft,
        onChain: false,
        uploadToIpfs: false,
      );
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noteSavedAsDraft)),
        );
      }
      return true;
    }

    notifier
      ..setTitle(_titleController.text)
      ..setContent(_contentController.text);
    final synced = ref.read(noteEditorProvider(widget.note));
    final needsIpfs = NoteEditor.stateRequiresIpfsUpload(synced);
    if (needsIpfs) {
      final agreed = await _showIpfsUploadConfirmDialog();
      if (!agreed || !mounted) return false;
    }
    try {
      await notifier.save(
        onUpdateNote: widget.onUpdateNote,
        type: NoteType.draft,
        onChain: false,
        uploadToIpfs: needsIpfs,
      );
    } on IpfsFileUploadException catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.ipfsFileUploadFailed(describeIpfsUploadCause(e.cause)),
            ),
          ),
        );
      }
      return false;
    }
    final chain = widget.currentChain;
    if (chain == null) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectBlockchainFirst)),
        );
      }
      return false;
    }
    final gate = await _runOnChainConfirmGate();
    if (gate == null || !mounted) return false;
    return gate.completedMintTx != null;
  }

  Future<({Chain chain, String from})?> _resolveOnChainWalletContext() async {
    final chain = widget.currentChain;
    final l10n = AppLocalizations.of(context)!;
    if (chain == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectBlockchainFirst)),
        );
      }
      return null;
    }
    final addr = await loadCurrentWalletAddress();
    final display = await loadCurrentWalletDisplayInfo(addr, chain.chainId);
    final from = (display.protocolAddress ?? addr ?? '').trim();
    if (!mounted) return null;
    if (from.isEmpty || !from.toLowerCase().startsWith('0x')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.connectEvmAccountFirst)),
        );
      }
      return null;
    }
    return (chain: chain, from: from);
  }

  Future<bool> _runOnChainConfirmIntentLoop() async {
    final prep = await _resolveOnChainWalletContext();
    if (prep == null) return false;
    if (!mounted) return false;

    ref.read(noteEditorProvider(widget.note).notifier)
      ..setTitle(_titleController.text)
      ..setContent(_contentController.text);
    GasSpeed? pickedOnConfirm;
    while (true) {
      if (!mounted) return false;
      final ed = ref.read(noteEditorProvider(widget.note));
      final noteSizeBytes = _estimateNoteSizeBytes(ed);
      final pop = await context.push<NoteOnChainConfirmPop?>(
        AppRoutes.noteOnChainConfirm,
        extra: NoteOnChainConfirmArgs(
          chain: prep.chain,
          fromAddress: prep.from,
          noteTitle: ed.title.trim(),
          noteContent: ed.content,
          gasSpeed: pickedOnConfirm,
          intentOnly: true,
        ),
      );
      if (pop == null || pop.result == NoteOnChainConfirmResult.cancelled) {
        return false;
      }
      if (pop.result == NoteOnChainConfirmResult.requestChangeGas) {
        final g = await context.push<GasSpeed?>(
          AppRoutes.gasFeePreview,
          extra: <String, dynamic>{
            'chain': prep.chain,
            'noteId': ed.noteId,
            'noteSizeBytes': noteSizeBytes,
          },
        );
        if (!mounted) return false;
        if (g != null) pickedOnConfirm = g;
        continue;
      }
      if (pop.result == NoteOnChainConfirmResult.confirmed) {
        return true;
      }
    }
  }

  Future<
      ({
        GasSpeed gasForPublish,
        String? completedMintTx,
      })?> _runOnChainConfirmGate() async {
    final prep = await _resolveOnChainWalletContext();
    if (prep == null) return null;

    GasSpeed? pickedOnConfirm;

    while (true) {
      if (!mounted) return null;
      final gasForMint = pickedOnConfirm ?? GasSpeed.normal;
      final ed = ref.read(noteEditorProvider(widget.note));
      final noteSizeBytes = _estimateNoteSizeBytes(ed);
      final routeExtra = <String, dynamic>{
        'args': NoteOnChainConfirmArgs(
          chain: prep.chain,
          fromAddress: prep.from,
          noteTitle: ed.title.trim(),
          noteContent: ed.content,
          gasSpeed: pickedOnConfirm,
        ),
        'onExecutePublish': (String mk) => widget.onPublishToBlockchain(
              ed.noteId,
              gasForMint,
              verifiedMasterKeyBase64: mk,
              suppressSuccessNavigation: true,
            ),
      };

      final pop = await context.push<NoteOnChainConfirmPop?>(
        AppRoutes.noteOnChainConfirm,
        extra: routeExtra,
      );

      if (pop == null || pop.result == NoteOnChainConfirmResult.cancelled) {
        return null;
      }
      if (pop.result == NoteOnChainConfirmResult.requestChangeGas) {
        final g = await context.push<GasSpeed?>(
          AppRoutes.gasFeePreview,
          extra: <String, dynamic>{
            'chain': prep.chain,
            'noteId': ed.noteId,
            'noteSizeBytes': noteSizeBytes,
          },
        );
        if (!mounted) return null;
        if (g != null) pickedOnConfirm = g;
        continue;
      }
      if (pop.mintTxHash != null) {
        if (!mounted) return null;
        final l10n = AppLocalizations.of(context)!;
        context.go(AppRoutes.home);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.onChainSuccessTx(pop.mintTxHash!))),
        );
        return (
          gasForPublish: gasForMint,
          completedMintTx: pop.mintTxHash,
        );
      }

      return null;
    }
  }

  Future<void> _handleSelectOnChainType() async {
    if (widget.note.onChain) return;
    final ok = await _runOnChainConfirmIntentLoop();
    if (!mounted) return;
    if (ok) {
      _applyNoteType(NoteType.onchain);
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.noteEditorOnChainTypeConfirmedSnack(l10n.notePublishToChain),
          ),
        ),
      );
    }
  }

  void _applyNoteType(NoteType value) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.note.onChain && value != NoteType.onchain) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.onChainNoteCannotChangeType)),
      );
      return;
    }
    widget.onUpdateNote(widget.note.id, {'type': value});
    if (value == NoteType.local) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.setToLocalNote)),
      );
    } else if (value == NoteType.draft) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.setToDraft)),
      );
    }
  }

  void _setNoteType(NoteType value) {
    if (value == NoteType.onchain && !widget.note.onChain) {
      unawaited(_handleSelectOnChainType());
      return;
    }
    _applyNoteType(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final editorState = ref.watch(noteEditorProvider(widget.note));
    final theme = Theme.of(context);
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final note = widget.note;

    final hasTitleAndContent = editorState.canSave;
    final headerTitle = widget.isEditing || !editorState.isNewNote
        ? l10n.editNote
        : l10n.noteEditorCreateNewNote;

    return Scaffold(
      backgroundColor: brand.pageBackground,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeaderWithBack(
            onBack: widget.onClose ?? () => Navigator.of(context).pop(),
            title: headerTitle,
            titleLeading: Icon(
              Icons.auto_awesome,
              size: 20,
              color: _green600,
            ),
            spacingAfterTitleLeading: 8,
            titleWidget: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [_green600, _teal600],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: Text(
                headerTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: widget.currentChain != null
                ? l10n.noteEditorChainLine(widget.currentChain!.name)
                : l10n.noteEditorSelectChainToPublish,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            showBottomDivider: true,
            wrapWithSafeArea: true,
            trailing: Material(
              borderRadius: BorderRadius.circular(999),
              color: Colors.transparent,
              elevation: editorState.canSave && !editorState.isSaving ? 2 : 0,
              shadowColor: theme.shadowColor.withValues(alpha: 0.35),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: editorState.canSave && !editorState.isSaving
                      ? const LinearGradient(
                          colors: [_green600, _emerald600],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: editorState.canSave && !editorState.isSaving
                      ? null
                      : theme.colorScheme.surfaceContainerHighest,
                ),
                child: InkWell(
                  onTap: editorState.canSave && !editorState.isSaving
                      ? _handleSaveTap
                      : null,
                  borderRadius: BorderRadius.circular(999),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (editorState.isSaving)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else
                          Icon(
                            Icons.save,
                            size: 18,
                            color: editorState.canSave && !editorState.isSaving
                                ? Colors.white
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.38),
                          ),
                        const SizedBox(width: 6),
                        Text(
                          editorState.isSaving
                              ? l10n.noteEditorSaving
                              : l10n.noteEditorSave,
                          style: TextStyle(
                            color: editorState.canSave && !editorState.isSaving
                                ? Colors.white
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.38),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 672),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      if (!editorState.isNewNote)
                        _buildTypeAndPublishSection(
                          theme,
                          note,
                          editorState,
                          l10n,
                        ),
                      if (!editorState.isNewNote) const SizedBox(height: 16),

                      _buildTitleCard(theme, l10n),
                      const SizedBox(height: 16),

                      _buildContentCard(theme, editorState, l10n),
                      const SizedBox(height: 16),

                      _buildImageCard(theme, editorState, l10n),
                      const SizedBox(height: 16),

                      if (!hasTitleAndContent) _buildRichTextGuide(theme, l10n),
                      if (!hasTitleAndContent) const SizedBox(height: 16),

                      if (!hasTitleAndContent) _buildTipsCard(theme, l10n),

                      if (hasTitleAndContent) _buildSuccessCard(theme, l10n),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleCard(ThemeData theme, AppLocalizations l10n) {
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark
        ? theme.colorScheme.outline.withValues(alpha: 0.55)
        : _green100;
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, size: 20, color: _green600),
                const SizedBox(width: 8),
                Text(
                  l10n.noteTitleLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              onChanged: (_) => _onTitleChanged(),
              maxLength: 100,
              decoration: InputDecoration(
                hintText: l10n.noteTitleHint,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.75),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                isDense: true,
                counterText: '',
              ),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_titleController.text.length}/100',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(
    ThemeData theme,
    NoteEditorState editorState,
    AppLocalizations l10n,
  ) {
    return RichTextEditorCard(
      controller: _contentController,
      onChanged: (value) => _onContentChanged(),
      placeholder: l10n.noteEditorContentPlaceholder,
      disabled: editorState.isSaving,
      minHeight: 400,
      ipfsToHttp: (uri) => IpfsService.instance.ipfsToHttp(uri),
    );
  }

  Widget _buildImageCard(
    ThemeData theme,
    NoteEditorState editorState,
    AppLocalizations l10n,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark
        ? theme.colorScheme.outline.withValues(alpha: 0.55)
        : _green100;
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.image, size: 20, color: _green600),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.noteCoverImages,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (editorState.imageUrls.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.primary.withValues(alpha: 0.2)
                          : _green50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${editorState.imageUrls.length}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? theme.colorScheme.primary
                            : const Color(0xFF15803d),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: editorState.isUploading
                      ? null
                      : _handleImageUpload,
                  icon: editorState.isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _green600,
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: _green600,
                        ),
                  label: Text(
                    editorState.isUploading
                        ? l10n.noteCoverUploading
                        : l10n.noteCoverAdd,
                    style: const TextStyle(
                      color: _green600,
                      fontWeight: FontWeight.w500,
                      fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                  ),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: _green600,
                    side: const BorderSide(color: _green600),

                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (editorState.imageUrls.isNotEmpty)
              LayoutBuilder(
                builder: (context, constraints) {
                  const crossAxisCount = 3;
                  final size =
                      (constraints.maxWidth - 8 * (crossAxisCount - 1)) /
                      crossAxisCount;
                  return Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(editorState.imageUrls.length, (
                        i,
                      ) {
                        return SizedBox(
                          width: size,
                          height: size,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _buildImageWidget(
                                  editorState.imageUrls[i],
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Material(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(999),
                                  child: InkWell(
                                    onTap: () => _removeImage(i),
                                    borderRadius: BorderRadius.circular(999),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                },
              )
            else
              InkWell(
                onTap: editorState.isUploading ? null : _handleImageUpload,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: isDark ? 0.5 : 0.35),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(
                        alpha: isDark ? 0.45 : 0.55,
                      ),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noteCoverTapUpload,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.noteCoverFormatsHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichTextGuide(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_amber50, _orange50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _amber200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: _amber600,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.noteRichTextGuideTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _amber900,
                  ),
                ),
                const SizedBox(height: 8),
                _buildGuideItem(
                  theme,
                  icon: Icons.title,
                  label: l10n.noteRichTextHeadingLabel,
                  text: l10n.noteRichTextHeadingBody,
                ),
                const SizedBox(height: 8),
                _buildGuideItem(
                  theme,
                  icon: Icons.format_list_bulleted,
                  label: l10n.noteRichTextListLabel,
                  text: l10n.noteRichTextListBody,
                ),
                const SizedBox(height: 8),
                _buildGuideItem(
                  theme,
                  icon: Icons.emoji_emotions_outlined,
                  label: l10n.noteRichTextEmojiLabel,
                  text: l10n.noteRichTextEmojiBody,
                ),
                const SizedBox(height: 8),
                _buildGuideItem(
                  theme,
                  icon: Icons.description,
                  label: l10n.noteRichTextTemplateLabel,
                  text: l10n.noteRichTextTemplateBody,
                ),
                const SizedBox(height: 8),
                _buildGuideItem(
                  theme,
                  icon: Icons.image_outlined,
                  label: l10n.noteRichTextImageLabel,
                  text: l10n.noteRichTextImageBody,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: _amber200)),
                  ),
                  child: Text(
                    l10n.noteRichTextPreviewHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _amber700,
                      fontSize: 12,
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

  Widget _buildGuideItem(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: _amber800),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall?.copyWith(
                color: _amber800,
                fontSize: 12,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsCard(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_green50, Color(0xFFccfbf1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _green200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: _green600,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.noteTipsTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF14532d),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.noteTipsBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF166534),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_blue50, Color(0xFFe0f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _blue200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: _blue600,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.noteReadyTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1e3a8a),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.noteReadyBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF1d4ed8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeAndPublishSection(
    ThemeData theme,
    Note note,
    NoteEditorState editorState,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              l10n.noteTypeSectionLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SegmentedButton<NoteType>(
                segments: [
                  ButtonSegment(
                    value: NoteType.draft,
                    label: Text(l10n.noteTypeDraft),
                    icon: const Icon(Icons.description, size: 16),
                  ),
                  ButtonSegment(
                    value: NoteType.local,
                    label: Text(l10n.noteTypeLocal),
                    icon: const Icon(Icons.folder, size: 16),
                  ),
                  ButtonSegment(
                    value: NoteType.onchain,
                    label: Text(l10n.noteTypeOnChain),
                    icon: const Icon(Icons.link, size: 16),
                  ),
                ],
                selected: {note.type},
                onSelectionChanged: (s) {
                  if (s.isEmpty) return;
                  _setNoteType(s.first);
                },
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 8),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (note.type != NoteType.local)
          Row(
            children: [
              if (note.onChain) BlockchainVerify(note: note),
              const Spacer(),
              FilledButton.icon(
                onPressed: note.onChain || editorState.isPublishing
                    ? null
                    : _handlePublish,
                icon: editorState.isPublishing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.link, size: 18),
                label: Text(
                  editorState.isPublishing
                      ? l10n.notePublishing
                      : note.onChain
                      ? l10n.noteOnChainPublished
                      : l10n.notePublishToChain,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
