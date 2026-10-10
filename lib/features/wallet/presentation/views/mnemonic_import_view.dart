import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

const List<int> kMnemonicLengths = [12, 15, 18, 21, 24];

Widget _mnemonicImportContextMenu(
  BuildContext context,
  EditableTextState editableTextState,
) {
  final others = editableTextState.contextMenuButtonItems
      .where((ContextMenuButtonItem e) => e.type != ContextMenuButtonType.paste)
      .toList();
  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems: <ContextMenuButtonItem>[
      ContextMenuButtonItem(
        type: ContextMenuButtonType.paste,
        onPressed: () {
          editableTextState.pasteText(SelectionChangedCause.toolbar);
        },
      ),
      ...others,
    ],
  );
}

class MnemonicImportView extends StatefulWidget {
  final void Function(List<String> words, int length)? onImport;

  const MnemonicImportView({super.key, this.onImport});

  @override
  State<MnemonicImportView> createState() => _MnemonicImportViewState();
}

class _MnemonicImportViewState extends State<MnemonicImportView> {
  int _mnemonicLength = 12;
  bool _mnemonicSingleWordMode = false;
  final List<TextEditingController> _wordControllers = [];
  final TextEditingController _mnemonicParagraphController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initWordControllers();
  }

  void _initWordControllers() {
    for (final c in _wordControllers) {
      c.dispose();
    }
    _wordControllers.clear();
    for (int i = 0; i < _mnemonicLength; i++) {
      _wordControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final c in _wordControllers) {
      c.dispose();
    }
    _mnemonicParagraphController.dispose();
    super.dispose();
  }

  List<String> _getMnemonicWordsFromSingleInput() {
    return _wordControllers
        .map((c) => c.text.trim().toLowerCase())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<void> _pasteParagraphFromClipboard(AppLocalizations l10n) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final t = data?.text?.trim();
    if (t == null || t.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.clipboardEmpty)),
      );
      return;
    }
    setState(() {
      _mnemonicParagraphController.text = t;
      _mnemonicParagraphController.selection =
          TextSelection.collapsed(offset: t.length);
    });
  }

  List<String> _getMnemonicWordsFromParagraph() {
    final raw = _mnemonicParagraphController.text.trim();
    if (raw.isEmpty) return [];
    return raw
        .split(RegExp(r'\s+'))
        .map((s) => s.trim().toLowerCase())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<void> _submit() async {
    List<String> words;
    if (_mnemonicSingleWordMode) {
      words = _getMnemonicWordsFromSingleInput();
    } else {
      words = _getMnemonicWordsFromParagraph();
      if (words.isNotEmpty && kMnemonicLengths.contains(words.length)) {
        setState(() => _mnemonicLength = words.length);
      }
    }
    final l10n = AppLocalizations.of(context)!;
    if (words.length != _mnemonicLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.mnemonicCountMismatch(_mnemonicLength, words.length),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    final mnemonic = words.join(' ');
    if (!Mnemonic.isValid(mnemonic)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.mnemonicInvalidBip39),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    widget.onImport?.call(words, _mnemonicLength);

    final hasDataKey = await SecureStorageService.instance.hasDataKey();
    if (!mounted) return;

    if (hasDataKey) {
      final masterKeyBase64 = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const PasswordVerifyDialog(
          purpose: PasswordVerifyPurpose.importWallet,
        ),
      );
      if (masterKeyBase64 == null || !mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.pushReplacement(
          AppRoutes.loading,
          extra: <String, dynamic>{
            'message': l10n.walletBootstrapImporting,
            'duration': 3000,
            'masterKeyBase64': masterKeyBase64,
            'createNewWallet': true,
            'importMnemonic': mnemonic,
          },
        );
      });
    } else {
      context.push(
        AppRoutes.createWalletPassword,
        extra: <String, dynamic>{'importMnemonic': mnemonic},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.mnemonicViewLengthTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kMnemonicLengths.map((len) {
                      final selected = _mnemonicLength == len;
                      final primary = Theme.of(context).colorScheme.primary;
                      return FilterChip(
                        label: Text(l10n.walletImportWordCountN(len)),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            _mnemonicLength = len;
                            _initWordControllers();
                          });
                        },
                        selectedColor: primary.withOpacity(0.3),
                        checkmarkColor: primary,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.mnemonicViewInputMode,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                        value: false,
                        label: Text(l10n.mnemonicViewFullPaste),
                      ),
                      ButtonSegment(
                        value: true,
                        label: Text(l10n.mnemonicViewSingleWord),
                      ),
                    ],
                    selected: {_mnemonicSingleWordMode},
                    onSelectionChanged: (Set<bool> selected) {
                      setState(() => _mnemonicSingleWordMode = selected.first);
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_mnemonicSingleWordMode) _buildSingleWordInputs(l10n),
                  if (!_mnemonicSingleWordMode) _buildParagraphInput(l10n),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.mnemonicViewImportCta,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleWordInputs(AppLocalizations l10n) {
    const int columns = 4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mnemonicViewEnterOrdered(_mnemonicLength),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 2.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _mnemonicLength,
          itemBuilder: (context, index) {
            return TextFormField(
              controller: _wordControllers[index],
              contextMenuBuilder: _mnemonicImportContextMenu,
              decoration: InputDecoration(
                hintText: '${index + 1}',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildParagraphInput(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mnemonicViewPasteHint,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _pasteParagraphFromClipboard(l10n),
            icon: const Icon(Icons.content_paste_rounded, size: 18),
            label: Text(l10n.paste),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: _mnemonicParagraphController,
          maxLines: 5,
          contextMenuBuilder: _mnemonicImportContextMenu,
          decoration: InputDecoration(
            hintText: l10n.walletImportMnemonicParagraphExampleHint,
            alignLabelWithHint: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
        ),
      ],
    );
  }
}
