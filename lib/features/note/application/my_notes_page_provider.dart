import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chain_notes/features/home/application/notes_provider.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_notes_page_provider.g.dart';

enum FilterMode { all, onchain, offchain }

enum NoteTypeFilter { all, draft, local, onchain }

enum SortMode { newest, oldest, updated, title }

enum ViewMode { grid, list, timeline }

class NotesPageFilterState {
  const NotesPageFilterState({
    this.filterChain,
    this.filterMode = FilterMode.all,
    this.noteTypeFilter = NoteTypeFilter.all,
    this.sortMode = SortMode.newest,
    this.searchQuery = '',
    this.viewMode = ViewMode.list,
  });

  final Chain? filterChain;
  final FilterMode filterMode;
  final NoteTypeFilter noteTypeFilter;
  final SortMode sortMode;
  final String searchQuery;
  final ViewMode viewMode;

  NotesPageFilterState copyWith({
    Chain? filterChain,
    bool clearFilterChain = false,
    FilterMode? filterMode,
    NoteTypeFilter? noteTypeFilter,
    SortMode? sortMode,
    String? searchQuery,
    ViewMode? viewMode,
  }) {
    return NotesPageFilterState(
      filterChain: clearFilterChain ? null : (filterChain ?? this.filterChain),
      filterMode: filterMode ?? this.filterMode,
      noteTypeFilter: noteTypeFilter ?? this.noteTypeFilter,
      sortMode: sortMode ?? this.sortMode,
      searchQuery: searchQuery ?? this.searchQuery,
      viewMode: viewMode ?? this.viewMode,
    );
  }
}

@Riverpod(keepAlive: true)
class MyNotesFilter extends _$MyNotesFilter {
  @override
  NotesPageFilterState build() => const NotesPageFilterState();

  void setFilterChain(Chain? chain) {
    state = state.copyWith(
      filterChain: chain,
      clearFilterChain: chain == null,
    );
  }

  void setFilterMode(FilterMode mode) {
    state = state.copyWith(filterMode: mode);
  }

  void setNoteTypeFilter(NoteTypeFilter mode) {
    state = state.copyWith(noteTypeFilter: mode);
  }

  void setSortMode(SortMode mode) {
    state = state.copyWith(sortMode: mode);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setViewMode(ViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }
}

@Riverpod(keepAlive: true)
List<Note> myNotesFiltered(Ref ref) {
  final notesAsync = ref.watch(notesProvider);
  final notes = notesAsync.value ?? [];
  final filter = ref.watch(myNotesFilterProvider);

  var list = List<Note>.from(notes);

  if (filter.filterChain != null) {
    list = list.where((n) => n.chainId == filter.filterChain!.chainId).toList();
  }

  if (filter.filterMode == FilterMode.onchain) {
    list = list.where((n) => n.onChain).toList();
  } else if (filter.filterMode == FilterMode.offchain) {
    list = list.where((n) => !n.onChain).toList();
  }

  if (filter.noteTypeFilter == NoteTypeFilter.draft) {
    list = list.where((n) => !n.onChain && n.type == NoteType.draft).toList();
  } else if (filter.noteTypeFilter == NoteTypeFilter.local) {
    list = list.where((n) => !n.onChain && n.type == NoteType.local).toList();
  } else if (filter.noteTypeFilter == NoteTypeFilter.onchain) {
    list = list.where((n) => n.onChain).toList();
  }

  if (filter.searchQuery.isNotEmpty) {
    final q = filter.searchQuery.toLowerCase();
    list = list
        .where(
          (n) =>
              n.title.toLowerCase().contains(q) ||
              n.content.toLowerCase().contains(q),
        )
        .toList();
  }

  list.sort((a, b) {
    final cmp = switch (filter.sortMode) {
      SortMode.newest =>
        b.createdAtOrUpdated.compareTo(a.createdAtOrUpdated),
      SortMode.oldest =>
        a.createdAtOrUpdated.compareTo(b.createdAtOrUpdated),
      SortMode.updated => b.updatedAt.compareTo(a.updatedAt),
      SortMode.title => a.title.compareTo(b.title),
    };
    return cmp != 0 ? cmp : b.createdAtOrUpdated.compareTo(a.createdAtOrUpdated);
  });

  return list;
}
