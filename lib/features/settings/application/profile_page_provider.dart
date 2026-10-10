import 'dart:async';

import 'package:chain_notes/common/config/app_v2_feature_switches.dart';
import 'package:chain_notes/common/storage/preference_keys.dart';
import 'package:chain_notes/features/home/data/datasource/realm/note_realm_manager.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_page_provider.g.dart';

class ProfilePageState {
  const ProfilePageState({
    required this.currentWallet,
    required this.currentWalletName,
    required this.currentProtocolAddress,
    required this.noteCount,
    required this.onChainCount,
    required this.activeDays,
    required this.notifications,
    required this.showBindEmailDialog,
    required this.boundEmail,
    required this.codeSent,
    required this.countdown,
  });

  final String? currentWallet;
  final String? currentWalletName;
  final String? currentProtocolAddress;
  final int noteCount;
  final int onChainCount;
  final int activeDays;

  final bool notifications;
  final bool showBindEmailDialog;
  final String? boundEmail;

  final bool codeSent;
  final int countdown;

  bool get isActiveUser => onChainCount >= 10 || noteCount >= 50;

  ProfilePageState copyWith({
    String? currentWallet,
    String? currentWalletName,
    String? currentProtocolAddress,
    int? noteCount,
    int? onChainCount,
    int? activeDays,
    bool? notifications,
    bool? showBindEmailDialog,
    String? boundEmail,
    bool? codeSent,
    int? countdown,
  }) {
    return ProfilePageState(
      currentWallet: currentWallet ?? this.currentWallet,
      currentWalletName: currentWalletName ?? this.currentWalletName,
      currentProtocolAddress:
          currentProtocolAddress ?? this.currentProtocolAddress,
      noteCount: noteCount ?? this.noteCount,
      onChainCount: onChainCount ?? this.onChainCount,
      activeDays: activeDays ?? this.activeDays,
      notifications: notifications ?? this.notifications,
      showBindEmailDialog: showBindEmailDialog ?? this.showBindEmailDialog,
      boundEmail: boundEmail ?? this.boundEmail,
      codeSent: codeSent ?? this.codeSent,
      countdown: countdown ?? this.countdown,
    );
  }

  static const initial = ProfilePageState(
    currentWallet: null,
    currentWalletName: null,
    currentProtocolAddress: null,
    noteCount: 0,
    onChainCount: 0,
    activeDays: 0,
    notifications: true,
    showBindEmailDialog: false,
    boundEmail: null,
    codeSent: false,
    countdown: 0,
  );
}

@riverpod
class ProfilePageController extends _$ProfilePageController {
  Timer? _countdownTimer;
  int _walletLoadSeq = 0;

  @override
  ProfilePageState build({
    required int walletContextTick,
    required int? chainId,
  }) {
    ref.onDispose(() => _countdownTimer?.cancel());
    Future.microtask(() async {
      await refresh(chainId: chainId);
      if (AppV2FeatureSwitches.profileBindEmailNotificationsLogout) {
        await _loadBoundEmail();
      }
    });
    return ProfilePageState.initial;
  }

  Future<void> refresh({required int? chainId}) async {
    await Future.wait<void>([
      _loadWallet(chainId: chainId),
      _loadStatsFromRealm(),
    ]);
  }

  Future<void> _loadWallet({required int? chainId}) async {
    final seq = ++_walletLoadSeq;
    final addr = await loadCurrentWalletAddress();
    final displayInfo = await loadCurrentWalletDisplayInfo(addr, chainId);
    if (seq != _walletLoadSeq) return;
    state = state.copyWith(
      currentWallet: addr,
      currentWalletName: displayInfo.walletName,
      currentProtocolAddress: displayInfo.protocolAddress,
    );
  }

  Future<void> _loadStatsFromRealm() async {
    final aggregatedWalletId = await loadCurrentAggregatedWalletId();
    final notes = NoteRealmManager.instance.loadByWallet(
      aggregatedWalletId: aggregatedWalletId,
    );
    state = state.copyWith(
      noteCount: notes.length,
      onChainCount: notes.where((n) => n.onChain).length,
      activeDays: _daysSinceOldestNoteCreated(notes),
    );
  }

  static int _daysSinceOldestNoteCreated(List<Note> notes) {
    if (notes.isEmpty) return 0;
    var oldestMs = notes.first.createdAtOrUpdated;
    for (var i = 1; i < notes.length; i++) {
      final t = notes[i].createdAtOrUpdated;
      if (t < oldestMs) oldestMs = t;
    }
    final created = DateTime.fromMillisecondsSinceEpoch(oldestMs);
    final today = DateTime.now();
    final createdDay = DateTime(created.year, created.month, created.day);
    final todayDay = DateTime(today.year, today.month, today.day);
    final days = todayDay.difference(createdDay).inDays;
    return days < 0 ? 0 : days;
  }

  Future<void> _loadBoundEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(PreferenceKeys.boundEmail);
    state = state.copyWith(boundEmail: saved);
  }

  void setNotifications(bool v) {
    state = state.copyWith(notifications: v);
  }

  void openBindEmailDialog(bool v) {
    state = state.copyWith(showBindEmailDialog: v);
  }

  void startSendCodeCountdown() {
    _countdownTimer?.cancel();
    state = state.copyWith(codeSent: true, countdown: 60);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = state.countdown;
      if (left <= 1) {
        _countdownTimer?.cancel();
        state = state.copyWith(countdown: 0);
      } else {
        state = state.copyWith(countdown: left - 1);
      }
    });
  }

  Future<void> bindEmailSuccess(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.boundEmail, email);
    _countdownTimer?.cancel();
    state = state.copyWith(
      boundEmail: email,
      showBindEmailDialog: false,
      codeSent: false,
      countdown: 0,
    );
  }

  Future<void> unbindEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PreferenceKeys.boundEmail);
    _countdownTimer?.cancel();
    state = state.copyWith(
      boundEmail: null,
      showBindEmailDialog: false,
      codeSent: false,
      countdown: 0,
    );
  }
}

