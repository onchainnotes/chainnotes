import 'package:flutter/material.dart';

import '../buttons/back_icon_button.dart';

class PageHeaderWithBack extends StatelessWidget {
  const PageHeaderWithBack({
    super.key,
    required this.onBack,
    required this.title,
    this.subtitle,
    this.backgroundColor,
    this.backgroundGradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.backBackgroundColor,
    this.backIconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.spacingAfterBack = 12,
    this.titleLeading,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconSize,
    this.spacingAfterTitleLeading = 12,
    this.actions,
    this.titleWidget,
    this.trailing,
    this.showBottomDivider = false,
    this.wrapWithSafeArea = false,
    this.subtitleSpacing = 2,
  });

  final VoidCallback onBack;

  final String title;

  final String? subtitle;

  final Color? backgroundColor;

  final Gradient? backgroundGradient;

  final EdgeInsetsGeometry padding;

  final Color? backBackgroundColor;

  final Color? backIconColor;

  final TextStyle? titleStyle;

  final TextStyle? subtitleStyle;

  final double spacingAfterBack;

  final Widget? titleLeading;

  final IconData? leadingIcon;

  final Color? leadingIconColor;

  final double? leadingIconSize;

  final double spacingAfterTitleLeading;

  final List<Widget>? actions;

  final Widget? titleWidget;

  final Widget? trailing;

  final bool showBottomDivider;

  final bool wrapWithSafeArea;

  final double subtitleSpacing;

  static double _autoLeadingIconSize({
    required bool hasSubtitle,
    required double titleFontSize,
  }) {
    if (hasSubtitle) {
      return (titleFontSize * 1.08).clamp(17.0, 22.0);
    }
    return (titleFontSize * 1.38).clamp(26.0, 36.0);
  }

  static Color _effectiveBackBackground({
    required ThemeData theme,
    required ColorScheme scheme,
    required bool hasGradient,
    required Color? backBackgroundColor,
  }) {
    final requested = backBackgroundColor;
    if (requested == null) {
      return scheme.surfaceContainerHighest;
    }
    final isDark = theme.brightness == Brightness.dark;
    if (hasGradient && isDark) {
      final a = requested.a;
      final lm = requested.computeLuminance();
      if (a < 0.99 && lm > 0.75) {
        return Colors.black.withValues(
          alpha: (a * 1.1).clamp(0.12, 0.5),
        );
      }
    }
    return requested;
  }

  static Color? _effectiveBackIcon({
    required ThemeData theme,
    required ColorScheme scheme,
    required Color? backIconColor,
  }) {
    if (backIconColor != null) return backIconColor;
    return theme.brightness == Brightness.dark
        ? scheme.onSurface
        : const Color(0xFF374151);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasGradient = backgroundGradient != null;
    final effectiveBackgroundColor = backgroundColor ?? scheme.surface;
    final effectiveTitleStyle = titleStyle ??
        theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ) ??
        const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        );
    final effectiveSubtitleStyle = subtitleStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
          fontSize: 12,
        );
    final sub = subtitle?.trim();
    final showSubtitle = sub != null && sub.isNotEmpty;
    final titleFontSize = effectiveTitleStyle.fontSize ?? 18;

    final Widget? effectiveTitleLeading = titleLeading ??
        (leadingIcon != null
            ? Icon(
                leadingIcon,
                color: leadingIconColor,
                size: leadingIconSize ??
                    _autoLeadingIconSize(
                      hasSubtitle: showSubtitle,
                      titleFontSize: titleFontSize,
                    ),
              )
            : null);

    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (effectiveTitleLeading != null) ...[
              effectiveTitleLeading,
              SizedBox(width: spacingAfterTitleLeading),
            ],
            Expanded(
              child: titleWidget ??
                  Text(
                    title,
                    style: effectiveTitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
            if (actions != null && actions!.isNotEmpty) ...actions!,
          ],
        ),
        if (showSubtitle) ...[
          SizedBox(height: subtitleSpacing),
          Text(
            sub,
            style: effectiveSubtitleStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );

    final expandedTitleArea = trailing != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: titleColumn),
              trailing!,
            ],
          )
        : titleColumn;

    final inner = Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BackIconButton(
            onPressed: onBack,
            backgroundColor: _effectiveBackBackground(
              theme: theme,
              scheme: scheme,
              hasGradient: hasGradient,
              backBackgroundColor: backBackgroundColor,
            ),
            iconColor: _effectiveBackIcon(
              theme: theme,
              scheme: scheme,
              backIconColor: backIconColor,
            ),
          ),
          SizedBox(width: spacingAfterBack),
          Expanded(child: expandedTitleArea),
        ],
      ),
    );

    final gradient = backgroundGradient;
    if (gradient != null) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          border: showBottomDivider
              ? Border(
                  bottom: BorderSide(
                    color: scheme.outlineVariant,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: SafeArea(
          bottom: false,
          child: inner,
        ),
      );
    }

    Widget materialChild = inner;
    if (showBottomDivider) {
      materialChild = DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: scheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: materialChild,
      );
    }
    if (wrapWithSafeArea) {
      materialChild = SafeArea(
        bottom: false,
        child: materialChild,
      );
    }

    return Material(
      color: effectiveBackgroundColor,
      child: materialChild,
    );
  }
}
