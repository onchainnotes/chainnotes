import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_loading_provider.g.dart';

enum WalletLoadingCaptionPhase {
  custom,
  rotating0,
  rotating1,
  rotating2,
  rotating3,
  successCreated,
  successImported,
}

@immutable
class WalletLoadingUiState {
  const WalletLoadingUiState({
    required this.progress,
    required this.captionPhase,
  });

  final double progress;
  final WalletLoadingCaptionPhase captionPhase;

  static const initial = WalletLoadingUiState(
    progress: 0,
    captionPhase: WalletLoadingCaptionPhase.custom,
  );

  WalletLoadingUiState copyWith({
    double? progress,
    WalletLoadingCaptionPhase? captionPhase,
  }) {
    return WalletLoadingUiState(
      progress: progress ?? this.progress,
      captionPhase: captionPhase ?? this.captionPhase,
    );
  }
}

@riverpod
class WalletLoadingController extends _$WalletLoadingController {
  @override
  WalletLoadingUiState build() => WalletLoadingUiState.initial;

  void resetToInitial() {
    state = WalletLoadingUiState.initial;
  }

  void setProgress(double value) {
    state = state.copyWith(progress: value.clamp(0.0, 100.0));
  }

  void tickRotatingCaption() {
    switch (state.captionPhase) {
      case WalletLoadingCaptionPhase.custom:
      case WalletLoadingCaptionPhase.rotating0:
        state = state.copyWith(
          captionPhase: WalletLoadingCaptionPhase.rotating1,
        );
        return;
      case WalletLoadingCaptionPhase.rotating1:
        state = state.copyWith(
          captionPhase: WalletLoadingCaptionPhase.rotating2,
        );
        return;
      case WalletLoadingCaptionPhase.rotating2:
        state = state.copyWith(
          captionPhase: WalletLoadingCaptionPhase.rotating3,
        );
        return;
      case WalletLoadingCaptionPhase.rotating3:
        state = state.copyWith(
          captionPhase: WalletLoadingCaptionPhase.rotating0,
        );
        return;
      case WalletLoadingCaptionPhase.successCreated:
      case WalletLoadingCaptionPhase.successImported:
        return;
    }
  }

  void setSuccessCreated() {
    state = state.copyWith(
      captionPhase: WalletLoadingCaptionPhase.successCreated,
    );
  }

  void setSuccessImported() {
    state = state.copyWith(
      captionPhase: WalletLoadingCaptionPhase.successImported,
    );
  }
}
