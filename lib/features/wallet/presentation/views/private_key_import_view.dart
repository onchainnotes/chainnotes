import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PrivateKeyImportView extends StatefulWidget {
  final void Function(String privateKey)? onImport;
  final int defaultMaxLines;

  const PrivateKeyImportView({
    super.key,
    this.onImport,
    this.defaultMaxLines = 5,
  });

  @override
  State<PrivateKeyImportView> createState() => _PrivateKeyImportViewState();
}

class _PrivateKeyImportViewState extends State<PrivateKeyImportView> {
  final TextEditingController _privateKeyController = TextEditingController();
  bool _obscurePrivateKey = true;

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }

  String? _validate(AppLocalizations l10n) {
    final key = _privateKeyController.text.trim();
    if (key.isEmpty) return l10n.walletImportPkEmpty;
    return null;
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final error = _validate(l10n);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    widget.onImport?.call(_privateKeyController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.privateKeyVerifySuccess)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.walletImportPrivateKeyHint,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _privateKeyController,
            obscureText: _obscurePrivateKey,
            maxLines: _obscurePrivateKey ? 1 : widget.defaultMaxLines,
            minLines: _obscurePrivateKey ? 1 : 3,
            decoration: InputDecoration(
              hintText: l10n.walletImportPrivateKeyFieldHint,
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePrivateKey
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() => _obscurePrivateKey = !_obscurePrivateKey);
                },
              ),
            ),
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.walletImportPrivateKeySubmit,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
