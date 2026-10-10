import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/wallet/application/import_wallet_page_provider.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/features/wallet/presentation/wallet_chain_l10n.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_mnemonic_word_count_selector.dart';

class ChainType {
  const ChainType({
    required this.id,
    required this.icon,
    required this.gradientColors,
    required this.privateKeyFormat,
  });
  final String id;
  final String icon;
  final List<Color> gradientColors;
  final PrivateKeyFormat privateKeyFormat;

  bool get supportsPrivateKeyImport => id == 'evm';
}

class PrivateKeyFormat {
  const PrivateKeyFormat({
    required this.prefix,
    required this.length,
    required this.pattern,
    required this.example,
  });
  final String prefix;
  final int length;
  final RegExp pattern;
  final String example;
}

final List<ChainType> kChainTypes = [
  ChainType(
    id: 'evm',
    icon: '⟠',
    gradientColors: [const Color(0xFF3b82f6), const Color(0xFF14b8a6)],
    privateKeyFormat: PrivateKeyFormat(
      prefix: '0x',
      length: 66,
      pattern: RegExp(r'^0x[0-9a-fA-F]{64}$'),
      example:
          '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80',
    ),
  ),
  ChainType(
    id: 'bitcoin',
    icon: '₿',
    gradientColors: [const Color(0xFFf97316), const Color(0xFFeab308)],
    privateKeyFormat: PrivateKeyFormat(
      prefix: '5/K/L',
      length: 52,
      pattern: RegExp(r'^[5KL][1-9A-HJ-NP-Za-km-z]{50,51}$'),
      example: 'L1aW4aubDFB7yfras2S1mN3bqg9nwySY8nkoLmJebSLD5BWv3ENZ',
    ),
  ),
  ChainType(
    id: 'solana',
    icon: '◎',
    gradientColors: [const Color(0xFFa855f7), const Color(0xFFec4899)],
    privateKeyFormat: PrivateKeyFormat(
      prefix: '',
      length: 88,
      pattern: RegExp(r'^[1-9A-HJ-NP-Za-km-z]{87,88}$'),
      example:
          '5JKgWNYmUbzkPZQ7tHq8vVBtKjLmLbFT4BFhVPFrM2X3nZQE1wNJvP8xM6T7G9H5K2D3F4',
    ),
  ),
  ChainType(
    id: 'tron',
    icon: '◆',
    gradientColors: [const Color(0xFFef4444), const Color(0xFFf43f5e)],
    privateKeyFormat: PrivateKeyFormat(
      prefix: '',
      length: 64,
      pattern: RegExp(r'^[0-9a-fA-F]{64}$'),
      example:
          'ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80',
    ),
  ),
  ChainType(
    id: 'cosmos',
    icon: '⚛',
    gradientColors: [const Color(0xFF6366f1), const Color(0xFF9333ea)],
    privateKeyFormat: PrivateKeyFormat(
      prefix: '',
      length: 64,
      pattern: RegExp(r'^[0-9a-fA-F]{64}$'),
      example:
          'a96e62ed3955e65be32703f12d87b6b5cf26039ecfa948dc5107a495418e5330',
    ),
  ),
];

