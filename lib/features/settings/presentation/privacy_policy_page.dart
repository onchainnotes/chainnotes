import 'package:chain_notes/common/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  static const _brand = AppBrandTheme.light;

  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    final uri = Uri.parse(AppConstants.privacyPolicyUrl);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(_brand.pageBackground)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (mounted) setState(() => _progress = p);
          },
        ),
      )
      ..loadRequest(uri);
  }

  void _goBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: _brand.pageBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeaderWithBack(
              onBack: _goBack,
              title: l10n.profilePrivacy,
              backgroundGradient: _brand.settingsHeaderGradient,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 14),
              backBackgroundColor: Colors.white12,
              backIconColor: _brand.onSettingsHeader,
              titleStyle: theme.textTheme.titleLarge?.copyWith(
                color: _brand.onSettingsHeader,
                fontWeight: FontWeight.w800,
              ),
              leadingIcon: Icons.shield_outlined,
              leadingIconColor:
                  _brand.onSettingsHeaderSoft.withValues(alpha: 0.85),
              spacingAfterTitleLeading: 12,
            ),
            if (_progress < 100)
              LinearProgressIndicator(
                value: _progress > 0 ? _progress / 100 : null,
                minHeight: 2,
                color: _brand.settingsAccent,
                backgroundColor: const Color(0xFFe5e7eb),
              ),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
