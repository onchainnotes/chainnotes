import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/providers.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/note/application/my_notes_page_provider.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/note/presentation/widgets/my_notes_item_views.dart';
import 'package:chain_notes/features/note/presentation/widgets/note_stats_view.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

export 'package:chain_notes/features/note/application/my_notes_page_provider.dart'
    show FilterMode, NoteTypeFilter, SortMode, ViewMode;

class MyNotesPage extends ConsumerStatefulWidget {
  const MyNotesPage({
    super.key,
    required this.onSelectNote,
    required this.onClose,
    required this.onCreateNote,
    required this.currentChain,
    required this.onChainChange,
  });

  final ValueChanged<Note> onSelectNote;
  final VoidCallback onClose;
  final VoidCallback onCreateNote;
  final Chain? currentChain;
  final ValueChanged<Chain> onChainChange;

  @override
  ConsumerState<MyNotesPage> createState() => _MyNotesPageState();
}

class _MyNotesPageState extends ConsumerState<MyNotesPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(int timestamp) {
    final d = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(BuildContext context, int timestamp) {
    final locale = Localizations.localeOf(context);
    final d = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.yMMMd(locale.toString()).add_Hm().format(d);
  }

  String _getPreview(String content, [int length = 100]) {
    final t = content.trim();
    return t.length > length ? '${t.substring(0, length)}...' : t;
  }

