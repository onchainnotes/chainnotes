import 'dart:math' as math;

import 'package:flutter/material.dart';

enum SkeletonVariant {
  text,
  circular,
  rectangular,
  balance,
}

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    this.variant = SkeletonVariant.rectangular,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;
  final SkeletonVariant variant;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = _getSize();
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            borderRadius: _getBorderRadius(),
            gradient: LinearGradient(
              begin: Alignment(-2 + 2 * _animation.value, 0),
              end: Alignment(2 * _animation.value, 0),
              colors: const [
                Color(0xFFE5E7EB),
                Color(0xFFF3F4F6),
                Color(0xFFE5E7EB),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Size _getSize() {
    if (widget.width != null || widget.height != null) {
      final w = widget.width ?? double.infinity;
      final h = widget.height ?? 16;
      if (widget.variant == SkeletonVariant.circular) {
        final s = w != double.infinity ? w : h;
        return Size(s, s);
      }
      return Size(w, h);
    }
    switch (widget.variant) {
      case SkeletonVariant.text:
        return const Size(double.infinity, 16);
      case SkeletonVariant.circular:
        return const Size(40, 40);
      case SkeletonVariant.rectangular:
        return const Size(double.infinity, 48);
      case SkeletonVariant.balance:
        return const Size(128, 40);
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.variant) {
      case SkeletonVariant.text:
        return BorderRadius.circular(4);
      case SkeletonVariant.circular:
        return BorderRadius.circular(999);
      case SkeletonVariant.rectangular:
      case SkeletonVariant.balance:
        return BorderRadius.circular(8);
    }
  }
}

class ChainLoading extends StatefulWidget {
  const ChainLoading({
    super.key,
    this.size = ChainLoadingSize.md,
  });

  final ChainLoadingSize size;

  @override
  State<ChainLoading> createState() => _ChainLoadingState();
}

enum ChainLoadingSize { sm, md, lg }

class _ChainLoadingState extends State<ChainLoading>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  double get _size {
    switch (widget.size) {
      case ChainLoadingSize.sm:
        return 24;
      case ChainLoadingSize.md:
        return 40;
      case ChainLoadingSize.lg:
        return 64;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rotateController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: Container(
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFBBF7D0),
                      width: 2,
                    ),
                  ),
                  child: CustomPaint(
                    painter: _PartialRingPainter(
                      color: const Color(0xFF059669),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = 1 + _pulseController.value * 0.1;
              final opacity = 0.7 + _pulseController.value * 0.3;
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: _size * 0.85,
                    height: _size * 0.85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFDCFCE7),
                          Color(0xFFCCFBF1),
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '🔗',
                      style: TextStyle(fontSize: _size * 0.35),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PartialRingPainter extends CustomPainter {
  _PartialRingPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      -math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum BalanceLoadingVariant { full, compact }

class BalanceLoading extends StatefulWidget {
  const BalanceLoading({
    super.key,
    this.variant = BalanceLoadingVariant.full,
    this.textColor,
    this.message,
  });

  final BalanceLoadingVariant variant;
  final Color? textColor;

  final String? message;

  @override
  State<BalanceLoading> createState() => _BalanceLoadingState();
}

class _BalanceLoadingState extends State<BalanceLoading>
    with TickerProviderStateMixin {
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant == BalanceLoadingVariant.compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    final textColor = widget.textColor ?? Colors.white.withOpacity(0.9);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _dotController,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulsingDot(
                  controller: _dotController,
                  opacity: 0.6,
                  delay: 0,
                ),
                const SizedBox(width: 4),
                _PulsingDot(
                  controller: _dotController,
                  opacity: 0.8,
                  delay: 0.2,
                ),
                const SizedBox(width: 4),
                _PulsingDot(
                  controller: _dotController,
                  opacity: 1,
                  delay: 0.4,
                ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
        Text(
          widget.message ?? 'Loading…',
          style: TextStyle(
            fontSize: 14,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFull(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const ChainLoading(size: ChainLoadingSize.sm),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(
                    variant: SkeletonVariant.balance,
                    width: 128,
                    height: 32,
                  ),
                  const SizedBox(height: 8),
                  SkeletonLoader(
                    variant: SkeletonVariant.text,
                    width: 96,
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SkeletonLoader(
                variant: SkeletonVariant.rectangular,
                height: 24,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SkeletonLoader(
                variant: SkeletonVariant.rectangular,
                height: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PulsingDot extends StatelessWidget {
  const _PulsingDot({
    required this.controller,
    required this.opacity,
    required this.delay,
  });

  final AnimationController controller;
  final double opacity;
  final double delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = (controller.value + delay) % 1.0;
        final scale = 1 + 0.3 * math.sin(t * 2 * math.pi);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(opacity),
            ),
          ),
        );
      },
    );
  }
}

class NoteLoading extends StatelessWidget {
  const NoteLoading({super.key, this.count = 1});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(count, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(
                  variant: SkeletonVariant.rectangular,
                  width: 64,
                  height: 64,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(
                        variant: SkeletonVariant.text,
                        width: 150,
                        height: 16,
                      ),
                      const SizedBox(height: 8),
                      SkeletonLoader(
                        variant: SkeletonVariant.text,
                        height: 12,
                      ),
                      const SizedBox(height: 4),
                      SkeletonLoader(
                        variant: SkeletonVariant.text,
                        width: 200,
                        height: 12,
                      ),
                      const SizedBox(height: 4),
                      SkeletonLoader(
                        variant: SkeletonVariant.text,
                        width: 96,
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
