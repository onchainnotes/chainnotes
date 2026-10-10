import 'package:flutter/material.dart';

enum BottomCtaButtonVariant {

  primaryGreen,

  destructiveRed,

  primary,
}

class BottomCtaButton extends StatelessWidget {
  const BottomCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BottomCtaButtonVariant.primaryGreen,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.labelMaxLines = 1,
    this.height = 48,
    this.horizontalPadding = 16,
    this.topPadding = 12,
    this.bottomPadding = 16,
    this.borderRadius = 12,
    this.barBackgroundColor,
    this.topBorder,
  });

  final String label;
  final VoidCallback? onPressed;
  final BottomCtaButtonVariant variant;
  final bool isLoading;

  final Widget? leading;

  final Widget? trailing;

  final int? labelMaxLines;

  final double height;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final double borderRadius;

  final Color? barBackgroundColor;

  final BorderSide? topBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final bg = barBackgroundColor ?? (isDark ? scheme.surface : Colors.white);

    final (btnBg, btnFg, shadowColor) = switch (variant) {
      BottomCtaButtonVariant.primaryGreen => (
        const Color(0xFF059669),
        Colors.white,
        const Color(0xFF059669).withValues(alpha: 0.30),
      ),
      BottomCtaButtonVariant.destructiveRed => (
        const Color(0xFFdc2626),
        Colors.white,
        const Color(0xFFdc2626).withValues(alpha: 0.24),
      ),
      BottomCtaButtonVariant.primary => (
        scheme.primary,
        scheme.onPrimary,
        scheme.primary.withValues(alpha: 0.22),
      ),
    };

    final effectiveOnPressed = isLoading ? null : onPressed;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        border: topBorder == null ? null : Border(top: topBorder!),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topPadding,
          horizontalPadding,
          bottomPadding,
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: FilledButton(
              onPressed: effectiveOnPressed,
              style: FilledButton.styleFrom(
                backgroundColor: btnBg,
                foregroundColor: btnFg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: 2,
                shadowColor: shadowColor,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: btnFg,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (leading != null) ...[
                          leading!,
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            label,
                            maxLines: labelMaxLines,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (trailing != null) ...[
                          const SizedBox(width: 8),
                          trailing!,
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
