import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chain_notes/features/home/data/config/nft_config.dart';
import 'package:chain_notes/features/home/data/service/evm_transaction_history_service.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_history_provider.g.dart';

enum TransactionType { send, receive }

enum TransactionStatus { pending, success, failed }

enum TransactionHistoryListFilter { all, send, receive }

@immutable
class TransactionRecord {
  const TransactionRecord({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.symbol,
    required this.from,
    required this.to,
    required this.hash,
    required this.timestamp,
    this.gasUsed,
    this.gasFee,
    this.blockNumber,
  });

  final String id;
  final TransactionType type;
  final TransactionStatus status;
  final String amount;
  final String symbol;
  final String from;
  final String to;
  final String hash;
  final int timestamp;
  final String? gasUsed;
  final String? gasFee;
  final int? blockNumber;
}

String? blockExplorerForChainId(int? chainId) {
  const map = <int, String>{
    1: 'https://etherscan.io',
    137: 'https://polygonscan.com',
    56: 'https://bscscan.com',
    42161: 'https://arbiscan.io',
    10: 'https://optimistic.etherscan.io',
    43114: 'https://snowtrace.io',
    11155111: 'https://sepolia.etherscan.io',
    80001: 'https://mumbai.polygonscan.com',
    97: 'https://testnet.bscscan.com',
  };
  return chainId != null ? map[chainId] : null;
}

const transactionHistoryLoadErrorConnectEvm = '__CONNECT_EVM__';
const transactionHistoryLoadErrorUnsupportedNetwork = '__UNSUPPORTED_NETWORK__';

@immutable
class TransactionHistoryUiState {
  const TransactionHistoryUiState({
    this.transactions = const [],
    this.filter = TransactionHistoryListFilter.all,
    this.listLoading = true,
    this.isRefreshing = false,
    this.loadError,
    this.internalSelectedChain,
  });

  final List<TransactionRecord> transactions;
  final TransactionHistoryListFilter filter;
  final bool listLoading;
  final bool isRefreshing;
  final String? loadError;

  final Chain? internalSelectedChain;

  List<TransactionRecord> get filteredTransactions {
    switch (filter) {
      case TransactionHistoryListFilter.all:
        return transactions;
      case TransactionHistoryListFilter.send:
        return transactions.where((t) => t.type == TransactionType.send).toList();
      case TransactionHistoryListFilter.receive:
        return transactions
            .where((t) => t.type == TransactionType.receive)
            .toList();
    }
  }

  int get statTotal => transactions.length;

  int get statSuccess =>
      transactions.where((t) => t.status == TransactionStatus.success).length;

  int get statPending =>
      transactions.where((t) => t.status == TransactionStatus.pending).length;

  int get statFailed =>
      transactions.where((t) => t.status == TransactionStatus.failed).length;

  TransactionHistoryUiState copyWith({
    List<TransactionRecord>? transactions,
    TransactionHistoryListFilter? filter,
    bool? listLoading,
    bool? isRefreshing,
    String? loadError,
    bool clearLoadError = false,
    Chain? internalSelectedChain,
  }) {
    return TransactionHistoryUiState(
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
      listLoading: listLoading ?? this.listLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      internalSelectedChain:
          internalSelectedChain ?? this.internalSelectedChain,
    );
  }
}

@Riverpod(keepAlive: true)
List<Chain> transactionHistoryPickerChains(Ref ref) {
  final configuredChainIds = NftConfig.chainIdsWithContract.toSet();
  return ChainFromDemo.allChains
      .where(
        (c) =>
            c.chainId != null && configuredChainIds.contains(c.chainId),
      )
      .toList();
}

bool transactionHistoryIsEvmSupported(Chain chain) {
  final cid = chain.chainId;
  if (cid == null) return false;
  if (NftConfig.getContractAddress(cid) == null) return false;
  if (cid == 0 || cid == 501) return false;
  if (!chainHasResolvableEndpoint(chain)) return false;
  final id = chain.id.toLowerCase();
  if (id == 'bitcoin' || id.contains('solana')) return false;
  return true;
}

TransactionRecord _mapEvmItem(EvmTxListItem e, Chain chain) {
  return TransactionRecord(
    id: e.hash,
    type: e.isOutgoing ? TransactionType.send : TransactionType.receive,
    status: e.statusSuccess
        ? TransactionStatus.success
        : TransactionStatus.failed,
    amount: e.amountDisplay,
    symbol: chain.symbol,
    from: e.from,
    to: e.to,
    hash: e.hash,
    timestamp: e.timestampMs,
    gasUsed: e.gasUsedDisplay,
    gasFee: e.gasFeeDisplay,
    blockNumber: e.blockNumber,
  );
}

Chain? transactionHistoryEffectiveChain(Chain? parentChain, Chain? internal) {
  if (parentChain != null) return parentChain;
  if (internal != null) return internal;
  final main = ChainFromDemo.mainnetChains;
  return main.isNotEmpty ? main.first : null;
}

@Riverpod(keepAlive: false)
class TransactionHistoryController extends _$TransactionHistoryController {
  @override
  TransactionHistoryUiState build() {
    return const TransactionHistoryUiState();
  }

  void setFilter(TransactionHistoryListFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setInternalChain(Chain chain) {
    state = state.copyWith(internalSelectedChain: chain);
  }

  Future<bool> load({
    Chain? parentChain,
    bool showRefreshSnack = false,
  }) async {
    if (showRefreshSnack) {
      state = state.copyWith(isRefreshing: true, clearLoadError: true);
    } else {
      state = state.copyWith(listLoading: true, clearLoadError: true);
    }

    final chain = transactionHistoryEffectiveChain(
      parentChain,
      state.internalSelectedChain,
    );

    try {
      final addr = await loadCurrentWalletAddress();
      final display = await loadCurrentWalletDisplayInfo(addr, chain?.chainId);
      final queryAddr = (display.protocolAddress ?? addr)?.trim();

      if (chain == null ||
          queryAddr == null ||
          !queryAddr.toLowerCase().startsWith('0x')) {
        state = state.copyWith(
          transactions: const [],
          listLoading: false,
          isRefreshing: false,
          loadError: transactionHistoryLoadErrorConnectEvm,
        );
        return false;
      }

      if (!transactionHistoryIsEvmSupported(chain)) {
        state = state.copyWith(
          transactions: const [],
          listLoading: false,
          isRefreshing: false,
          loadError: transactionHistoryLoadErrorUnsupportedNetwork,
        );
        return false;
      }

      final items =
          await EvmTransactionHistoryService.instance.fetchTransactions(
        chain: chain,
        evmAddress: queryAddr,
        limit: 50,
      );

      state = state.copyWith(
        transactions: items.map((e) => _mapEvmItem(e, chain)).toList(),
        listLoading: false,
        isRefreshing: false,
        clearLoadError: true,
      );
      return showRefreshSnack;
    } catch (e) {
      state = state.copyWith(
        transactions: const [],
        listLoading: false,
        isRefreshing: false,
        loadError: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}
