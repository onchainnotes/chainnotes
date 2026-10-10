// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionHistoryPickerChainsHash() =>
    r'57f5bbd8c89983b8ff42e900d661475ab83c1a54';

/// Copied from [transactionHistoryPickerChains].
@ProviderFor(transactionHistoryPickerChains)
final transactionHistoryPickerChainsProvider = Provider<List<Chain>>.internal(
  transactionHistoryPickerChains,
  name: r'transactionHistoryPickerChainsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionHistoryPickerChainsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionHistoryPickerChainsRef = ProviderRef<List<Chain>>;
String _$transactionHistoryControllerHash() =>
    r'62c1c308895801c38b2e044de22ecc05be5bc248';

/// Copied from [TransactionHistoryController].
@ProviderFor(TransactionHistoryController)
final transactionHistoryControllerProvider =
    AutoDisposeNotifierProvider<
      TransactionHistoryController,
      TransactionHistoryUiState
    >.internal(
      TransactionHistoryController.new,
      name: r'transactionHistoryControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionHistoryControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TransactionHistoryController =
    AutoDisposeNotifier<TransactionHistoryUiState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
