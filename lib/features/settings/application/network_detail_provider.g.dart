// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$networkDetailControllerHash() =>
    r'383a4fc6e5b5432e3414745321efa90360961d4d';

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

abstract class _$NetworkDetailController
    extends BuildlessAutoDisposeAsyncNotifier<NetworkDetailViewState> {
  late final String chainId;

  FutureOr<NetworkDetailViewState> build(String chainId);
}

/// See also [NetworkDetailController].
@ProviderFor(NetworkDetailController)
const networkDetailControllerProvider = NetworkDetailControllerFamily();

/// See also [NetworkDetailController].
class NetworkDetailControllerFamily
    extends Family<AsyncValue<NetworkDetailViewState>> {
  /// See also [NetworkDetailController].
  const NetworkDetailControllerFamily();

  /// See also [NetworkDetailController].
  NetworkDetailControllerProvider call(String chainId) {
    return NetworkDetailControllerProvider(chainId);
  }

  @override
  NetworkDetailControllerProvider getProviderOverride(
    covariant NetworkDetailControllerProvider provider,
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
  String? get name => r'networkDetailControllerProvider';
}

/// See also [NetworkDetailController].
class NetworkDetailControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          NetworkDetailController,
          NetworkDetailViewState
        > {
  /// See also [NetworkDetailController].
  NetworkDetailControllerProvider(String chainId)
    : this._internal(
        () => NetworkDetailController()..chainId = chainId,
        from: networkDetailControllerProvider,
        name: r'networkDetailControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$networkDetailControllerHash,
        dependencies: NetworkDetailControllerFamily._dependencies,
        allTransitiveDependencies:
            NetworkDetailControllerFamily._allTransitiveDependencies,
        chainId: chainId,
      );

  NetworkDetailControllerProvider._internal(
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
  FutureOr<NetworkDetailViewState> runNotifierBuild(
    covariant NetworkDetailController notifier,
  ) {
    return notifier.build(chainId);
  }

  @override
  Override overrideWith(NetworkDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: NetworkDetailControllerProvider._internal(
        () => create()..chainId = chainId,
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
  AutoDisposeAsyncNotifierProviderElement<
    NetworkDetailController,
    NetworkDetailViewState
  >
  createElement() {
    return _NetworkDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NetworkDetailControllerProvider && other.chainId == chainId;
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
mixin NetworkDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<NetworkDetailViewState> {
  /// The parameter `chainId` of this provider.
  String get chainId;
}

class _NetworkDetailControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          NetworkDetailController,
          NetworkDetailViewState
        >
    with NetworkDetailControllerRef {
  _NetworkDetailControllerProviderElement(super.provider);

  @override
  String get chainId => (origin as NetworkDetailControllerProvider).chainId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
