import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:go_router/go_router.dart';
import 'package:chain_notes/app/router.dart';
import 'package:chain_notes/common/storage/preference_keys.dart';
import 'package:chain_notes/features/wallet/application/wallet_loading_provider.dart';
import 'package:chain_notes/features/wallet/data/crypto/wallet_crypto_service.dart';
import 'package:chain_notes/features/wallet/domain/entity/aggregated_wallet.dart';
import 'package:chain_notes/features/wallet/domain/entity/chain_type.dart';
import 'package:chain_notes/features/wallet/domain/entity/import_wallet_result.dart';
import 'package:chain_notes/features/wallet/presentation/widgets/wallet_selector_dialog.dart';
import 'package:chain_notes/features/wallet/utils/wallet_utils.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:chain_notes/shared/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletLoadingPage extends ConsumerStatefulWidget {
  const WalletLoadingPage({
    super.key,
    this.onBack,
    this.message = '加载中...',
    this.duration,
    this.masterKeyBase64,
    this.createNewWallet = false,
    this.importMnemonic,
    this.importPrivateKey,
  });

  final VoidCallback? onBack;

  final String message;

  final int? duration;

  final String? masterKeyBase64;

  final bool createNewWallet;

  final String? importMnemonic;

  final String? importPrivateKey;

  @override
  ConsumerState<WalletLoadingPage> createState() => _WalletLoadingPageState();
}

