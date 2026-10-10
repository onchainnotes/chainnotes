import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/app_bootstrap.dart';
import 'package:chain_notes/app/widgets/splash_screen.dart';
import 'package:chain_notes/features/wallet/presentation/wallet_loading_page.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/features/auth/presentation/login_page.dart';
import 'package:chain_notes/features/guide/presentation/guide_page.dart';
import 'package:chain_notes/features/home/application/notes_provider.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/auth/presentation/widgets/password_verify_dialog.dart';
import 'package:chain_notes/features/wallet/data/datasource/chain_from_demo.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/home/data/service/gas_speed.dart';
import 'package:chain_notes/features/settings/domain/effective_chain_endpoints.dart';
import 'package:chain_notes/features/settings/presentation/about_page.dart';
import 'package:chain_notes/features/settings/presentation/privacy_policy_page.dart';
import 'package:chain_notes/features/settings/presentation/terms_of_service_page.dart';
import 'package:chain_notes/features/settings/presentation/help_center_page.dart';
import 'package:chain_notes/features/settings/presentation/language_settings_page.dart';
import 'package:chain_notes/features/home/presentation/home_shell_page.dart';
import 'package:chain_notes/features/note/presentation/my_notes_page.dart';
import 'package:chain_notes/features/note/presentation/note_detail_page.dart';
import 'package:chain_notes/features/home/presentation/chain_selector_page.dart';
import 'package:chain_notes/features/note/application/gas_fee_preview_provider.dart';
import 'package:chain_notes/features/note/presentation/gas_fee_preview_page.dart';
import 'package:chain_notes/features/note/presentation/note_editor_page.dart';
import 'package:chain_notes/features/settings/presentation/network_detail_page.dart';
import 'package:chain_notes/features/settings/presentation/network_settings_page.dart';
import 'package:chain_notes/features/settings/presentation/test_page.dart';
import 'package:chain_notes/features/note/presentation/note_on_chain_confirm_page.dart';
import 'package:chain_notes/features/home/presentation/transaction_history_page.dart';
import 'package:chain_notes/features/auth/presentation/change_password_page.dart';
import 'package:chain_notes/features/auth/presentation/create_wallet_password_page.dart';
import 'package:chain_notes/features/wallet/presentation/mnemonic_backup_flow_page.dart';
import 'package:chain_notes/features/wallet/presentation/mnemonic_export_page.dart';
import 'package:chain_notes/features/wallet/presentation/private_key_export_page.dart';
import 'package:chain_notes/features/wallet/presentation/wallet_management_page.dart';
import 'package:chain_notes/features/wallet/presentation/wallet_db_data_page.dart';
import 'package:chain_notes/features/wallet/presentation/wallet_page.dart';
import 'package:chain_notes/app/providers.dart';
import 'package:chain_notes/features/home/data/datasource/realm/note_realm_manager.dart';
import 'package:chain_notes/features/home/data/service/nft_mint_orchestrator.dart';
import 'package:chain_notes/features/note/data/service/ipfs_service.dart';
import 'package:chain_notes/features/wallet/utils/evm_signing_helper.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';

bool _isInsufficientFundsForMint(Object e) {
  final s = e.toString().toLowerCase();
  return s.contains('insufficient funds') ||
      s.contains('insufficient balance for gas') ||
      s.contains('gas * price + value') ||
      (s.contains('overshot') && s.contains('tx cost'));
}

void _showMintFailureSnackBar(BuildContext context, Object e) {
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context)!;
  final insufficient = _isInsufficientFundsForMint(e);
  final String message;
  if (insufficient) {
    if (kDebugMode) {
      message = l10n.mintFailedGasDebug(e.toString());
    } else {
      message = l10n.mintFailedGasUser;
    }
  } else {
    message = l10n.mintFailedGeneric(e.toString());
  }
  debugPrint('mint failed: $e');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: insufficient && kDebugMode ? 12 : 5),
      backgroundColor: insufficient
          ? const Color(0xFFb45309)
          : const Color(0xFFdc2626),
    ),
  );
}

int _readGasPreviewNoteSizeBytes(Map<String, dynamic> extra) {
  final v = extra['noteSizeBytes'];
  if (v == null) return 1024;
  if (v is int) return v > 0 ? v : 1024;
  if (v is num) {
    final i = v.round();
    return i > 0 ? i : 1024;
  }
  if (v is String) {
    final i = int.tryParse(v.trim());
    if (i != null && i > 0) return i;
  }
  return 1024;
}

