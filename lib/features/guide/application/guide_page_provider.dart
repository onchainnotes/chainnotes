import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guide_page_provider.g.dart';

@immutable
class GuidePageUiState {
  const GuidePageUiState({
    required this.isCreating,
    required this.isRestoring,
  });

  final bool isCreating;
  final bool isRestoring;

  static const initial = GuidePageUiState(
    isCreating: false,
    isRestoring: false,
  );

  GuidePageUiState copyWith({
    bool? isCreating,
    bool? isRestoring,
  }) {
    return GuidePageUiState(
      isCreating: isCreating ?? this.isCreating,
      isRestoring: isRestoring ?? this.isRestoring,
    );
  }
}

@riverpod
class GuidePageController extends _$GuidePageController {
  @override
  GuidePageUiState build() => GuidePageUiState.initial;

  void setCreating(bool value) {
    state = state.copyWith(isCreating: value);
  }

  void setRestoring(bool value) {
    state = state.copyWith(isRestoring: value);
  }
}
