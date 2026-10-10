import 'package:flutter/material.dart';

class RefreshIconButton extends StatelessWidget {
  const RefreshIconButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 22,
    this.indicatorSize = 20,
    this.indicatorStrokeWidth = 2,
    this.tooltip = '刷新',
    this.shape,
    this.padding,
    this.minimumSize,
    this.tapTargetSize,
    this.visualDensity,
    this.progressColor,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? iconColor;
  final Color? backgroundColor;
  final double iconSize;
  final double indicatorSize;
  final double indicatorStrokeWidth;
  final String? tooltip;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final MaterialTapTargetSize? tapTargetSize;
  final VisualDensity? visualDensity;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? const Color(0xFF374151);
    final effectiveBackgroundColor =
        backgroundColor ?? const Color(0xFFf3f4f6);
    final effectiveShape = shape ?? const CircleBorder();

    Widget button = IconButton(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: indicatorSize,
              height: indicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: indicatorStrokeWidth,
                color: progressColor,
              ),
            )
          : Icon(
              Icons.refresh_rounded,
              size: iconSize,
              color: effectiveIconColor,
            ),
      style: IconButton.styleFrom(
        backgroundColor: effectiveBackgroundColor,
        shape: effectiveShape,
        padding: padding,
        minimumSize: minimumSize,
        tapTargetSize: tapTargetSize,
        visualDensity: visualDensity,
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
