import 'package:flutter/material.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({
    super.key,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 20,
    this.shape,
    this.tooltip = '返回',
  });

  final VoidCallback onPressed;

  final Color? iconColor;

  final Color? backgroundColor;

  final double iconSize;

  final OutlinedBorder? shape;

  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? const Color(0xFF374151);
    final effectiveBackgroundColor =
        backgroundColor ?? const Color(0xFFf3f4f6);
    final effectiveShape = shape ?? const CircleBorder();

    Widget button = IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: iconSize,
        color: effectiveIconColor,
      ),
      style: IconButton.styleFrom(
        backgroundColor: effectiveBackgroundColor,
        shape: effectiveShape,
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
