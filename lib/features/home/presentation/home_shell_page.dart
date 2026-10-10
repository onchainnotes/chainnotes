import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/note/application/my_notes_page_provider.dart';
import 'package:chain_notes/features/home/presentation/home_page.dart';
import 'package:chain_notes/features/note/presentation/my_notes_page.dart';
import 'package:chain_notes/features/settings/presentation/profile_page.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/app/providers.dart';

class HomeShellPage extends ConsumerStatefulWidget {
  const HomeShellPage({
    super.key,
    this.currentChain,
    this.onChainChange,
    this.notes = const [],
    this.notesLoading = false,
    this.notesSyncing = false,
    this.realmHasNotes = false,
    this.onCreateNote,
    this.onWalletChange,
    this.onOpenMnemonicExport,
    this.onOpenWalletManagement,
    this.onNavigateToAbout,
    this.onOpenTransactionHistory,
  });

  final Chain? currentChain;
  final ValueChanged<Chain>? onChainChange;
  final List<Note> notes;

  final bool notesLoading;

  final bool notesSyncing;

  final bool realmHasNotes;
  final VoidCallback? onCreateNote;
  final VoidCallback? onWalletChange;
  final VoidCallback? onOpenMnemonicExport;
  final VoidCallback? onOpenWalletManagement;
  final VoidCallback? onNavigateToAbout;
  final VoidCallback? onOpenTransactionHistory;

  @override
  ConsumerState<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends ConsumerState<HomeShellPage> {
  int _currentIndex = 0;
  bool _waitingForSecondBack = false;
  Timer? _backResetTimer;

  @override
  void dispose() {
    _backResetTimer?.cancel();
    super.dispose();
  }

  bool _onBackPressed() {
    if (_waitingForSecondBack) {
      _backResetTimer?.cancel();
      SystemNavigator.pop();
      return true;
    }
    setState(() => _waitingForSecondBack = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.pressBackAgainToExitApp),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _backResetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _waitingForSecondBack = false);
    });
    return false;
  }

  List<_TabItem> _getTabs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      _TabItem(
        label: l10n.tabHome,
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
      ),
      _TabItem(
        label: l10n.tabNotes,
        icon: Icons.article_outlined,
        activeIcon: Icons.article,
      ),
      _TabItem(
        label: l10n.tabProfile,
        icon: Icons.person_outline,
        activeIcon: Icons.person,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _getTabs(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _onBackPressed();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(
              onWalletChange: widget.onWalletChange,
              onSelectNote: (Note note) => context.push(
                AppRoutes.noteDetail,
                extra: <String, dynamic>{'note': note},
              ),
              onCreateNote: widget.onCreateNote,
              onNavigateToNotes: (List<Note> notes, Chain? currentChain) {
                ref.read(myNotesFilterProvider.notifier).setFilterChain(null);
                setState(() => _currentIndex = 1);
              },
              onOpenMnemonicExport: widget.onOpenMnemonicExport,
              onNavigateToAbout: widget.onNavigateToAbout,
              onOpenTransactionHistory: widget.onOpenTransactionHistory,
            ),
            MyNotesPage(
              currentChain: widget.currentChain,
              onChainChange: widget.onChainChange ?? (_) {},
              onSelectNote: (Note note) => context.push(
                AppRoutes.noteDetail,
                extra: <String, dynamic>{'note': note},
              ),
              onClose: () => setState(() => _currentIndex = 0),
              onCreateNote: () {
                widget.onCreateNote?.call();
              },
            ),
            ProfilePage(
              notes: widget.notes,
              currentChain: widget.currentChain,
              walletContextTick: ref.watch(homeWalletContextTickProvider),
              onOpenWalletManagement: widget.onOpenWalletManagement,
              onOpenAbout: widget.onNavigateToAbout,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(tabs.length, (i) {
                  final t = tabs[i];
                  final selected = _currentIndex == i;
                  return InkWell(
                    onTap: () => setState(() => _currentIndex = i),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selected ? t.activeIcon : t.icon,
                            size: 24,
                            color: selected
                                ? const Color(0xFF059669)
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: selected
                                  ? const Color(0xFF059669)
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
