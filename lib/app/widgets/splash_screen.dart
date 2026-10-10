import 'package:flutter/material.dart';
import 'package:chain_notes/common/utils/app_version_info.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.bootstrapFuture,
    required this.onFinish,
  });

  final Future<void> bootstrapFuture;

  final VoidCallback onFinish;

  static const Duration minDisplayDuration = Duration(milliseconds: 400);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color _background = Color(0xFF1a3b3c);

  late AnimationController _logoFadeController;
  late AnimationController _sloganFadeController;
  late AnimationController _versionFadeController;

  @override
  void initState() {
    super.initState();

    _logoFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _sloganFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _versionFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Future<void> runSequence() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _sloganFadeController.forward();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _versionFadeController.forward();
    }

    runSequence();

    Future<void> exitWhenReady() async {
      await Future.wait<void>([
        Future<void>.delayed(SplashScreen.minDisplayDuration),
        widget.bootstrapFuture,
      ]);
      if (!mounted) return;
      widget.onFinish();
    }

    exitWhenReady();
  }

  @override
  void dispose() {
    _logoFadeController.dispose();
    _sloganFadeController.dispose();
    _versionFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: _background,
      child: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              _buildLogo(),
              const SizedBox(height: 32),
              _buildSlogan(l10n),
              const Spacer(),
              _buildVersion(l10n),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _logoFadeController,
        curve: Curves.easeOut,
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1).animate(
          CurvedAnimation(parent: _logoFadeController, curve: Curves.easeOut),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = MediaQuery.sizeOf(context).width * 0.88;
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxW.clamp(260.0, 460.0),
              ),
              child: Image.asset(
                'assets/app_logo_text_pure.png',
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlogan(AppLocalizations l10n) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _sloganFadeController,
        curve: Curves.easeOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _sloganFadeController,
                curve: Curves.easeOut,
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.aboutPageTagline,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFe5e7eb),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildVersion(AppLocalizations l10n) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _versionFadeController,
        curve: Curves.easeOut,
      ),
      child: Text(
        l10n.splashVersionLabel(AppVersionInfo.version),
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF9ca3af),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
