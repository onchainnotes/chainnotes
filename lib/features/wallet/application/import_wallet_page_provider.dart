import 'package:chain_notes/features/wallet/presentation/wallet_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'import_wallet_page_provider.g.dart';

class ImportWalletPageState {
  const ImportWalletPageState({
    required this.importMethodMnemonic,
    required this.mnemonicModeIndividual,
    required this.wordCount,
    required this.selectedChain,
    required this.showPrivateKey,
  });

  final bool importMethodMnemonic;
  final bool mnemonicModeIndividual;
  final int wordCount;
  final ChainType selectedChain;
  final bool showPrivateKey;

  ImportWalletPageState copyWith({
    bool? importMethodMnemonic,
    bool? mnemonicModeIndividual,
    int? wordCount,
    ChainType? selectedChain,
    bool? showPrivateKey,
  }) {
    return ImportWalletPageState(
      importMethodMnemonic: importMethodMnemonic ?? this.importMethodMnemonic,
      mnemonicModeIndividual:
          mnemonicModeIndividual ?? this.mnemonicModeIndividual,
      wordCount: wordCount ?? this.wordCount,
      selectedChain: selectedChain ?? this.selectedChain,
      showPrivateKey: showPrivateKey ?? this.showPrivateKey,
    );
  }
}

@riverpod
class ImportWalletPage extends _$ImportWalletPage {
  @override
  ImportWalletPageState build() {
    return ImportWalletPageState(
      importMethodMnemonic: true,
      mnemonicModeIndividual: false,
      wordCount: 12,
      selectedChain: kChainTypes.first,
      showPrivateKey: false,
    );
  }

  void setImportMethodMnemonic(bool v) {
    state = state.copyWith(importMethodMnemonic: v);
  }

  void setMnemonicModeIndividual(bool v) {
    state = state.copyWith(mnemonicModeIndividual: v);
  }

  void setWordCount(int count) {
    state = state.copyWith(wordCount: count);
  }

  void setSelectedChain(ChainType chain) {
    state = state.copyWith(selectedChain: chain);
  }

  void setShowPrivateKey(bool v) {
    state = state.copyWith(showPrivateKey: v);
  }
}