class _WalletLoadingPageState extends ConsumerState<WalletLoadingPage>
    with TickerProviderStateMixin {
  Timer? _progressTimer;
  Timer? _textTimer;
  late final AnimationController _rotationController1;
  late final AnimationController _rotationController2;
  late final AnimationController _pulseController;
  late final AnimationController _bounceController;
  late final AnimationController _shimmerController;

  // ignore: unused_field
  List<int>? _decryptedDataKey;

  AggregatedWallet? _generatedAggregatedWallet;

  List<int>? getDecryptedDataKey() => _decryptedDataKey;

  AggregatedWallet? getGeneratedAggregatedWallet() =>
      _generatedAggregatedWallet;

  void _toastErrorAndPop(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (widget.onBack != null) {
        widget.onBack!.call();
        return;
      }

      if (context.canPop()) {
        context.pop();
        return;
      }

      if (WalletUtils.hasWalletInRealm()) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.guide);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _rotationController1 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotationController2 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    FlutterTrustWalletCore.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(walletLoadingControllerProvider.notifier).resetToInitial();

      if (widget.masterKeyBase64 != null) {
        _decryptDataKey().then((_) {
          if (mounted) _generateWallet();
        });
      }

      if (widget.duration != null) {
        _startProgressAnimation();
        _startTextAnimation();
      }
    });
  }

  Future<void> _decryptDataKey() async {
    try {
      final crypto = WalletCryptoServiceImpl.instance;
      final storage = SecureStorageService.instance;

      final masterKeyBytes = base64Decode(widget.masterKeyBase64!);
      final masterKey = SecretKey(masterKeyBytes);

      final encryptedDataKey = await storage.getEncryptedDataKey();
      if (encryptedDataKey == null) {
        debugPrint('WalletLoadingPage: 未找到加密的 DataKey');
        return;
      }

      final dataKey = await crypto.decryptDataKey(
        masterKey: masterKey,
        encryptedDataKey: encryptedDataKey,
      );

      _decryptedDataKey = dataKey;
      debugPrint('WalletLoadingPage: DataKey 解密成功，长度: ${dataKey.length} bytes');
    } catch (e) {
      debugPrint('WalletLoadingPage: DataKey 解密失败: $e');
    }
  }

  Future<void> _handleImportSuccess(AggregatedWallet aggregatedWallet) async {
    final isImport = (widget.importMnemonic != null &&
            widget.importMnemonic!.trim().isNotEmpty) ||
        (widget.importPrivateKey != null &&
            widget.importPrivateKey!.trim().isNotEmpty);
    final evmWallet = aggregatedWallet.wallets
        .where((w) => w.chainType == ChainType.evm)
        .firstOrNull;
    final representativeAddress =
        evmWallet?.address ?? aggregatedWallet.wallets.first.address;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.currentWallet, representativeAddress);
    if (!mounted) return;
    final notifier = ref.read(walletLoadingControllerProvider.notifier);
    if (isImport) {
      notifier.setSuccessImported();
    } else {
      notifier.setSuccessCreated();
    }
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    refreshHomeContext(ProviderScope.containerOf(context));
    context.go(AppRoutes.home);
  }

  Future<void> _generateWallet() async {
    try {
      if (_decryptedDataKey == null) {
        debugPrint('WalletLoadingPage: DataKey 未解密，无法生成钱包');
        if (!mounted) return;
        _toastErrorAndPop(AppLocalizations.of(context)!.walletErrDecryptFailed);
        return;
      }

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;

      final pkImport = widget.importPrivateKey?.trim();
      if (pkImport != null && pkImport.isNotEmpty) {
        final result = await WalletUtils.importPrivateKeyWallet(
          privateKeyHexInput: pkImport,
          dataKey: _decryptedDataKey!,
          walletName: WalletUtils.nextDefaultPrivateKeyWalletName(l10n),
        );
        switch (result) {
          case ImportWalletDuplicate():
            if (!mounted) return;
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.walletImportDuplicatePk)),
            );
            if (mounted) {
              context.pop();
              if (mounted) context.pop();
            }
            return;
          case ImportWalletInvalidPrivateKey():
            if (!mounted) return;
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.walletImportInvalidPrivateKeyRetry)),
            );
            if (mounted) context.pop();
            return;
          case ImportWalletSuccess(:final wallet):
            _generatedAggregatedWallet = wallet;
            _handleImportSuccess(wallet);
            return;
          case ImportWalletInvalidMnemonic():
            break;
        }
        return;
      }

      final walletName = WalletUtils.nextDefaultCreatedWalletName(l10n);
      final bool isMnemonicImport = widget.importMnemonic != null &&
          widget.importMnemonic!.trim().isNotEmpty;
      if (isMnemonicImport) {
        final result = await WalletUtils.importWallet(
          mnemonic: widget.importMnemonic!.trim(),
          dataKey: _decryptedDataKey!,
          walletName: walletName,
        );
        switch (result) {
          case ImportWalletDuplicate():
            if (!mounted) return;
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.walletImportDuplicateMnemonic)),
            );
            if (mounted) {
              context.pop();
              if (mounted) context.pop();
            }
            return;
          case ImportWalletInvalidMnemonic():
            if (!mounted) return;
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.walletImportInvalidMnemonicRetry)),
            );
            if (mounted) context.pop();
            return;
          case ImportWalletSuccess(:final wallet):
            _generatedAggregatedWallet = wallet;
            _handleImportSuccess(wallet);
            return;
          case ImportWalletInvalidPrivateKey():
            break;
        }
        return;
      }

      final aggregatedWallet = await WalletUtils.generateWallet(
        dataKey: _decryptedDataKey!,
        walletName: walletName,
      );

      if (aggregatedWallet != null) {
        _generatedAggregatedWallet = aggregatedWallet;
        _handleImportSuccess(aggregatedWallet);
      } else {
        debugPrint('WalletLoadingPage: 生成钱包失败');
        final l10n = AppLocalizations.of(context)!;
        _toastErrorAndPop(l10n.createAccountFailedRetry);
      }
    } catch (e) {
      debugPrint('WalletLoadingPage: 生成钱包失败: $e');
      final l10n = AppLocalizations.of(context)!;
      _toastErrorAndPop(l10n.createAccountFailedWithError(e.toString()));
    }
  }

  void _startProgressAnimation() {
    final stepDuration = widget.duration! / 100;
    final notifier = ref.read(walletLoadingControllerProvider.notifier);
    _progressTimer = Timer.periodic(
      Duration(milliseconds: stepDuration.round()),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        final progress = ref.read(walletLoadingControllerProvider).progress;
        if (progress >= 100) {
          timer.cancel();
          if (widget.onBack != null) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) widget.onBack!();
            });
          }
        } else {
          notifier.setProgress(progress + 1);
        }
      },
    );
  }

  void _startTextAnimation() {
    final stepDuration = widget.duration! / 4;
    final notifier = ref.read(walletLoadingControllerProvider.notifier);
    _textTimer = Timer.periodic(Duration(milliseconds: stepDuration.round()), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      notifier.tickRotatingCaption();
    });
  }

  String _captionText(AppLocalizations l10n, WalletLoadingUiState ui) {
    switch (ui.captionPhase) {
      case WalletLoadingCaptionPhase.custom:
        return widget.message;
      case WalletLoadingCaptionPhase.rotating0:
        return l10n.walletLoadingStepConnecting;
      case WalletLoadingCaptionPhase.rotating1:
        return l10n.walletLoadingStepVerifying;
      case WalletLoadingCaptionPhase.rotating2:
        return l10n.walletLoadingStepSyncing;
      case WalletLoadingCaptionPhase.rotating3:
        return l10n.walletLoadingStepComplete;
      case WalletLoadingCaptionPhase.successCreated:
        return l10n.walletCreated;
      case WalletLoadingCaptionPhase.successImported:
        return l10n.walletImportSuccess;
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _textTimer?.cancel();
    _rotationController1.dispose();
    _rotationController2.dispose();
    _pulseController.dispose();
    _bounceController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf0fdf4), // green-50
              Color(0xFFf0fdfa), // teal-50
              Color(0xFFecfdf5), // emerald-50
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [

            _buildBackgroundDecorations(),

            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Positioned.fill(
      child: Stack(
        children: [

          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                color: const Color(0xFF86efac).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.3 + (_pulseController.value * 0.2),
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF86efac).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            right: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFF5eead4).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.2 + (_pulseController.value * 0.3),
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF5eead4).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: MediaQuery.of(context).size.width * 0.5,
            child: Transform.translate(
              offset: const Offset(-192, -192),
              child: Container(
                width: 384,
                height: 384,
                decoration: BoxDecoration(
                  color: const Color(0xFF6ee7b7).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.1 + (_pulseController.value * 0.2),
                      child: child,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6ee7b7).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    const horizontalInset = 24.0;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalInset),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                _buildLogoArea(),
                const SizedBox(height: 48),

                _buildTitle(),
                const SizedBox(height: 12),

                _buildSubtitle(),
                const SizedBox(height: 32),

                _buildLoadingText(),
                const SizedBox(height: 24),

                if (widget.duration != null) _buildProgressBar(),
                const Spacer(flex: 3),

                _buildDots(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoArea() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [

          AnimatedBuilder(
            animation: _rotationController1,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController1.value * 2 * math.pi,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.transparent, width: 4),
                  ),
                  child: CustomPaint(
                    painter: _PartialCirclePainter(
                      topColor: const Color(0xFF4ade80).withOpacity(0.5),
                      rightColor: const Color(0xFF2dd4bf).withOpacity(0.5),
                      strokeWidth: 4,
                    ),
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _rotationController2,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_rotationController2.value * 2 * math.pi,
                child: Container(
                  width: 144,
                  height: 144,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CustomPaint(
                    painter: _PartialCirclePainter(
                      bottomColor: const Color(0xFF2dd4bf).withOpacity(0.4),
                      leftColor: const Color(0xFF10b981).withOpacity(0.4),
                      strokeWidth: 4,
                    ),
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.3 + (_pulseController.value * 0.3),
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF86efac).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          _buildHexagonLogo(),

          _buildDecorationIcons(),
        ],
      ),
    );
  }

  Widget _buildHexagonLogo() {
    return CustomPaint(
      size: const Size(96, 96),
      painter: _HexagonPainter(),
      child: Center(
        child: AnimatedBuilder(
          animation: _bounceController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -_bounceController.value * 8),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                size: 44,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDecorationIcons() {
    return Stack(
      children: [

        Positioned(
          top: -8,
          right: -8,
          child: AnimatedBuilder(
            animation: _bounceController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_bounceController.value * 4),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4ade80), Color(0xFF14b8a6)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),

        Positioned(
          bottom: -8,
          left: -8,
          child: AnimatedBuilder(
            animation: _bounceController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceController.value * 4),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2dd4bf), Color(0xFF10b981)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.storage_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),

        Positioned(
          top: -8,
          left: -8,
          child: AnimatedBuilder(
            animation: _bounceController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_bounceController.value * 4),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF10b981), Color(0xFF22c55e)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    final l10n = AppLocalizations.of(context)!;
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF16a34a), // green-600
          Color(0xFF14b8a6), // teal-600
          Color(0xFF059669), // emerald-600
        ],
      ).createShader(bounds),
      child: Text(
        l10n.appTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.walletLoadingTagline,
      style: const TextStyle(fontSize: 14, color: Color(0xFF4b5563)),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoadingText() {
    final l10n = AppLocalizations.of(context)!;
    final ui = ref.watch(walletLoadingControllerProvider);
    final caption = _captionText(l10n, ui);
    const spinnerSize = 20.0;
    const gap = 12.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final textMaxWidth = (constraints.maxWidth - spinnerSize - gap)
            .clamp(0.0, double.infinity);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: SizedBox(
                width: spinnerSize,
                height: spinnerSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14b8a6)),
                ),
              ),
            ),
            const SizedBox(width: gap),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: textMaxWidth),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  caption,
                  key: ValueKey(caption),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar() {
    final progress = ref.watch(walletLoadingControllerProvider).progress;
    return Column(
      children: [
        Container(
          width: 256,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFe5e7eb).withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 256 * (progress / 100),
                height: 8,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF22c55e), // green-500
                      Color(0xFF14b8a6), // teal-500
                      Color(0xFF10b981), // emerald-500
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _ShimmerPainter(
                        progress: _shimmerController.value,
                      ),
                      child: child,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${progress.toInt()}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF14b8a6),
          ),
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _bounceController,
          builder: (context, child) {

            final delay = index * 0.2;
            final phase = (_bounceController.value + delay) % 1.0;
            final bounceValue = math.sin(phase * 2 * math.pi);
            final normalizedBounce = (bounceValue + 1) / 2;
            return Transform.translate(
              offset: Offset(0, -normalizedBounce * 8),
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4ade80), Color(0xFF2dd4bf)],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _PartialCirclePainter extends CustomPainter {
  _PartialCirclePainter({
    this.topColor,
    this.rightColor,
    this.bottomColor,
    this.leftColor,
    required this.strokeWidth,
  });

  final Color? topColor;
  final Color? rightColor;
  final Color? bottomColor;
  final Color? leftColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (topColor != null) {
      paint.color = topColor!;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        math.pi / 2,
        false,
        paint,
      );
    }

    if (rightColor != null) {
      paint.color = rightColor!;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        math.pi / 2,
        false,
        paint,
      );
    }

    if (bottomColor != null) {
      paint.color = bottomColor!;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi / 2,
        math.pi / 2,
        false,
        paint,
      );
    }

    if (leftColor != null) {
      paint.color = leftColor!;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        math.pi / 2,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_PartialCirclePainter oldDelegate) {
    return oldDelegate.topColor != topColor ||
        oldDelegate.rightColor != rightColor ||
        oldDelegate.bottomColor != bottomColor ||
        oldDelegate.leftColor != leftColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final r = w / 2 - 4;

    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * math.pi / 180;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF22c55e), // green-500
          Color(0xFF14b8a6), // teal-500
          Color(0xFF10b981), // emerald-500
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, strokePaint);

    final glowPaint = Paint()
      ..color = const Color(0xFF22c55e).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: [
          (progress - 0.3).clamp(0.0, 1.0),
          progress.clamp(0.0, 1.0),
          (progress + 0.3).clamp(0.0, 1.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
