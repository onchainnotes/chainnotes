import 'package:flutter/material.dart';

import 'skeleton_loader.dart';

class FullScreenLoadingOverlay extends StatelessWidget {
  const FullScreenLoadingOverlay({
    super.key,
    this.message = 'Loading…',
    this.canDismiss = false,
    this.textColor,
  });

  final String message;

  final bool canDismiss;

  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? Colors.white;

    return PopScope(
      canPop: canDismiss,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: canDismiss ? () => Navigator.of(context).pop() : null,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            color: Colors.black54,
            child: GestureDetector(
              onTap: () {},
              child: BalanceLoading(
                variant: BalanceLoadingVariant.compact,
                textColor: effectiveTextColor,
                message: message,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showFullScreenLoading(
  BuildContext context, {
  String message = 'Loading…',
  bool canDismiss = false,
  Color? textColor,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: canDismiss,
    barrierColor: Colors.black54,
    builder: (ctx) => FullScreenLoadingOverlay(
      message: message,
      canDismiss: canDismiss,
      textColor: textColor,
    ),
  );
}
