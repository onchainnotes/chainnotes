import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

enum AppLogoVariant {

  default_,

  iconOnly,
}

class AppLogo extends StatefulWidget {
  const AppLogo({
    super.key,
    this.size = 120,
    this.variant = AppLogoVariant.default_,
    this.isLoading = false,
  });

  final double size;
  final AppLogoVariant variant;
  final bool isLoading;

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  double get _iconSize =>
      widget.variant == AppLogoVariant.iconOnly ? widget.size : widget.size * 0.6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = SizedBox(
      width: _iconSize,
      height: _iconSize,
      child: widget.isLoading
          ? RotationTransition(
              turns: _spinController,
              child: Image.asset(
                'assets/app_logo_pure.png',
                width: _iconSize,
                height: _iconSize,
                fit: BoxFit.contain,
              ),
            )
          : Image.asset(
              'assets/app_logo_pure.png',
              width: _iconSize,
              height: _iconSize,
              fit: BoxFit.contain,
            ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        if (widget.variant == AppLogoVariant.default_) ...[
          const SizedBox(height: 12),
          if (widget.isLoading)
            _LoadingText(theme: theme)
          else
            _LogoText(theme: theme),
        ],
      ],
    );
  }
}

class _LogoText extends StatelessWidget {
  const _LogoText({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF059669), Color(0xFF0d9488)],
      ).createShader(bounds),
      child: Text(
        l10n.appTitle,
        style: theme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LoadingText extends StatefulWidget {
  const _LoadingText({required this.theme});

  final ThemeData theme;

  @override
  State<_LoadingText> createState() => _LoadingTextState();
}

class _LoadingTextState extends State<_LoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.loadingDefault,
          style: widget.theme.textTheme.bodyMedium?.copyWith(
            color: widget.theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        BounceDots(controller: _bounceController),
      ],
    );
  }
}

class BounceDots extends StatelessWidget {
  const BounceDots({super.key, required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final t = (controller.value + delay) % 1.0;
            final dotY = 4 * math.sin(t * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.translate(
                offset: Offset(0, -dotY),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10b981),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
