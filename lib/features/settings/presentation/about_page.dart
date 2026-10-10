import 'package:chain_notes/common/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chain_notes/app/widgets/app_logo.dart';
import 'package:chain_notes/common/utils/app_version_info.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? scheme.surface : null,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? scheme.surface : null,
          gradient: isDark
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFf0fdf4), // green-50
                    Color(0xFFf0fdfa), // teal-50
                    Color(0xFFecfdf5), // emerald-50
                  ],
                ),
        ),
        child: Stack(
          children: [
            if (!isDark) _buildBackgroundDecorations(context),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, theme, l10n),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildLogoSection(theme, l10n),
                          const SizedBox(height: 24),
                          _buildVersionCard(theme, l10n),
                          const SizedBox(height: 24),
                          _buildFeaturesCard(theme, l10n),
                          const SizedBox(height: 24),
                          _buildTechStackCard(theme, l10n),
                          const SizedBox(height: 24),
                          _buildContactCard(context, theme, l10n),
                          const SizedBox(height: 24),
                          _buildCredits(theme, l10n),
                          const SizedBox(height: 24),
                          _buildBackButton(context, theme, l10n),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return IgnorePointer(
      child: Stack(
        children: [

          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(
                painter: _GridPainter(color: const Color(0xFF10b981)),
              ),
            ),
          ),

          Positioned(
            top: 80,
            left: 40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFF4ade80).withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ade80).withOpacity(0.15),
                    blurRadius: 32,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 128,
            right: 64,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFF2dd4bf).withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2dd4bf).withOpacity(0.15),
                    blurRadius: 32,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.45,
            left: size.width * 0.2,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF34d399).withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34d399).withOpacity(0.12),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final backBg =
        isDark ? scheme.surfaceContainerHighest : const Color(0xFFf3f4f6);
    final backIcon =
        isDark ? scheme.onSurface : const Color(0xFF374151);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          BackIconButton(
            onPressed: () {
              if (onBack != null) {
                onBack!();
              } else {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              }
            },
            backgroundColor: backBg,
            iconColor: backIcon,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.aboutUs,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? scheme.onSurface : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        const AppLogo(size: 140, variant: AppLogoVariant.iconOnly),
        const SizedBox(height: 24),
        Text(
          l10n.appTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? scheme.onSurface : const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.aboutPageTagline,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVersionCard(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      elevation: isDark ? 0 : 4,
      color: isDark ? scheme.surfaceContainerHighest : Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? scheme.outlineVariant
              : const Color(0xFF10b981).withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutPageVersionSection,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? scheme.onSurface : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            _versionRow(
              l10n.aboutPageCurrentVersion,
              AppVersionInfo.version,
              theme,
            ),
            _versionRow(l10n.aboutPageReleaseDate, AppConstants.releaseDate, theme),
            _versionRow(l10n.aboutPageBuildNumber, AppVersionInfo.buildNumber, theme, mono: true),
          ],
        ),
      ),
    );
  }

  Widget _versionRow(
    String label,
    String value,
    ThemeData theme, {
    bool mono = false,
  }) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? scheme.onSurfaceVariant : const Color(0xFF4b5563),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style:
                  (mono ? theme.textTheme.labelSmall : theme.textTheme.bodyMedium)
                      ?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? scheme.onSurface : const Color(0xFF111827),
                        fontFamily: mono ? 'monospace' : null,
                      ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final features = <(IconData, String, String)>[
      (Icons.lock_outline, l10n.aboutFeatureOnChainTitle, l10n.aboutFeatureOnChainDesc),
      (Icons.shield_outlined, l10n.aboutFeatureSecureTitle, l10n.aboutFeatureSecureDesc),
      (Icons.bolt_outlined, l10n.aboutFeatureSyncTitle, l10n.aboutFeatureSyncDesc),
      (Icons.people_outline, l10n.aboutFeatureControlTitle, l10n.aboutFeatureControlDesc),
    ];
    return Card(
      elevation: isDark ? 0 : 4,
      color: isDark ? scheme.surfaceContainerHighest : Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? scheme.outlineVariant
              : const Color(0xFF10b981).withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutPageCoreFeatures,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? scheme.onSurface : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFd1fae5), Color(0xFFccfbf1)],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        f.$1,
                        size: 20,
                        color: const Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.$2,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isDark ? scheme.onSurface : const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            f.$3,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? scheme.onSurfaceVariant
                                  : const Color(0xFF6b7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechStackCard(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    const badges = [
      'Flutter',
      'Dart',
      'GoRouter',
      'Riverpod',
      'SHA-256',
      'Blockchain',
    ];
    return Card(
      elevation: isDark ? 0 : 4,
      color: isDark ? scheme.surfaceContainerHighest : Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? scheme.outlineVariant
              : const Color(0xFF10b981).withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutPageTechStack,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? scheme.onSurface : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: badges
                  .map(
                    (name) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFd1fae5), Color(0xFFccfbf1)],
                        ),
                        border: Border.all(
                          color: const Color(0xFF10b981).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF047857),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final items = <({IconData icon, String label, String value, String? launchUrl})>[
      (
        icon: Icons.language,
        label: l10n.aboutPageOfficialWebsite,
        value: AppConstants.officialWebsiteDisplay,
        launchUrl: AppConstants.officialWebsiteUrl,
      ),
      (
        icon: Icons.email_outlined,
        label: l10n.aboutPageContactEmail,
        value: AppConstants.contact,
        launchUrl: null,
      ),
      (
        icon: Icons.code,
        label: l10n.aboutPageOpenSource,
        value: AppConstants.openSourceCodeDisplay,
        launchUrl: null,
      ),
    ];
    return Card(
      elevation: isDark ? 0 : 4,
      color: isDark ? scheme.surfaceContainerHighest : Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? scheme.outlineVariant
              : const Color(0xFF10b981).withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutPageContactUs,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? scheme.onSurface : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: item.launchUrl == null
                      ? null
                      : () => _launchExternalUrl(
                            context,
                            item.launchUrl!,
                            l10n,
                          ),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFd1fae5), Color(0xFFccfbf1)],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            item.icon,
                            size: 16,
                            color: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? scheme.onSurfaceVariant
                                      : const Color(0xFF6b7280),
                                ),
                              ),
                              Text(
                                item.value,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? scheme.onSurface
                                      : const Color(0xFF111827),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredits(ThemeData theme, AppLocalizations l10n) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final muted =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF6b7280);
    final footer =
        isDark ? scheme.onSurfaceVariant : const Color(0xFF9ca3af);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.aboutPageCreditsMadeWith,
              style: theme.textTheme.bodySmall?.copyWith(
                color: muted,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.favorite, size: 16, color: Colors.red),
            const SizedBox(width: 4),
            Text(
              AppConstants.aboutCreditsByTeam,
              style: theme.textTheme.bodySmall?.copyWith(
                color: muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.aboutPageCopyrightNotice(AppConstants.aboutCopyrightYearBrand),
          style: theme.textTheme.bodySmall?.copyWith(
            color: footer,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBackButton(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          if (onBack != null) {
            onBack!();
          } else {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF059669),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(l10n.back),
      ),
    );
  }
}

Future<void> _launchExternalUrl(
  BuildContext context,
  String url,
  AppLocalizations l10n,
) async {
  final uri = Uri.tryParse(url);
  if (uri == null || !await canLaunchUrl(uri)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.getGasCouldNotOpenLink)),
      );
    }
    return;
  }
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const step = 30.0;
    for (var x = 0.0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
