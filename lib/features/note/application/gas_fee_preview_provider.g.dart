// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gas_fee_preview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gasFeePreviewHash() => r'e2d7ed5f740df691c2266d27ff09eeb4c94dbe03';

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

abstract class _$GasFeePreview
    extends BuildlessAutoDisposeNotifier<GasFeePreviewState> {
  late final GasFeePreviewArgs args;

  GasFeePreviewState build(GasFeePreviewArgs args);
}

/// See also [GasFeePreview].
@ProviderFor(GasFeePreview)
const gasFeePreviewProvider = GasFeePreviewFamily();

/// See also [GasFeePreview].
class GasFeePreviewFamily extends Family<GasFeePreviewState> {
  /// See also [GasFeePreview].
  const GasFeePreviewFamily();

  /// See also [GasFeePreview].
  GasFeePreviewProvider call(GasFeePreviewArgs args) {
    return GasFeePreviewProvider(args);
  }

  @override
  GasFeePreviewProvider getProviderOverride(
    covariant GasFeePreviewProvider provider,
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
  String? get name => r'gasFeePreviewProvider';
}

/// See also [GasFeePreview].
class GasFeePreviewProvider
    extends AutoDisposeNotifierProviderImpl<GasFeePreview, GasFeePreviewState> {
  /// See also [GasFeePreview].
  GasFeePreviewProvider(GasFeePreviewArgs args)
    : this._internal(
        () => GasFeePreview()..args = args,
        from: gasFeePreviewProvider,
        name: r'gasFeePreviewProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gasFeePreviewHash,
        dependencies: GasFeePreviewFamily._dependencies,
        allTransitiveDependencies:
            GasFeePreviewFamily._allTransitiveDependencies,
        args: args,
      );

  GasFeePreviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.args,
  }) : super.internal();

  final GasFeePreviewArgs args;

  @override
  GasFeePreviewState runNotifierBuild(covariant GasFeePreview notifier) {
    return notifier.build(args);
  }

  @override
  Override overrideWith(GasFeePreview Function() create) {
    return ProviderOverride(
      origin: this,
      override: GasFeePreviewProvider._internal(
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
  AutoDisposeNotifierProviderElement<GasFeePreview, GasFeePreviewState>
  createElement() {
    return _GasFeePreviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GasFeePreviewProvider && other.args == args;
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
mixin GasFeePreviewRef on AutoDisposeNotifierProviderRef<GasFeePreviewState> {
  /// The parameter `args` of this provider.
  GasFeePreviewArgs get args;
}

class _GasFeePreviewProviderElement
    extends
        AutoDisposeNotifierProviderElement<GasFeePreview, GasFeePreviewState>
    with GasFeePreviewRef {
  _GasFeePreviewProviderElement(super.provider);

  @override
  GasFeePreviewArgs get args => (origin as GasFeePreviewProvider).args;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
