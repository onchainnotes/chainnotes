import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/app/theme/app_brand_theme.dart';
import 'package:chain_notes/features/wallet/application/mnemonic_export_provider.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class MnemonicExportPage extends ConsumerStatefulWidget {
  const MnemonicExportPage({super.key});

  @override
  ConsumerState<MnemonicExportPage> createState() => _MnemonicExportPageState();
}

class _MnemonicExportPageState extends ConsumerState<MnemonicExportPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mnemonicExportProvider.notifier).bootstrap(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.extension<AppBrandTheme>() ?? AppBrandTheme.light;
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(mnemonicExportProvider);
    final n = ref.read(mnemonicExportProvider.notifier);

    return Scaffold(
      backgroundColor: brand.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeaderWithBack(
            onBack: () => context.pop(),
            title: l10n.mnemonicManagePageTitle,
            subtitle: l10n.mnemonicManagePageSubtitle,
            leadingIcon: Icons.vpn_key_rounded,
            leadingIconColor: brand.onSettingsHeaderSoft.withValues(
              alpha: 0.85,
            ),
            backgroundGradient: brand.settingsHeaderGradient,
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 14),
            backBackgroundColor: Colors.white12,
            backIconColor: brand.onSettingsHeader,
            titleStyle: theme.textTheme.titleLarge?.copyWith(
              color: brand.onSettingsHeader,
              fontWeight: FontWeight.w800,
            ),
            subtitleStyle: theme.textTheme.bodySmall?.copyWith(
              color: brand.onSettingsHeaderSoft.withValues(alpha: 0.85),
            ),
            spacingAfterBack: 12,
            spacingAfterTitleLeading: 12,
          ),
          Expanded(
            child: switch (s.phase) {
              MnemonicExportPhase.booting => const Center(
                child: CircularProgressIndicator(),
              ),
              MnemonicExportPhase.error => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        s.errorText ?? l10n.mnemonicBackupFlowLoadFailed,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => context.pop(),
                        child: Text(l10n.back),
                      ),
                    ],
                  ),
                ),
              ),
              MnemonicExportPhase.ready => Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            color: const Color(0xFFFFF7ED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xFFFED7AA)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange.shade700,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.mnemonicBackupFlowSecurityTipsTitle,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF9A3412),
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${l10n.mnemonicBackupFlowSecurityTip1}\n${l10n.mnemonicBackupFlowBackupAdvice3}',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: const Color(0xFF9A3412),
                                                height: 1.35,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                l10n.mnemonicBackupFlowYourMnemonicTitle,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: n.toggleShowMnemonic,
                                icon: Icon(
                                  s.showMnemonic
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 18,
                                ),
                                label: Text(
                                  s.showMnemonic
                                      ? l10n.actionHide
                                      : l10n.actionShow,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 2.2,
                                ),
                            itemCount: s.words.length,
                            itemBuilder: (context, i) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      s.showMnemonic ? s.words[i] : '•••',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'monospace',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: s.showMnemonic
                                      ? () => n.copyMnemonic(context)
                                      : null,
                                  icon: Icon(
                                    s.copied
                                        ? Icons.check
                                        : Icons.copy_outlined,
                                    size: 18,
                                  ),
                                  label: Text(
                                    s.copied ? l10n.labelCopied : l10n.copy,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: s.showMnemonic
                                      ? () => n.downloadMnemonic(context)
                                      : null,
                                  icon: const Icon(
                                    Icons.download_outlined,
                                    size: 18,
                                  ),
                                  label: Text(l10n.actionSaveToFile),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shield_outlined,
                                        size: 18,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        l10n.mnemonicExportSecurityConfirmTitle,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    value: s.saved,
                                    onChanged: (v) => n.setSaved(v ?? false),
                                    title: Text(
                                      l10n.mnemonicExportAckSaved,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                  CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    value: s.understand,
                                    onChanged: (v) =>
                                        n.setUnderstand(v ?? false),
                                    title: Text(
                                      l10n.mnemonicExportAckUnderstandLoss,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                  CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    value: s.responsibility,
                                    onChanged: (v) =>
                                        n.setResponsibility(v ?? false),
                                    title: Text(
                                      l10n.mnemonicExportAckNoShare,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Card(
                            color: const Color(0xFFEFF6FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xFFBFDBFE)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.mnemonicExportSafetyTipsTitle,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E3A8A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _tipRow(l10n.mnemonicExportSafetyTipPaper),
                                  _tipRow(l10n.mnemonicExportSafetyTipNoScreenshot),
                                  _tipRow(l10n.mnemonicExportSafetyTipCheckBackup),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BottomCtaButton(
                    label: l10n.mnemonicExportFinishCta,
                    onPressed: s.allConfirmed ? () => n.finish(context) : null,
                    variant: BottomCtaButtonVariant.primaryGreen,
                    barBackgroundColor: Colors.grey.shade50,
                    topBorder: BorderSide(color: Colors.grey.shade200),
                    topPadding: 16,
                    bottomPadding: 16,
                  ),
                ],
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _tipRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: TextStyle(color: Colors.blue.shade900, height: 1.4)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade900,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
