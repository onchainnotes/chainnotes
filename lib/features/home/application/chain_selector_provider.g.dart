// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chain_selector_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chainSelectorMainnetChainsHash() =>
    r'14860efd2fcaaca362002647fa29e90e47b35729';

/// Copied from [chainSelectorMainnetChains].
@ProviderFor(chainSelectorMainnetChains)
final chainSelectorMainnetChainsProvider = Provider<List<Chain>>.internal(
  chainSelectorMainnetChains,
  name: r'chainSelectorMainnetChainsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chainSelectorMainnetChainsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChainSelectorMainnetChainsRef = ProviderRef<List<Chain>>;
String _$chainSelectorTestnetChainsHash() =>
    r'57a4e890830d90ae80948b145afb56ab8d9b0c20';

/// Copied from [chainSelectorTestnetChains].
@ProviderFor(chainSelectorTestnetChains)
final chainSelectorTestnetChainsProvider = Provider<List<Chain>>.internal(
  chainSelectorTestnetChains,
  name: r'chainSelectorTestnetChainsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chainSelectorTestnetChainsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChainSelectorTestnetChainsRef = ProviderRef<List<Chain>>;
String _$chainSelectorRpcLatencyHash() =>
    r'b57a40625a1e85fa6c3e924b8ab4ca6ece13cd5a';

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

/// Copied from [chainSelectorRpcLatency].
@ProviderFor(chainSelectorRpcLatency)
const chainSelectorRpcLatencyProvider = ChainSelectorRpcLatencyFamily();

/// Copied from [chainSelectorRpcLatency].
class ChainSelectorRpcLatencyFamily extends Family<AsyncValue<int?>> {

  /// Copied from [chainSelectorRpcLatency].
  const ChainSelectorRpcLatencyFamily();

  /// Copied from [chainSelectorRpcLatency].
  ChainSelectorRpcLatencyProvider call(String chainId) {
    return ChainSelectorRpcLatencyProvider(chainId);
  }

  @override
  ChainSelectorRpcLatencyProvider getProviderOverride(
    covariant ChainSelectorRpcLatencyProvider provider,
  ) {
    return call(provider.chainId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chainSelectorRpcLatencyProvider';
}

/// Copied from [chainSelectorRpcLatency].
class ChainSelectorRpcLatencyProvider extends AutoDisposeFutureProvider<int?> {

  /// Copied from [chainSelectorRpcLatency].
  ChainSelectorRpcLatencyProvider(String chainId)
    : this._internal(
        (ref) =>
            chainSelectorRpcLatency(ref as ChainSelectorRpcLatencyRef, chainId),
        from: chainSelectorRpcLatencyProvider,
        name: r'chainSelectorRpcLatencyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chainSelectorRpcLatencyHash,
        dependencies: ChainSelectorRpcLatencyFamily._dependencies,
        allTransitiveDependencies:
            ChainSelectorRpcLatencyFamily._allTransitiveDependencies,
        chainId: chainId,
      );

  ChainSelectorRpcLatencyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chainId,
  }) : super.internal();

  final String chainId;

  @override
  Override overrideWith(
    FutureOr<int?> Function(ChainSelectorRpcLatencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChainSelectorRpcLatencyProvider._internal(
        (ref) => create(ref as ChainSelectorRpcLatencyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chainId: chainId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _ChainSelectorRpcLatencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChainSelectorRpcLatencyProvider && other.chainId == chainId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chainId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChainSelectorRpcLatencyRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `chainId` of this provider.
  String get chainId;
}

class _ChainSelectorRpcLatencyProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with ChainSelectorRpcLatencyRef {
  _ChainSelectorRpcLatencyProviderElement(super.provider);

  @override
  String get chainId => (origin as ChainSelectorRpcLatencyProvider).chainId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
