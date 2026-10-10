// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_editor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteEditorHash() => r'dd9017c450d255e7371d5a90088d719b35e5ca54';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$NoteEditor
    extends BuildlessAutoDisposeNotifier<NoteEditorState> {
  late final Note note;

  NoteEditorState build(Note note);
}

/// Copied from [NoteEditor].
@ProviderFor(NoteEditor)
const noteEditorProvider = NoteEditorFamily();

/// Copied from [NoteEditor].
class NoteEditorFamily extends Family<NoteEditorState> {

  /// Copied from [NoteEditor].
  const NoteEditorFamily();

  /// Copied from [NoteEditor].
  NoteEditorProvider call(Note note) {
    return NoteEditorProvider(note);
  }

  @override
  NoteEditorProvider getProviderOverride(
    covariant NoteEditorProvider provider,
  ) {
    return call(provider.note);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noteEditorProvider';
}

/// Copied from [NoteEditor].
class NoteEditorProvider
    extends AutoDisposeNotifierProviderImpl<NoteEditor, NoteEditorState> {

  /// Copied from [NoteEditor].
  NoteEditorProvider(Note note)
    : this._internal(
        () => NoteEditor()..note = note,
        from: noteEditorProvider,
        name: r'noteEditorProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$noteEditorHash,
        dependencies: NoteEditorFamily._dependencies,
        allTransitiveDependencies: NoteEditorFamily._allTransitiveDependencies,
        note: note,
      );

  NoteEditorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.note,
  }) : super.internal();

  final Note note;

  @override
  NoteEditorState runNotifierBuild(covariant NoteEditor notifier) {
    return notifier.build(note);
  }

  @override
  Override overrideWith(NoteEditor Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoteEditorProvider._internal(
        () => create()..note = note,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        note: note,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<NoteEditor, NoteEditorState>
  createElement() {
    return _NoteEditorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteEditorProvider && other.note == note;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, note.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NoteEditorRef on AutoDisposeNotifierProviderRef<NoteEditorState> {
  /// The parameter `note` of this provider.
  Note get note;
}

class _NoteEditorProviderElement
    extends AutoDisposeNotifierProviderElement<NoteEditor, NoteEditorState>
    with NoteEditorRef {
  _NoteEditorProviderElement(super.provider);

  @override
  Note get note => (origin as NoteEditorProvider).note;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