class WalletPage extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  final void Function(List<String> words, int length)? onImportMnemonic;
  final void Function(String privateKey)? onImportPrivateKey;

  const WalletPage({
    super.key,
    this.onBack,
    this.onImportMnemonic,
    this.onImportPrivateKey,
  });

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final List<TextEditingController> _wordControllers = [];
  final TextEditingController _pastedController = TextEditingController();
  final TextEditingController _privateKeyController = TextEditingController();
  final List<FocusNode> _wordFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _rebuildWordControllers(ref.read(importWalletPageProvider).wordCount);
  }

  void _applyWordCount(int count) {
    ref.read(importWalletPageProvider.notifier).setWordCount(count);
    _rebuildWordControllers(count);
    setState(() {});
  }

  static final _mnemonicActionButtonStyle = TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.compact,
  );

  Widget _buildMnemonicLengthActions({
    required int wordCount,
    required String actionLabel,
    required VoidCallback onAction,
    required Color actionColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        WalletMnemonicWordCountChipButton(
          wordCount: wordCount,
          onWordCountChanged: _applyWordCount,
        ),
        TextButton(
          onPressed: onAction,
          style: _mnemonicActionButtonStyle,
          child: Text(
            actionLabel,
            style: TextStyle(
              color: actionColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _rebuildWordControllers(int wordCount) {
    for (final c in _wordControllers) {
      c.dispose();
    }
    for (final f in _wordFocusNodes) {
      f.dispose();
    }
    _wordControllers.clear();
    _wordFocusNodes.clear();
    for (int i = 0; i < wordCount; i++) {
      _wordControllers.add(TextEditingController());
      _wordFocusNodes.add(FocusNode());
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in _wordControllers) {
      c.dispose();
    }
    for (final f in _wordFocusNodes) {
      f.dispose();
    }
    _pastedController.dispose();
    _privateKeyController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }
    if (!context.mounted) return;
    if (context.canPop()) {
      context.pop();
      return;
    }
    if (WalletUtils.hasWalletInRealm()) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.guide);
    }
  }

  String? _validateMnemonic(AppLocalizations l10n) {
    final s = ref.read(importWalletPageProvider);
    List<String> words;
    if (s.mnemonicModeIndividual) {
      words = _wordControllers
          .map((c) => c.text.trim().toLowerCase())
          .where((s) => s.isNotEmpty)
          .toList();
    } else {
      final raw = _pastedController.text.trim();
      if (raw.isEmpty) {
        return l10n.walletImportMnemonicNeedCount(s.wordCount);
      }
      words = raw
          .split(RegExp(r'\s+'))
          .map((s) => s.trim().toLowerCase())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (words.length != s.wordCount) {
      return l10n.walletImportMnemonicWrongCount(s.wordCount, words.length);
    }
    for (final w in words) {
      if (w.length < 3 || !RegExp(r'^[a-z]+$').hasMatch(w)) {
        return l10n.walletImportMnemonicInvalidWords;
      }
    }
    return null;
  }

  String? _validatePrivateKey(AppLocalizations l10n) {
    final s = ref.read(importWalletPageProvider);
    final key = _privateKeyController.text.trim();
    if (key.isEmpty) return l10n.walletImportPkEmpty;
    final fmt = s.selectedChain.privateKeyFormat;
    if (fmt.prefix == '0x' && !key.startsWith('0x')) {
      return l10n.walletImportPkNeed0x;
    }
    if (fmt.prefix == '5/K/L' && !RegExp(r'^[5KL]').hasMatch(key)) {
      return l10n.walletImportPkNeedWif;
    }
    if (fmt.prefix == '5/K/L') {
      if (key.length < 51 || key.length > 52) {
        return l10n.walletImportPkWifLength;
      }
    } else if (key.length != fmt.length) {
      return l10n.walletImportPkLengthExpected(fmt.length);
    }
    if (!fmt.pattern.hasMatch(key)) return l10n.walletImportPkInvalidFormat;
    return null;
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.read(importWalletPageProvider);
    if (s.importMethodMnemonic) {
      final err = _validateMnemonic(l10n);
      if (err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
        return;
      }
      List<String> words;
      if (s.mnemonicModeIndividual) {
        words = _wordControllers
            .map((c) => c.text.trim().toLowerCase())
            .toList();
      } else {
        words = _pastedController.text
            .trim()
            .split(RegExp(r'\s+'))
            .map((s) => s.trim().toLowerCase())
            .where((s) => s.isNotEmpty)
            .toList();
      }
      final mnemonic = words.join(' ');
      if (!mounted) return;

      final hasDataKey = await SecureStorageService.instance.hasDataKey();
      if (hasDataKey) {
        final masterKeyBase64 = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const PasswordVerifyDialog(
            purpose: PasswordVerifyPurpose.importWallet,
          ),
        );
        if (masterKeyBase64 == null || !mounted) return;
        widget.onImportMnemonic?.call(words, s.wordCount);
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
        widget.onImportMnemonic?.call(words, s.wordCount);
        if (mounted) {
          context.push(
            AppRoutes.createWalletPassword,
            extra: <String, dynamic>{'importMnemonic': mnemonic},
          );
        }
      }
    } else {
      final err = _validatePrivateKey(l10n);
      if (err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
        return;
      }
      final key = _privateKeyController.text.trim();
      if (s.selectedChain.id != 'evm') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.walletImportEvmOnly)));
        return;
      }
      final addr = WalletUtils.getEvmAddressFromPrivateKey(key);
      if (addr == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.walletImportDeriveAddressFailed)),
        );
        return;
      }
      if (WalletUtils.hasAddressInExistingWallets(addr)) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.walletImportDuplicatePk)));
        }
        return;
      }
      if (!mounted) return;

      final hasDataKey = await SecureStorageService.instance.hasDataKey();
      if (hasDataKey) {
        final masterKeyBase64 = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const PasswordVerifyDialog(
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
              'importPrivateKey': key,
            },
          );
        });
      } else {
        if (mounted) {
          context.push(
            AppRoutes.createWalletPassword,
            extra: <String, dynamic>{'importPrivateKey': key},
          );
        }
      }
    }
  }

  void _clearMnemonic() {
    if (ref.read(importWalletPageProvider).mnemonicModeIndividual) {
      for (final c in _wordControllers) {
        c.clear();
      }
      _wordFocusNodes.first.requestFocus();
    } else {
      _pastedController.clear();
    }
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.cleared)),
    );
  }

  Future<void> _pasteMnemonicFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = (data?.text ?? '').trim();
    if (text.isEmpty) return;
    _pastedController.text = text;
    _pastedController.selection = TextSelection.collapsed(offset: text.length);

    final words = text
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (kMnemonicLengths.contains(words.length)) {
      final notifier = ref.read(importWalletPageProvider.notifier);
      if (words.length != ref.read(importWalletPageProvider).wordCount) {
        notifier.setWordCount(words.length);
        _rebuildWordControllers(words.length);
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _pastePrivateKeyFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = (data?.text ?? '').trim();
    if (!mounted) return;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.clipboardEmpty)),
      );
      return;
    }
    _privateKeyController.text = text;
    _privateKeyController.selection = TextSelection.collapsed(
      offset: text.length,
    );
    setState(() {});
  }

  void _clearPrivateKey() {
    _privateKeyController.clear();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.cleared)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final s = ref.watch(importWalletPageProvider);
    if (isDark) {

      return Scaffold(
        backgroundColor: brand.pageBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
                systemStatusBarContrastEnforced: false,
              ),
              child: ColoredBox(
                color: scheme.surface,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(theme, l10n),
                      _buildTabBar(theme, l10n),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: s.importMethodMnemonic
                      ? _buildMnemonicContent(theme, l10n)
                      : _buildPrivateKeyContent(theme, l10n),
                ),
              ),
            ),
            _buildBottomButton(theme, l10n),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: brand.pageBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFf0fdf4), Color(0xFFf0fdfa), Color(0xFFecfdf5)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(theme, l10n),
              _buildTabBar(theme, l10n),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: s.importMethodMnemonic
                      ? _buildMnemonicContent(theme, l10n)
                      : _buildPrivateKeyContent(theme, l10n),
                ),
              ),
              _buildBottomButton(theme, l10n),
            ],
          ),
        ),
      ),
    );
  }

  void _showChainSelectorSheet(BuildContext context, AppLocalizations l10n) {
    final selectedChainId = ref.read(importWalletPageProvider).selectedChain.id;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final sheetScheme = Theme.of(ctx).colorScheme;
        final sheetDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: sheetScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: sheetScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.walletImportSelectChainTitle,
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: sheetScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: sheetScheme.outlineVariant),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: kChainTypes.length,
                  itemBuilder: (context, index) {
                    final chain = kChainTypes[index];
                    final selected = selectedChainId == chain.id;
                    final canSelect = chain.supportsPrivateKeyImport;
                    final disabledBg = sheetDark
                        ? sheetScheme.onSurface.withValues(alpha: 0.12)
                        : Colors.grey.shade300;
                    final disabledIcon = sheetDark
                        ? sheetScheme.onSurface.withValues(alpha: 0.38)
                        : Colors.grey.shade600;
                    final titleEnabled = sheetScheme.onSurface;
                    final titleDisabled = sheetDark
                        ? sheetScheme.onSurface.withValues(alpha: 0.38)
                        : Colors.grey.shade500;
                    final subEnabled = sheetScheme.onSurfaceVariant;
                    final subMuted = sheetDark
                        ? sheetScheme.onSurface.withValues(alpha: 0.28)
                        : Colors.grey.shade400;
                    final noticeColor = sheetDark
                        ? sheetScheme.onSurface.withValues(alpha: 0.45)
                        : Colors.grey.shade500;
                    return ListTile(
                      enabled: canSelect,
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: canSelect
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: chain.gradientColors,
                                )
                              : null,
                          color: canSelect ? null : disabledBg,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          chain.icon,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: canSelect ? Colors.white : disabledIcon,
                          ),
                        ),
                      ),
                      title: Text(
                        chainLocalizedName(l10n, chain.id),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: canSelect ? titleEnabled : titleDisabled,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chain.privateKeyFormat.prefix.isEmpty
                                ? l10n.walletPkSubtitleLength(
                                    chain.privateKeyFormat.length,
                                  )
                                : l10n.walletPkSubtitleStartsWith(
                                    chain.privateKeyFormat.prefix,
                                  ),
                            style: TextStyle(
                              fontSize: 12,
                              color: canSelect ? subEnabled : subMuted,
                            ),
                          ),
                          if (!canSelect)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                l10n.walletImportEvmOnlyNotice,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: noticeColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: selected && canSelect
                          ? Icon(
                              Icons.check_rounded,
                              color: sheetScheme.primary,
                            )
                          : null,
                      onTap: canSelect
                          ? () {
                              ref
                                  .read(importWalletPageProvider.notifier)
                                  .setSelectedChain(chain);
                              _privateKeyController.clear();
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.switchedToChain(
                                      chainLocalizedName(l10n, chain.id),
                                    ),
                                  ),
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      color: isDark ? scheme.surface : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          BackIconButton(
            onPressed: _onBack,
            iconColor: isDark ? scheme.onSurface : null,
            backgroundColor: isDark
                ? scheme.surfaceContainerHighest
                : Colors.grey[100],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.importWallet,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? scheme.onSurface : const Color(0xFF111827),
                  ),
                ),
                Text(
                  l10n.walletImportPageSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? scheme.onSurfaceVariant
                        : const Color(0xFF6b7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final s = ref.watch(importWalletPageProvider);
    final inactiveTabFg = isDark
        ? scheme.onSurfaceVariant
        : const Color(0xFF4b5563);
    return Container(
      color: isDark ? scheme.surface : Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => ref
                    .read(importWalletPageProvider.notifier)
                    .setImportMethodMnemonic(true),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: s.importMethodMnemonic
                        ? const LinearGradient(
                            colors: [Color(0xFF059669), Color(0xFF0d9488)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: s.importMethodMnemonic ? null : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.vpn_key_rounded,
                        size: 18,
                        color: s.importMethodMnemonic
                            ? Colors.white
                            : inactiveTabFg,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.walletImportTabMnemonic,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: s.importMethodMnemonic
                              ? Colors.white
                              : inactiveTabFg,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => ref
                    .read(importWalletPageProvider.notifier)
                    .setImportMethodMnemonic(false),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: !s.importMethodMnemonic
                        ? const LinearGradient(
                            colors: [Color(0xFF059669), Color(0xFF0d9488)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: !s.importMethodMnemonic ? null : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        size: 18,
                        color: !s.importMethodMnemonic
                            ? Colors.white
                            : inactiveTabFg,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.walletImportTabPrivateKey,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: !s.importMethodMnemonic
                              ? Colors.white
                              : inactiveTabFg,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  Widget _buildMnemonicContent(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final s = ref.watch(importWalletPageProvider);
    final headingColor = isDark ? scheme.onSurface : const Color(0xFF111827);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Text(
          l10n.walletImportInputMethod,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: headingColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _segmentButton(
                l10n.walletImportInputPasteFull,
                !s.mnemonicModeIndividual,
                () => ref
                    .read(importWalletPageProvider.notifier)
                    .setMnemonicModeIndividual(false),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _segmentButton(
                l10n.walletImportInputSingle,
                s.mnemonicModeIndividual,
                () => ref
                    .read(importWalletPageProvider.notifier)
                    .setMnemonicModeIndividual(true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (s.mnemonicModeIndividual)
          _buildIndividualWords(theme, l10n)
        else
          _buildPastedMnemonic(theme, l10n),
        const SizedBox(height: 24),
        _buildMnemonicSecurityCard(theme, l10n),
      ],
    );
  }

  Widget _segmentButton(String label, bool selected, VoidCallback onTap) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final segBg = selected
        ? (isDark
              ? Color.alphaBlend(
                  const Color(0xFF059669).withValues(alpha: 0.20),
                  scheme.surfaceContainerHighest,
                )
              : const Color(0xFFf0fdf4))
        : (isDark ? scheme.surfaceContainerHighest : Colors.white);
    final segBorder = selected
        ? const Color(0xFF059669)
        : (isDark ? scheme.outline : const Color(0xFFe5e7eb));
    final segLabel = selected
        ? (isDark ? const Color(0xFF86efac) : const Color(0xFF15803d))
        : (isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: segBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: segBorder, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: segLabel,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndividualWords(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final s = ref.watch(importWalletPageProvider);
    final headingColor = isDark ? scheme.onSurface : const Color(0xFF111827);
    final fieldFill = isDark ? scheme.surfaceContainerHighest : Colors.white;
    final indexColor = isDark ? scheme.onSurfaceVariant : Colors.grey[500]!;
    final tipColor = isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.walletImportEnterMnemonic,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: headingColor,
                ),
              ),
            ),
            _buildMnemonicLengthActions(
              wordCount: s.wordCount,
              actionLabel: l10n.changePasswordClear,
              onAction: _clearMnemonic,
              actionColor: theme.colorScheme.primary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: s.wordCount,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                TextField(
                  controller: _wordControllers[index],
                  focusNode: _wordFocusNodes[index],
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.walletImportMnemonicWordFieldHint,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 28,
                      right: 8,
                      top: 8,
                      bottom: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? scheme.outline
                            : const Color(0xFFe5e7eb),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? scheme.outline
                            : const Color(0xFFe5e7eb),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: scheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: fieldFill,
                  ),
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) {
                    if (index < s.wordCount - 1) {
                      _wordFocusNodes[index + 1].requestFocus();
                    }
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '${index + 1}.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: indexColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          l10n.walletImportMnemonicPasteTip,
          style: theme.textTheme.bodySmall?.copyWith(color: tipColor),
        ),
      ],
    );
  }

  Widget _buildPastedMnemonic(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final s = ref.watch(importWalletPageProvider);
    final headingColor = isDark ? scheme.onSurface : const Color(0xFF111827);
    final fieldFill = isDark ? scheme.surfaceContainerHighest : Colors.white;
    final metaColor = isDark
        ? scheme.onSurfaceVariant
        : const Color(0xFF6b7280);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _pastedController,
          builder: (context, value, _) {
            final hasText = value.text.trim().isNotEmpty;
            return Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.walletImportPasteMnemonicPrompt,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: headingColor,
                    ),
                  ),
                ),
                _buildMnemonicLengthActions(
                  wordCount: s.wordCount,
                  actionLabel: hasText ? l10n.changePasswordClear : l10n.paste,
                  onAction: hasText
                      ? _clearMnemonic
                      : _pasteMnemonicFromClipboard,
                  actionColor: theme.colorScheme.primary,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _pastedController,
          maxLines: 6,
          style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
          decoration: InputDecoration(
            hintText: l10n.walletImportMnemonicHintWords(s.wordCount),
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? scheme.outline : const Color(0xFFe5e7eb),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? scheme.outline : const Color(0xFFe5e7eb),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: scheme.primary, width: 2),
            ),
            filled: true,
            fillColor: fieldFill,
            contentPadding: const EdgeInsets.all(16),
          ),
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          onChanged: (value) {
            final words = value
                .trim()
                .split(RegExp(r'\s+'))
                .where((s) => s.isNotEmpty)
                .toList();
            if (kMnemonicLengths.contains(words.length) &&
                words.length != ref.read(importWalletPageProvider).wordCount) {
              ref
                  .read(importWalletPageProvider.notifier)
                  .setWordCount(words.length);
              _rebuildWordControllers(words.length);
            }
          },
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _pastedController,
          builder: (context, value, _) {
            final count = value.text.trim().isEmpty
                ? 0
                : value.text
                      .trim()
                      .split(RegExp(r'\s+'))
                      .where((s) => s.isNotEmpty)
                      .length;
            return Text(
              l10n.walletImportWordProgress(count, s.wordCount),
              style: theme.textTheme.bodySmall?.copyWith(color: metaColor),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMnemonicSecurityCard(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final decoration = isDark
        ? BoxDecoration(
            color: Color.alphaBlend(
              Colors.amber.withValues(alpha: 0.14),
              scheme.surfaceContainerHigh,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.45)),
          )
        : BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFfefce8), Color(0xFFfff7ed)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFfde047)),
          );
    final titleColor = isDark ? scheme.onSurface : const Color(0xFF111827);
    final bodyColor = isDark
        ? scheme.onSurfaceVariant
        : const Color(0xFF374151);
    final iconBg = isDark
        ? Color.alphaBlend(
            Colors.amber.withValues(alpha: 0.55),
            scheme.surfaceContainerHigh,
          )
        : const Color(0xFFca8a04);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: decoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(
              Icons.shield_rounded,
              size: 18,
              color: isDark ? Colors.amber.shade100 : Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.walletImportMnemonicSecurityTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.walletImportMnemonicSecurityBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: bodyColor,
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

  Widget _buildPrivateKeyContent(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final s = ref.watch(importWalletPageProvider);
    final headingColor = isDark ? scheme.onSurface : const Color(0xFF111827);
    final subtleText = isDark
        ? scheme.onSurfaceVariant
        : const Color(0xFF6b7280);
    final chevronColor = isDark
        ? scheme.onSurfaceVariant
        : const Color(0xFF9ca3af);
    final cardBg = isDark ? scheme.surfaceContainerHigh : Colors.white;
    final cardBorder = isDark ? scheme.outline : const Color(0xFFe5e7eb);
    final fieldFill = isDark ? scheme.surfaceContainerHighest : Colors.white;
    final pkWarnDecoration = isDark
        ? BoxDecoration(
            color: Color.alphaBlend(
              const Color(0xFFdc2626).withValues(alpha: 0.16),
              scheme.surfaceContainerHigh,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFdc2626).withValues(alpha: 0.45),
            ),
          )
        : BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFfef2f2), Color(0xFFfdf2f8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFfecaca)),
          );
    final pkWarnTitle = isDark ? scheme.onSurface : const Color(0xFF111827);
    final pkWarnBody = isDark
        ? scheme.onSurfaceVariant
        : const Color(0xFF374151);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Text(
          l10n.walletImportSelectChainSection,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: headingColor,
          ),
        ),
        const SizedBox(height: 12),
        Material(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => _showChainSelectorSheet(context, l10n),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cardBorder, width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: s.selectedChain.gradientColors,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      s.selectedChain.icon,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chainLocalizedName(l10n, s.selectedChain.id),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: headingColor,
                          ),
                        ),
                        Text(
                          l10n.walletImportTapSwitchChain,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: subtleText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: chevronColor),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.walletImportEnterPrivateKey,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: headingColor,
              ),
            ),
            TextButton(
              onPressed: _privateKeyController.text.trim().isEmpty
                  ? _pastePrivateKeyFromClipboard
                  : _clearPrivateKey,
              child: Text(
                _privateKeyController.text.trim().isEmpty
                    ? l10n.paste
                    : l10n.changePasswordClear,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _privateKeyController,
          obscureText: !s.showPrivateKey,
          style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
          decoration: InputDecoration(
            hintText: l10n.walletImportPrivateKeyFieldHintShort,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: scheme.primary, width: 2),
            ),
            filled: true,
            fillColor: fieldFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                s.showPrivateKey
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
              onPressed: () => ref
                  .read(importWalletPageProvider.notifier)
                  .setShowPrivateKey(!s.showPrivateKey),
            ),
          ),
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Text(
          chainLocalizedPkDescription(l10n, s.selectedChain.id),
          style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                (Theme.of(context).extension<AppBrandTheme>() ??
                        AppBrandTheme.light)
                    .pageBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: isDark ? scheme.onSurfaceVariant : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.walletImportPkFormatExample,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? scheme.onSurface
                            : const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      s.selectedChain.privateKeyFormat.example,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? scheme.onSurfaceVariant
                            : const Color(0xFF4b5563),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: pkWarnDecoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFdc2626),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shield_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.walletImportPkSevereTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: pkWarnTitle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.walletImportPkSevereBody,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: pkWarnBody,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(ThemeData theme, AppLocalizations l10n) {
    return BottomCtaButton(
      label: l10n.walletImportConfirm,
      onPressed: _submit,
      variant: BottomCtaButtonVariant.primaryGreen,
    );
  }
}
