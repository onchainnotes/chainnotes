import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// ```dart
/// CachedNetworkImageBox(
///   imageUrl: 'https://example.com/image.jpg',
///   width: 200,
///   height: 150,
///   borderRadius: BorderRadius.circular(12),
///   placeholder: Center(child: CircularProgressIndicator()),
///   errorWidget: Icon(Icons.broken_image),
/// )
/// ```
class CachedNetworkImageBox extends StatelessWidget {
  const CachedNetworkImageBox({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.ipfsToHttp,
  });

  final String imageUrl;

  final double? width;

  final double? height;

  final BoxFit fit;

  final BorderRadius? borderRadius;

  final Widget? placeholder;

  final Widget? errorWidget;

  final String Function(String ipfsUri)? ipfsToHttp;

  String get _resolvedUrl {
    if (imageUrl.startsWith('ipfs://') && ipfsToHttp != null) {
      return ipfsToHttp!(imageUrl);
    }
    return imageUrl;
  }

  bool get _isValidNetworkUrl {
    final url = _resolvedUrl;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty || !_isValidNetworkUrl) {
      return _buildPlaceholder(context);
    }

    final theme = Theme.of(context);

    Widget child = CachedNetworkImage(
      imageUrl: _resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder != null
          ? (_, __) => placeholder!
          : (_, __) => _defaultPlaceholder(theme),
      errorWidget: errorWidget != null
          ? (_, __, ___) => errorWidget!
          : (_, __, ___) => _defaultErrorWidget(theme),
    );

    if (borderRadius != null) {
      child = ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }

    return child;
  }

  Widget _defaultPlaceholder(ThemeData theme) {
    return _ImageLoadingPlaceholder(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      theme: theme,
    );
  }

  Widget _defaultErrorWidget(ThemeData theme) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.8),
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        size: 48,
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return errorWidget ??
        _defaultErrorWidget(Theme.of(context));
  }
}

class _ImageLoadingPlaceholder extends StatefulWidget {
  const _ImageLoadingPlaceholder({
    required this.width,
    required this.height,
    required this.theme,
  });

  final double width;
  final double height;
  final ThemeData theme;

  @override
  State<_ImageLoadingPlaceholder> createState() =>
      _ImageLoadingPlaceholderState();
}

class _ImageLoadingPlaceholderState extends State<_ImageLoadingPlaceholder>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _spinController;

  static const Color _gray100 = Color(0xFFf3f4f6);
  static const Color _gray200 = Color(0xFFe5e7eb);
  static const Color _gray300 = Color(0xFFd1d5db);
  static const Color _gray400 = Color(0xFF9ca3af);
  static const Color _green500 = Color(0xFF10b981);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.theme.colorScheme;
    final isDark = widget.theme.brightness == Brightness.dark;

    final List<Color> gradientColors;
    final Color iconColor;
    final Color ringBg;
    final Color ringProgress;
    if (isDark) {
      gradientColors = [
        scheme.surfaceContainerHigh,
        scheme.surfaceContainerHighest,
        scheme.surfaceContainerHigh,
      ];
      iconColor = scheme.onSurfaceVariant.withValues(alpha: 0.45);
      ringBg = scheme.outlineVariant;
      ringProgress = const Color(0xFF34d399);
    } else {
      gradientColors = const [_gray200, _gray100, _gray200];
      iconColor = _gray400;
      ringBg = _gray300;
      ringProgress = _green500;
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final pulseOpacity = 0.5 + 0.5 * _pulseController.value;
        return Opacity(
          opacity: pulseOpacity,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 24, color: iconColor),
                  RotationTransition(
                    turns: _spinController,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CustomPaint(
                        painter: _SpinnerRingPainter(
                          backgroundColor: ringBg,
                          progressColor: ringProgress,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SpinnerRingPainter extends CustomPainter {
  _SpinnerRingPainter({
    required this.backgroundColor,
    required this.progressColor,
    this.strokeWidth = 2,
  });

  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      1.57,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
