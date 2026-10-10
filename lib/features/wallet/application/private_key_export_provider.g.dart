// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_key_export_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$privateKeyExportChainsHash() =>
    r'f8f302c63828b6343c0a22732aa4327b499d7841';

/// Copied from [privateKeyExportChains].
@ProviderFor(privateKeyExportChains)
final privateKeyExportChainsProvider =
    AutoDisposeProvider<List<Chain>>.internal(
      privateKeyExportChains,
      name: r'privateKeyExportChainsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$privateKeyExportChainsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PrivateKeyExportChainsRef = AutoDisposeProviderRef<List<Chain>>;
String _$privateKeyExportHash() => r'80374ecc9c77a5a23a0844820258b723189082ab';

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

abstract class _$PrivateKeyExport
    extends BuildlessAutoDisposeNotifier<PrivateKeyExportState> {
  late final String walletAddress;

  PrivateKeyExportState build(String walletAddress);
}

/// See also [PrivateKeyExport].
@ProviderFor(PrivateKeyExport)
const privateKeyExportProvider = PrivateKeyExportFamily();

/// See also [PrivateKeyExport].
class PrivateKeyExportFamily extends Family<PrivateKeyExportState> {
  /// See also [PrivateKeyExport].
  const PrivateKeyExportFamily();

  /// See also [PrivateKeyExport].
  PrivateKeyExportProvider call(String walletAddress) {
    return PrivateKeyExportProvider(walletAddress);
  }

  @override
  PrivateKeyExportProvider getProviderOverride(
    covariant PrivateKeyExportProvider provider,
  ) {
    return call(provider.walletAddress);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'privateKeyExportProvider';
}

/// See also [PrivateKeyExport].
class PrivateKeyExportProvider
    extends
        AutoDisposeNotifierProviderImpl<
          PrivateKeyExport,
          PrivateKeyExportState
        > {
  /// See also [PrivateKeyExport].
  PrivateKeyExportProvider(String walletAddress)
    : this._internal(
        () => PrivateKeyExport()..walletAddress = walletAddress,
        from: privateKeyExportProvider,
        name: r'privateKeyExportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$privateKeyExportHash,
        dependencies: PrivateKeyExportFamily._dependencies,
        allTransitiveDependencies:
            PrivateKeyExportFamily._allTransitiveDependencies,
        walletAddress: walletAddress,
      );

  PrivateKeyExportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.walletAddress,
  }) : super.internal();

  final String walletAddress;

  @override
  PrivateKeyExportState runNotifierBuild(covariant PrivateKeyExport notifier) {
    return notifier.build(walletAddress);
  }

  @override
  Override overrideWith(PrivateKeyExport Function() create) {
    return ProviderOverride(
      origin: this,
      override: PrivateKeyExportProvider._internal(
        () => create()..walletAddress = walletAddress,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        walletAddress: walletAddress,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PrivateKeyExport, PrivateKeyExportState>
  createElement() {
    return _PrivateKeyExportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PrivateKeyExportProvider &&
        other.walletAddress == walletAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, walletAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PrivateKeyExportRef
    on AutoDisposeNotifierProviderRef<PrivateKeyExportState> {
  /// The parameter `walletAddress` of this provider.
  String get walletAddress;
}

class _PrivateKeyExportProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          PrivateKeyExport,
          PrivateKeyExportState
        >
    with PrivateKeyExportRef {
  _PrivateKeyExportProviderElement(super.provider);

  @override
  String get walletAddress =>
      (origin as PrivateKeyExportProvider).walletAddress;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