Map<String, dynamic> _buildNoteEditorExtra(
  BuildContext context,
  WidgetRef ref,
  Note note,
  Notes notesNotifier,
) {
  return <String, dynamic>{
    'note': note,
    'onUpdateNote': (String id, Map<String, dynamic> updates) async {
      final chain = ref.read(currentChainProvider);
      final chainId = chain?.chainId;
      final walletId = await loadCurrentAggregatedWalletId();
      if (chainId != null) {
        notesNotifier.updateNote(
          id,
          {...updates, 'chainId': chainId, 'aggregatedWalletId': walletId},
        );
      } else {
        notesNotifier.updateNote(
          id,
          {...updates, 'aggregatedWalletId': walletId},
        );
      }
      final updated = notesNotifier.getNote(id);
      if (updated != null && chainId != null) {
        NoteRealmManager.instance.saveNote(
          updated,
          chainId,
          aggregatedWalletId: walletId,
        );
        ref.invalidate(realmHasAnyNotesProvider);
      }
    },
    'onPublishToBlockchain':
        (String id, GasSpeed gasSpeed,
            {String? verifiedMasterKeyBase64,
            bool suppressSuccessNavigation = false}) async {
      final l10n = AppLocalizations.of(context)!;
      final chain = ref.read(currentChainProvider);
      if (chain == null || !chainHasResolvableEndpoint(chain)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.selectEvmChainFirst)),
          );
        }
        return const NotePublishResult(ok: false);
      }
      final n = notesNotifier.getNote(id);
      if (n == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noteNotFoundShort)),
          );
        }
        return const NotePublishResult(ok: false);
      }
      final addr = await loadCurrentWalletAddress();
      final displayInfo = await loadCurrentWalletDisplayInfo(
        addr,
        chain.chainId,
      );
      final toAddress = displayInfo.protocolAddress ?? addr;
      if (toAddress == null || toAddress.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.createOrSelectWalletFirst)),
          );
        }
        return const NotePublishResult(ok: false);
      }
      if (!context.mounted) return const NotePublishResult(ok: false);
      String? masterKey = verifiedMasterKeyBase64;
      if (masterKey == null) {
        masterKey = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const PasswordVerifyDialog(
            purpose: PasswordVerifyPurpose.mintNft,
          ),
        );
      }
      if (masterKey == null || !context.mounted) {
        return const NotePublishResult(ok: false);
      }
      final pk = await EvmSigningHelper.getEvmPrivateKey(
        masterKeyBase64: masterKey,
        currentAddress: addr,
        evmAddressHint: toAddress,
      );
      if (pk == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.privateKeyDecryptFailedHint),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return const NotePublishResult(ok: false);
      }
      if (!context.mounted) return const NotePublishResult(ok: false);
      final navigator = Navigator.of(context);
      showFullScreenLoading(
        context,
        message: l10n.uploadingIpfsAndMinting,
        canDismiss: false,
      );
      ({
        String tokenUri,
        String contentUri,
        String contentHash,
        List<String> imageIpfsUrls,
        String contentWithIpfsImages
      })? uploadedIpfs;
      try {
        final result = await IpfsService.instance.uploadNoteAsNftTokenUri(
          note: n,
          authorAddress: toAddress,
        );
        uploadedIpfs = result;
        final mintResult = await NftMintOrchestrator.instance.mint(
          privateKeyBytes: pk,
          note: n,
          chain: chain,
          toAddress: toAddress,
          gasSpeed: gasSpeed,
          tokenUri: result.tokenUri,
          contentUri: result.contentUri,
        );
        final txHash = mintResult.txHash;
        final tokenId = mintResult.tokenId.toString();
        if (context.mounted) {
          navigator.pop();
        }
        final walletId = await loadCurrentAggregatedWalletId();
        final chainIdInt = chain.chainId!;

        final storageId = '${chainIdInt}_$tokenId';
        notesNotifier.updateNote(id, {
          'blockchainHash': txHash,
          'onChain': true,
          'type': NoteType.onchain,
          'chainId': chain.chainId,
          'aggregatedWalletId': walletId,
          'contentHash': result.contentHash,
          'author': toAddress,
          'imageUrls': result.imageIpfsUrls,
          'content': result.contentWithIpfsImages,
          'tokenUri': result.tokenUri,
          'contentUri': result.contentUri,
          'tokenId': tokenId,
        });
        final updated = notesNotifier.getNote(id);
        if (updated != null) {
          final canonical = updated.copyWith(id: storageId);
          NoteRealmManager.instance.saveNote(
            canonical,
            chainIdInt,
            aggregatedWalletId: walletId,
          );
          if (id != storageId) {
            NoteRealmManager.instance.deleteNote(id);
          }
          ref.invalidate(notesProvider);
          ref.invalidate(realmHasAnyNotesProvider);
        }
        if (!suppressSuccessNavigation && context.mounted) {
          final messenger = ScaffoldMessenger.of(context);
          context.go(AppRoutes.home);
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.onChainSuccessTx(txHash))),
          );
        }
        return NotePublishResult(ok: true, txHash: txHash);
      } catch (e) {
        navigator.pop();
        if (context.mounted) {
          _showMintFailureSnackBar(context, e);

          if (uploadedIpfs != null) {
            notesNotifier.updateNote(id, {
              'imageUrls': uploadedIpfs.imageIpfsUrls,
              'content': uploadedIpfs.contentWithIpfsImages,
              'tokenUri': uploadedIpfs.tokenUri,
              'contentUri': uploadedIpfs.contentUri,
              'contentHash': uploadedIpfs.contentHash,
              'onChain': false,
              'type': NoteType.draft,
            });
          }
          final note = notesNotifier.getNote(id);
          if (note != null && chain.chainId != null) {
            final walletId = await loadCurrentAggregatedWalletId();
            NoteRealmManager.instance.saveNote(
              note,
              chain.chainId!,
              aggregatedWalletId: walletId,
            );
          }
          if (uploadedIpfs != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.draftSavedIpfsRetry)),
            );
          }
        }
        rethrow;
      }
    },
  };
}

abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String guide = '/';
  static const String home = '/home';
  static const String notes = '/notes';
  static const String noteDetail = '/note/detail';
  static const String noteEditor = '/note/editor';
  static const String gasFeePreview = '/note/gas-fee';
  static const String noteOnChainConfirm = '/note/on-chain-confirm';
  static const String about = '/about';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String helpCenter = '/help-center';
  static const String languageSettings = '/settings/language';
  static const String login = '/login';
  static const String wallet = '/wallet';
  static const String walletManagement = '/wallet/management';
  static const String mnemonicExport = '/wallet/mnemonic-export';
  static const String mnemonicBackupFlow = '/wallet/mnemonic-backup-flow';
  static const String privateKeyExport = '/wallet/private-key-export';
  static const String createWalletPassword = '/wallet/create-password';
  static const String changePassword = '/wallet/change-password';
  static const String chainSelector = '/chain-selector';
  static const String networkSettings = '/settings/network';
  static const String networkDetail = '/settings/network/detail';
  static const String transactionHistory = '/transaction-history';
  static const String loading = '/loading';
  static const String test = '/test';
  static const String walletDbData = '/test/wallet-db-data';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (BuildContext context, GoRouterState state) => SplashScreen(
        bootstrapFuture: AppBootstrap.ensureStarted(),
        onFinish: () {
          if (WalletUtils.hasWalletInRealm()) {
            context.go(AppRoutes.home);
          } else {
            context.go(AppRoutes.guide);
          }
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.guide,
      name: 'guide',
      builder: (BuildContext context, GoRouterState state) => const GuidePage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return Consumer(
          builder: (context, ref, _) {
            final currentChain = ref.watch(currentChainProvider);
            final notesAsync = ref.watch(notesProvider);
            final notes = notesAsync.value ?? [];
            final notesLoading = notesAsync.isLoading;
            final notesSyncing = ref.watch(notesSyncingProvider);
            final realmHasNotes = ref.watch(realmHasAnyNotesProvider);
            final notesNotifier = ref.read(notesProvider.notifier);
            return HomeShellPage(
              currentChain: currentChain ?? (ChainFromDemo.mainnetChains.isNotEmpty ? ChainFromDemo.mainnetChains.first : null),
              onChainChange: (chain) {
                ref.read(currentChainProvider.notifier).setChain(chain);
              },
              notes: notes,
              notesLoading: notesLoading,
              notesSyncing: notesSyncing,
              realmHasNotes: realmHasNotes,
              onWalletChange: () =>
                  refreshHomeContext(ProviderScope.containerOf(context)),
              onCreateNote: () {
                final now = DateTime.now().millisecondsSinceEpoch;
                final newNote = Note(
                  id: 'new_$now',
                  title: '',
                  content: '',
                  updatedAt: now,
                  type: NoteType.draft,
                );
                context.push(
                  AppRoutes.noteEditor,
                  extra: _buildNoteEditorExtra(context, ref, newNote, notesNotifier),
                );
              },
              onOpenMnemonicExport: () =>
                  context.push(AppRoutes.mnemonicExport),
              onOpenWalletManagement: () => context.push(AppRoutes.walletManagement),
              onNavigateToAbout: () => context.push(AppRoutes.about),
              onOpenTransactionHistory: () =>
                  context.push(AppRoutes.transactionHistory),
            );
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutes.notes,
      name: 'notes',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final chain = extra['currentChain'] as Chain?;
        return MyNotesPage(
          currentChain: chain,
          onChainChange: (_) {},
          onSelectNote: (Note note) {
            context.pop();
            context.push(
              AppRoutes.noteDetail,
              extra: <String, dynamic>{'note': note},
            );
          },
          onClose: () => context.pop(),
          onCreateNote: () {
            context.pop();
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.createNoteNotImplemented)));
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutes.noteDetail,
      name: 'noteDetail',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final note = extra['note'] as Note?;
        if (note == null) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.noteNotFoundBack),
              ),
            ),
          );
        }
        return Consumer(
          builder: (context, ref, _) {
            final notesNotifier = ref.read(notesProvider.notifier);
            return NoteDetailPage(
              note: note,
              onBack: () => context.pop(),
              onEdit: () {
                final extra = _buildNoteEditorExtra(context, ref, note, notesNotifier);
                extra['isEditing'] = true;
                context.push(AppRoutes.noteEditor, extra: extra);
              },
            );
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutes.noteEditor,
      name: 'noteEditor',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final note = extra['note'] as Note?;
        if (note == null) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.noteNotFoundBack),
              ),
            ),
          );
        }
        final onUpdateNote =
            extra['onUpdateNote']
                as void Function(String id, Map<String, dynamic> updates)?;
        final onPublishToBlockchain = extra['onPublishToBlockchain'] as Future<
                NotePublishResult> Function(
          String id,
          GasSpeed gasSpeed, {
          String? verifiedMasterKeyBase64,
          bool suppressSuccessNavigation,
        })?;
        final isEditing = extra['isEditing'] as bool? ?? false;
        return Consumer(
          builder: (context, ref, _) {
            final currentChain = ref.watch(currentChainProvider);
            return NoteEditorPage(
              note: note,
              isEditing: isEditing,
              onUpdateNote:
                  onUpdateNote ?? (String id, Map<String, dynamic> updates) {},
              onPublishToBlockchain: onPublishToBlockchain ??
                  (String id, GasSpeed gasSpeed,
                          {String? verifiedMasterKeyBase64,
                          bool suppressSuccessNavigation = false}) async =>
                      const NotePublishResult(ok: false),
              onClose: () => context.pop(),
              currentChain: currentChain,
            );
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutes.gasFeePreview,
      name: 'gasFeePreview',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final chain = extra['chain'] as Chain?;
        final noteId = extra['noteId'] as String? ?? '';
        final noteSizeBytes = _readGasPreviewNoteSizeBytes(extra);
        if (chain == null) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.pop<GasSpeed?>(null),
                child: Text(l10n.back),
              ),
            ),
          );
        }
        return GasFeePreviewPage(
          args: GasFeePreviewArgs(
            chain: chain,
            noteId: noteId,
            noteSizeBytes: noteSizeBytes,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.noteOnChainConfirm,
      name: 'noteOnChainConfirm',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra;
        final args = extra is NoteOnChainConfirmArgs
            ? extra
            : (extra is Map && extra['args'] is NoteOnChainConfirmArgs
                ? extra['args'] as NoteOnChainConfirmArgs
                : null);
        if (args == null) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () =>
                    context.pop(const NoteOnChainConfirmPop.cancelled()),
                child: Text(l10n.back),
              ),
            ),
          );
        }
        final onExecutePublish = extra is Map
            ? extra['onExecutePublish'] as Future<NotePublishResult> Function(
                String masterKeyBase64,
              )?
            : null;
        return NoteOnChainConfirmPage(
          args: args,
          onExecutePublish: onExecutePublish,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.about,
      name: 'about',
      builder: (BuildContext context, GoRouterState state) => const AboutPage(),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      name: 'privacy-policy',
      builder: (BuildContext context, GoRouterState state) =>
          const PrivacyPolicyPage(),
    ),
    GoRoute(
      path: AppRoutes.termsOfService,
      name: 'terms-of-service',
      builder: (BuildContext context, GoRouterState state) =>
          const TermsOfServicePage(),
    ),
    GoRoute(
      path: AppRoutes.helpCenter,
      name: 'help-center',
      builder: (BuildContext context, GoRouterState state) =>
          const HelpCenterPage(),
    ),
    GoRoute(
      path: AppRoutes.languageSettings,
      name: 'languageSettings',
      builder: (BuildContext context, GoRouterState state) =>
          const LanguageSettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.wallet,
      name: 'wallet',
      builder: (BuildContext context, GoRouterState state) => WalletPage(
        onImportMnemonic: (words, length) => context.pop(),
        onImportPrivateKey: (privateKey) => context.pop(),
      ),
    ),
    GoRoute(
      path: AppRoutes.walletManagement,
      name: 'walletManagement',
      builder: (BuildContext context, GoRouterState state) =>
          WalletManagementPage(onBack: () => context.pop()),
    ),
    GoRoute(
      path: AppRoutes.mnemonicExport,
      name: 'mnemonicExport',
      builder: (BuildContext context, GoRouterState state) =>
          const MnemonicExportPage(),
    ),
    GoRoute(
      path: AppRoutes.mnemonicBackupFlow,
      name: 'mnemonicBackupFlow',
      builder: (BuildContext context, GoRouterState state) =>
          const MnemonicBackupFlowPage(),
    ),
    GoRoute(
      path: AppRoutes.privateKeyExport,
      name: 'privateKeyExport',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final addr = extra['walletAddress'] as String? ?? '';
        return PrivateKeyExportPage(walletAddress: addr);
      },
    ),
    GoRoute(
      path: AppRoutes.createWalletPassword,
      name: 'createWalletPassword',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final resetPasswordOnly = extra['resetPasswordOnly'] == true;
        final importMnemonic = extra['importMnemonic'] as String?;
        final importPrivateKey = extra['importPrivateKey'] as String?;
        return CreateWalletPasswordPage(
          resetPasswordOnly: resetPasswordOnly,
          importMnemonic: importMnemonic,
          importPrivateKey: importPrivateKey,
          onBack: () => context.pop(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      name: 'changePassword',
      builder: (BuildContext context, GoRouterState state) =>
          ChangePasswordPage(onBack: () => context.pop()),
    ),
    GoRoute(
      path: AppRoutes.chainSelector,
      name: 'chainSelector',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final currentChain = extra['currentChain'] as Chain?;
        final showAllChainsOption = extra['showAllChainsOption'] as bool? ?? false;
        final currentChainId = extra['currentChainId'] as int?;
        return ChainSelectorPage(
          currentChain: currentChain,
          currentChainId: currentChainId,
          showAllChainsOption: showAllChainsOption,
          onBack: () => context.pop(),
          onChainSelect: (chain) => context.pop(chain),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.networkSettings,
      name: 'networkSettings',
      builder: (BuildContext context, GoRouterState state) =>
          const NetworkSettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.networkDetail,
      name: 'networkDetail',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final chain = extra['chain'] as Chain?;
        if (chain == null) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.back),
              ),
            ),
          );
        }
        return NetworkDetailPage(chain: chain);
      },
    ),
    GoRoute(
      path: AppRoutes.transactionHistory,
      name: 'transactionHistory',
      builder: (BuildContext context, GoRouterState state) {
        return Consumer(
          builder: (context, ref, _) {
            final currentChain = ref.watch(currentChainProvider) ??
                (ChainFromDemo.mainnetChains.isNotEmpty ? ChainFromDemo.mainnetChains.first : null);
            return TransactionHistoryPage(
              onBack: () => context.pop(),
              currentChain: currentChain,
              onChainChange: (chain) {
                ref.read(currentChainProvider.notifier).setChain(chain);
              },
            );
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutes.loading,
      name: 'loading',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final onBack = extra['onBack'] as VoidCallback?;
        final message = extra['message'] as String?;
        final duration = extra['duration'] as int?;
        final masterKeyBase64 = extra['masterKeyBase64'] as String?;

        final createNewWallet =
            state.uri.queryParameters['createNewWallet'] == '1' ||
            (extra['createNewWallet'] as bool? ?? false);
        final importMnemonic = extra['importMnemonic'] as String?;
        final importPrivateKey = extra['importPrivateKey'] as String?;
        final l10n = AppLocalizations.of(context)!;
        return WalletLoadingPage(
          onBack: onBack,
          message: message ?? l10n.loadingDefault,
          duration: duration,
          masterKeyBase64: masterKeyBase64,
          createNewWallet: createNewWallet,
          importMnemonic: importMnemonic,
          importPrivateKey: importPrivateKey,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.test,
      name: 'test',
      builder: (BuildContext context, GoRouterState state) => const TestPage(),
    ),
    GoRoute(
      path: AppRoutes.walletDbData,
      name: 'walletDbData',
      builder: (BuildContext context, GoRouterState state) =>
          const WalletDbDataPage(),
    ),
  ],
);