  Widget _noteTypeBadge(BuildContext context, NoteType type) {
    final l10n = AppLocalizations.of(context)!;
    final label = switch (type) {
      NoteType.onchain => l10n.noteTypeOnChain,
      NoteType.local => l10n.noteTypeLocal,
      NoteType.draft => l10n.noteTypeDraft,
    };
    return NoteTypeBadge(type: type, label: label);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Chain?>(currentChainProvider, (prev, next) {
      if (next != null) {
        final filter = ref.read(myNotesFilterProvider);
        if (filter.filterChain != null) {
          ref.read(myNotesFilterProvider.notifier).setFilterChain(next);
        }
      }
    });
    final theme = Theme.of(context);
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    return Scaffold(
      backgroundColor: brand.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, theme),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        NoteStatsView(notes: ref.watch(myNotesFilteredProvider)),
                        const SizedBox(height: 12),
                        _buildSearch(context, theme),
                        const SizedBox(height: 12),
                        _buildToolbar(context, theme),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: ref.watch(myNotesFilteredProvider).isEmpty
                      ? SliverToBoxAdapter(child: _buildEmpty(context, theme))
                      : _buildContent(theme),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(theme),
      floatingActionButtonLocation: const _NotesFabLocation(),
    );
  }

  Widget _buildFloatingActionButton(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF16a34a), Color(0xFF059669)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onCreateNote,
          customBorder: const CircleBorder(),
          splashColor: Colors.white24,
          highlightColor: Colors.white12,
          child: const Center(
            child: Icon(Icons.add_circle, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final filterChain = ref.watch(myNotesFilterProvider).filterChain;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: theme.colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.myNotes,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                final filterChain = ref.read(myNotesFilterProvider).filterChain;
                final chain = await context.push<Chain?>(
                  AppRoutes.chainSelector,
                  extra: <String, dynamic>{
                    'currentChain': filterChain ?? widget.currentChain,
                    'showAllChainsOption': true,
                    'currentChainId': filterChain?.chainId,
                  },
                );
                if (!context.mounted) return;
                ref.read(myNotesFilterProvider.notifier).setFilterChain(chain);
                if (chain != null) {
                  widget.onChainChange(chain);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.switchedToChain(chain.displayNameOrName),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.notesSwitchedToAllChains)),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 36),
              ),
              child: filterChain != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ChainNetworkLogo(
                          chainLogoUrl: filterChain.chainLogo,
                          fallbackColor: filterChain.colorValue,
                          fallbackLabel: filterChain.icon ??
                              filterChain.name.substring(0, 1),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          filterChain.displayNameOrName,
                          style: theme.textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ChainNetworkLogo(
                          chainLogoUrl: null,
                          fallbackColor: 0xFF4b5563,
                          fallbackLabel: '🌐',
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.notesAllChains,
                          style: theme.textTheme.labelMedium,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      controller: _searchController,
      onChanged: (v) =>
          ref.read(myNotesFilterProvider.notifier).setSearchQuery(v),
      decoration: InputDecoration(
        hintText: l10n.searchNotesHint,
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _Dropdown<FilterMode>(
            value: ref.watch(myNotesFilterProvider).filterMode,
            items: [
              (FilterMode.all, l10n.notesFilterAll),
              (FilterMode.onchain, l10n.notesFilterOnChain),
              (FilterMode.offchain, l10n.notesFilterOffChain),
            ],
            onChanged: (v) =>
                ref.read(myNotesFilterProvider.notifier).setFilterMode(v!),
            icon: Icons.filter_list,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Dropdown<NoteTypeFilter>(
            value: ref.watch(myNotesFilterProvider).noteTypeFilter,
            items: [
              (NoteTypeFilter.all, l10n.notesFilterAll),
              (NoteTypeFilter.draft, l10n.noteTypeDraft),
              (NoteTypeFilter.local, l10n.noteTypeLocal),
              (NoteTypeFilter.onchain, l10n.noteTypeOnChain),
            ],
            onChanged: (v) =>
                ref.read(myNotesFilterProvider.notifier).setNoteTypeFilter(v!),
            icon: Icons.tag,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Dropdown<SortMode>(
            value: ref.watch(myNotesFilterProvider).sortMode,
            items: [
              (SortMode.newest, l10n.notesSortNewest),
              (SortMode.updated, l10n.notesSortUpdated),
              (SortMode.oldest, l10n.notesSortOldest),
              (SortMode.title, l10n.notesSortTitle),
            ],
            onChanged: (v) =>
                ref.read(myNotesFilterProvider.notifier).setSortMode(v!),
            icon: Icons.sort,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ViewButton(
                icon: Icons.grid_view,
                selected: ref.watch(myNotesFilterProvider).viewMode == ViewMode.grid,
                onTap: () =>
                    ref.read(myNotesFilterProvider.notifier).setViewMode(ViewMode.grid),
              ),
              _ViewButton(
                icon: Icons.view_list,
                selected: ref.watch(myNotesFilterProvider).viewMode == ViewMode.list,
                onTap: () =>
                    ref.read(myNotesFilterProvider.notifier).setViewMode(ViewMode.list),
              ),
              _ViewButton(
                icon: Icons.timeline,
                selected:
                    ref.watch(myNotesFilterProvider).viewMode == ViewMode.timeline,
                onTap: () => ref
                    .read(myNotesFilterProvider.notifier)
                    .setViewMode(ViewMode.timeline),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(myNotesFilterProvider);
    String message;
    if (filter.searchQuery.isNotEmpty) {
      message = l10n.noMatchNotes;
    } else if (filter.filterMode == FilterMode.onchain) {
      message = l10n.noOnChainNotes;
    } else if (filter.filterMode == FilterMode.offchain) {
      message = l10n.noOffChainNotes;
    } else {
      message = l10n.noNotes;
    }
    String subMessage = filter.searchQuery.isNotEmpty
        ? l10n.tryOtherSearch
        : l10n.startCreateFirstNote;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFdbeafe), Color(0xFFccfbf1)],
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.description, size: 40, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4b5563),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subMessage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6b7280),
            ),
          ),
          if (filter.searchQuery.isNotEmpty) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();
                ref.read(myNotesFilterProvider.notifier).setSearchQuery('');
              },
              child: Text(l10n.clearSearch),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final filteredNotes = ref.watch(myNotesFilteredProvider);
    final filter = ref.watch(myNotesFilterProvider);
    final showChainInfo = filter.filterChain == null;
    switch (filter.viewMode) {
      case ViewMode.grid:
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final note = filteredNotes[i];
              final chain = showChainInfo && note.chainId != null
                  ? ChainFromDemo.findByChainId(note.chainId!)
                  : null;
              return MyNotesGridItemView(
                note: note,
                formatDate: _formatDate,
                getPreview: _getPreview,
                noteTypeBadge: (t) => _noteTypeBadge(context, t),
                chainName: chain?.displayNameOrName,
                chainIcon: chain?.icon,
                chainColorValue: chain?.colorValue,
                chainLogoUrl: chain?.chainLogo,
                onTap: () => widget.onSelectNote(note),
              );
            },
            childCount: filteredNotes.length,
          ),
        );
      case ViewMode.list:
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final note = filteredNotes[i];
              final chain = showChainInfo && note.chainId != null
                  ? ChainFromDemo.findByChainId(note.chainId!)
                  : null;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: MyNotesListItemView(
                  note: note,
                  formatDate: _formatDate,
                  getPreview: _getPreview,
                  noteTypeBadge: (type) => _noteTypeBadge(context, type),
                  chainName: chain?.displayNameOrName,
                  chainIcon: chain?.icon,
                  chainColorValue: chain?.colorValue,
                  chainLogoUrl: chain?.chainLogo,
                  onTap: () => widget.onSelectNote(note),
                ),
              );
            },
            childCount: filteredNotes.length,
          ),
        );
      case ViewMode.timeline:
        return _buildTimeline(context, theme, filteredNotes, showChainInfo);
    }
  }

  Widget _buildTimeline(
    BuildContext context,
    ThemeData theme,
    List<Note> filteredNotes,
    bool showChainInfo,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final grouped = <String, List<Note>>{};
    for (final n in filteredNotes) {
      final date = _formatDate(n.createdAtOrUpdated);
      grouped.putIfAbsent(date, () => []).add(n);
    }
    final entries = grouped.entries.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        final e = entries[i];
        final date = e.key;
        final dateNotes = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      date,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  Text(
                    l10n.notesTimelineNoteCount(dateNotes.length),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...dateNotes.map(
                (note) => Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: -21,
                        top: 20,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Builder(
                          builder: (_) {
                            final chain = showChainInfo && note.chainId != null
                                ? ChainFromDemo.findByChainId(note.chainId!)
                                : null;
                            return MyNotesTimelineItemView(
                              note: note,
                              formatDateTime: (ts) =>
                                  _formatDateTime(context, ts),
                              getPreview: _getPreview,
                              noteTypeBadge: (type) =>
                                  _noteTypeBadge(context, type),
                              chainName: chain?.displayNameOrName,
                              chainIcon: chain?.icon,
                              chainColorValue: chain?.colorValue,
                              chainLogoUrl: chain?.chainLogo,
                              onTap: () => widget.onSelectNote(note),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }, childCount: entries.length),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
  });

  final T value;
  final List<(T, String)> items;
  final ValueChanged<T?> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = items
        .firstWhere((e) => e.$1 == value, orElse: () => (value, ''))
        .$2;
    return PopupMenuButton<T>(
      onSelected: onChanged,
      itemBuilder: (context) => items
          .map((e) => PopupMenuItem<T>(value: e.$1, child: Text(e.$2)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected ? theme.colorScheme.primaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: selected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _NotesFabLocation extends FloatingActionButtonLocation {
  const _NotesFabLocation();

  static const double _fabSize = 56;
  static const double _bottom = 80;
  static const double _right = 24;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry geometry) {
    final width = geometry.scaffoldSize.width;
    final height = geometry.scaffoldSize.height;
    return Offset(width - _fabSize - _right, height - _fabSize - _bottom);
  }
}
