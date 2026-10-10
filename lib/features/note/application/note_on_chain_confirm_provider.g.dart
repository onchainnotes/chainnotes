// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_on_chain_confirm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteOnChainConfirmControllerHash() =>
    r'63a66d4bbfae0aeca0feb9cac7735df53f95dc74';

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

abstract class _$NoteOnChainConfirmController
    extends BuildlessAutoDisposeNotifier<NoteOnChainConfirmUiState> {
  late final NoteOnChainConfirmArgs args;

  NoteOnChainConfirmUiState build(NoteOnChainConfirmArgs args);
}

/// Copied from [NoteOnChainConfirmController].
@ProviderFor(NoteOnChainConfirmController)
const noteOnChainConfirmControllerProvider =
    NoteOnChainConfirmControllerFamily();

/// Copied from [NoteOnChainConfirmController].
class NoteOnChainConfirmControllerFamily
    extends Family<NoteOnChainConfirmUiState> {

  /// Copied from [NoteOnChainConfirmController].
  const NoteOnChainConfirmControllerFamily();

  /// Copied from [NoteOnChainConfirmController].
  NoteOnChainConfirmControllerProvider call(NoteOnChainConfirmArgs args) {
    return NoteOnChainConfirmControllerProvider(args);
  }

  @override
  NoteOnChainConfirmControllerProvider getProviderOverride(
    covariant NoteOnChainConfirmControllerProvider provider,
  ) {
    return call(provider.args);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noteOnChainConfirmControllerProvider';
}

/// Copied from [NoteOnChainConfirmController].
class NoteOnChainConfirmControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<
          NoteOnChainConfirmController,
          NoteOnChainConfirmUiState
        > {

  /// Copied from [NoteOnChainConfirmController].
  NoteOnChainConfirmControllerProvider(NoteOnChainConfirmArgs args)
    : this._internal(
        () => NoteOnChainConfirmController()..args = args,
        from: noteOnChainConfirmControllerProvider,
        name: r'noteOnChainConfirmControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$noteOnChainConfirmControllerHash,
        dependencies: NoteOnChainConfirmControllerFamily._dependencies,
        allTransitiveDependencies:
            NoteOnChainConfirmControllerFamily._allTransitiveDependencies,
        args: args,
      );

  NoteOnChainConfirmControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.args,
  }) : super.internal();

  final NoteOnChainConfirmArgs args;

  @override
  NoteOnChainConfirmUiState runNotifierBuild(
    covariant NoteOnChainConfirmController notifier,
  ) {
    return notifier.build(args);
  }

  @override
  Override overrideWith(NoteOnChainConfirmController Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoteOnChainConfirmControllerProvider._internal(
        () => create()..args = args,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        args: args,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    NoteOnChainConfirmController,
    NoteOnChainConfirmUiState
  >
  createElement() {
    return _NoteOnChainConfirmControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteOnChainConfirmControllerProvider && other.args == args;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, args.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NoteOnChainConfirmControllerRef
    on AutoDisposeNotifierProviderRef<NoteOnChainConfirmUiState> {
  /// The parameter `args` of this provider.
  NoteOnChainConfirmArgs get args;
}

class _NoteOnChainConfirmControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          NoteOnChainConfirmController,
          NoteOnChainConfirmUiState
        >
    with NoteOnChainConfirmControllerRef {
  _NoteOnChainConfirmControllerProviderElement(super.provider);

  @override
  NoteOnChainConfirmArgs get args =>
      (origin as NoteOnChainConfirmControllerProvider).args;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
