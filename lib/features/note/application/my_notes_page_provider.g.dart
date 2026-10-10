// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_notes_page_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myNotesFilteredHash() => r'59fbc11b6e2f9b2d748530e82c1e8ce2b336fc6d';

/// Copied from [myNotesFiltered].
@ProviderFor(myNotesFiltered)
final myNotesFilteredProvider = Provider<List<Note>>.internal(
  myNotesFiltered,
  name: r'myNotesFilteredProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myNotesFilteredHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyNotesFilteredRef = ProviderRef<List<Note>>;
String _$myNotesFilterHash() => r'bef9621dd42eaeda64afc2b64ed37bec93e11bbb';

/// Copied from [MyNotesFilter].
@ProviderFor(MyNotesFilter)
final myNotesFilterProvider =
    NotifierProvider<MyNotesFilter, NotesPageFilterState>.internal(
      MyNotesFilter.new,
      name: r'myNotesFilterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myNotesFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MyNotesFilter = Notifier<NotesPageFilterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
