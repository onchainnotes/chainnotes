import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:chain_notes/features/wallet/application/mnemonic_backup_flow_provider.dart';
import 'package:chain_notes/generated/l10n/app_localizations.dart';

class MnemonicBackupFlowPage extends ConsumerStatefulWidget {
  const MnemonicBackupFlowPage({super.key});

  @override
  ConsumerState<MnemonicBackupFlowPage> createState() =>
      _MnemonicBackupFlowPageState();
}

class _MnemonicBackupFlowPageState
    extends ConsumerState<MnemonicBackupFlowPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mnemonicBackupFlowProvider.notifier).bootstrap(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final s = ref.watch(mnemonicBackupFlowProvider);
    final n = ref.read(mnemonicBackupFlowProvider.notifier);

    if (s.loadPhase == MnemonicBackupLoadPhase.booting) {
      return Scaffold(
        backgroundColor: scheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (s.loadPhase == MnemonicBackupLoadPhase.error) {
      return Scaffold(
        backgroundColor: isDark ? scheme.surface : Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeaderWithBack(
              onBack: () => n.popOrGoHome(context),
              title: l10n.mnemonicBackupFlowTitle,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.errorText ?? l10n.mnemonicBackupFlowLoadFailed,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => n.popOrGoHome(context),
                        child: Text(l10n.back),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final canNext = switch (s.step) {
      1 => true,
      2 => true,
      3 => s.step3Verified,
      4 => true,
      _ => false,
    };

    final nextLabel = switch (s.step) {
      1 => l10n.mnemonicBackupFlowCTAUnderstoodStart,
      2 => l10n.mnemonicBackupFlowCTACopiedContinue,
      3 =>
        s.step3Verified
            ? l10n.mnemonicBackupFlowCTAVerifiedContinue
            : l10n.mnemonicBackupFlowCTAPleaseVerify,
      4 => l10n.mnemonicBackupFlowCTAFinish,
      _ => l10n.mnemonicBackupFlowCTANext,
    };

    const headerGradient = LinearGradient(
      colors: [Color(0xFF059669), Color(0xFF0d9488)],
    );

    return Scaffold(
      backgroundColor: isDark ? scheme.surface : Colors.white,
      body: Column(
        children: [
          PageHeaderWithBack(
            onBack: () => n.onBack(context),
            title: l10n.mnemonicBackupFlowTitle,
            subtitle: l10n.mnemonicBackupFlowStepProgress(s.step, 4),
            leadingIcon: Icons.vpn_key_rounded,
            leadingIconColor: Colors.white,
            backgroundGradient: headerGradient,
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
            backBackgroundColor: Colors.white.withValues(alpha: 0.22),
            backIconColor: Colors.white,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            subtitleStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: _stepDots(
              s,
              inactiveColor: isDark
                  ? scheme.outlineVariant
                  : Colors.grey.shade300,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: _buildStepContent(context, l10n, s, n),
            ),
          ),
          BottomCtaButton(
            label: nextLabel,
            onPressed: canNext ? () => n.onPrimaryButton(context) : null,
            variant: BottomCtaButtonVariant.primaryGreen,
            barBackgroundColor: isDark ? scheme.surface : Colors.white,
            topBorder: BorderSide(
              color: isDark ? scheme.outlineVariant : Colors.grey.shade200,
            ),
            height: 52,
            horizontalPadding: 24,
            topPadding: 12,
            bottomPadding: 24,
            borderRadius: 12,
            trailing: s.step < 4
                ? const Icon(Icons.arrow_forward, size: 20)
                : null,
          ),
          if (s.step == 2)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SafeArea(
                top: false,
                child: Text(
                  l10n.mnemonicBackupFlowFooterCopyHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? scheme.onSurfaceVariant
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stepDots(MnemonicBackupFlowState s, {required Color inactiveColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final n = i + 1;
        final active = n == s.step;
        final done = n < s.step;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 32 : 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: done || active ? const Color(0xFF059669) : inactiveColor,
            gradient: active
                ? const LinearGradient(
                    colors: [Color(0xFF059669), Color(0xFF0d9488)],
                  )
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    AppLocalizations l10n,
    MnemonicBackupFlowState s,
    MnemonicBackupFlow n,
  ) {
    return switch (s.step) {
      1 => _step1(context, l10n),
      2 => _step2(context, l10n, s, n),
      3 => _step3(context, l10n, s, n),
      4 => _step4(context, l10n),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _step1(BuildContext context, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        _circleIcon(
          Icons.warning_amber_rounded,
          const Color(0xFFfef3c7),
          const Color(0xFFd97706),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.mnemonicBackupFlowStep1Heading,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.mnemonicBackupFlowStep1Subheading,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? scheme.onSurfaceVariant : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        _infoCard(
          border: const Color(0xFFfecaca),
          bg: const Color(0xFFfef2f2),
          icon: Icons.shield_outlined,
          iconColor: const Color(0xFFdc2626),
          title: l10n.mnemonicBackupFlowSecurityTipsTitle,
          child: _bulletList([
            l10n.mnemonicBackupFlowSecurityTip1,
            l10n.mnemonicBackupFlowSecurityTip2,
            l10n.mnemonicBackupFlowSecurityTip3,
          ], const Color(0xFF991b1b)),
        ),
        const SizedBox(height: 12),
        _infoCard(
          border: const Color(0xFF86efac),
          bg: const Color(0xFFf0fdf4),
          icon: Icons.lock_outline,
          iconColor: const Color(0xFF15803d),
          title: l10n.mnemonicBackupFlowBackupAdviceTitle,
          child: _bulletList([
            l10n.mnemonicBackupFlowBackupAdvice1,
            l10n.mnemonicBackupFlowBackupAdvice2,
            l10n.mnemonicBackupFlowBackupAdvice3,
            l10n.mnemonicBackupFlowBackupAdvice4,
          ], const Color(0xFF166534)),
        ),
        const SizedBox(height: 12),
        _infoCard(
          border: const Color(0xFF93c5fd),
          bg: const Color(0xFFeff6ff),
          icon: Icons.description_outlined,
          iconColor: const Color(0xFF2563eb),
          title: l10n.mnemonicBackupFlowProcessTitle,
          child: _numberedList([
            l10n.mnemonicBackupFlowProcess1,
            l10n.mnemonicBackupFlowProcess2,
            l10n.mnemonicBackupFlowProcess3,
          ], const Color(0xFF1e40af)),
        ),
      ],
    );
  }

  Widget _step2(
    BuildContext context,
    AppLocalizations l10n,
    MnemonicBackupFlowState s,
    MnemonicBackupFlow n,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        _circleIcon(
          Icons.vpn_key_rounded,
          const Color(0xFFd1fae5),
          const Color(0xFF059669),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.mnemonicBackupFlowYourMnemonicTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.mnemonicBackupFlowYourMnemonicSubtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? scheme.onSurfaceVariant : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF86efac), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    size: 18,
                    color: Color(0xFF059669),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.mnemonicBackupFlowWordCount(s.words.length),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: n.toggleShowMnemonic,
                    icon: Icon(
                      s.showMnemonic
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                  IconButton(
                    onPressed: s.showMnemonic
                        ? () => n.copyMnemonic(context)
                        : null,
                    icon: Icon(
                      s.copied ? Icons.check : Icons.copy_outlined,
                      color: s.copied ? Colors.green : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, box) {
                  const gap = 10.0;
                  final cellW = (box.maxWidth - gap) / 2;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (int i = 0; i < s.words.length; i++)
                        SizedBox(
                          width: cellW,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? scheme.surfaceContainerHighest
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDark
                                    ? scheme.outlineVariant
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFdcfce7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF15803d),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    s.showMnemonic
                                        ? s.words[i]
                                        : List.filled(
                                            s.words[i].length,
                                            '*',
                                          ).join(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'monospace',
                                      height: 1.25,
                                      color: s.showMnemonic
                                          ? (isDark
                                                ? scheme.onSurface
                                                : Colors.grey.shade900)
                                          : (isDark
                                                ? scheme.onSurfaceVariant
                                                : Colors.grey.shade400),
                                    ),
                                    maxLines: 3,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _infoCard(
          border: const Color(0xFFfde047),
          bg: const Color(0xFFfefce8),
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFca8a04),
          title: l10n.mnemonicBackupFlowPleaseNoteTitle,
          child: Text(
            l10n.mnemonicBackupFlowStep2NoteBody,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.amber.shade900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _step3(
    BuildContext context,
    AppLocalizations l10n,
    MnemonicBackupFlowState s,
    MnemonicBackupFlow n,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        _circleIcon(
          Icons.check_circle_outline,
          const Color(0xFFfae8ff),
          const Color(0xFF9333ea),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.mnemonicBackupFlowVerifyTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.mnemonicBackupFlowVerifySubtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        ...s.verifyIndices.map((wordIndex) {
          final correct = s.words[wordIndex];
          final options = s.optionsPerIndex[wordIndex] ?? [];
          final selected = s.userSelections[wordIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? scheme.outlineVariant : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mnemonicBackupFlowVerifyWordQuestion(wordIndex + 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.4,
                    children: options.map((word) {
                      final isSel = selected == word;
                      final isCorrect = isSel && word == correct;
                      final isWrong = isSel && word != correct;
                      Color? border;
                      Color? bg;
                      var fg = isDark ? scheme.onSurface : Colors.grey.shade800;
                      if (isCorrect) {
                        border = Colors.green;
                        bg = Colors.green.shade50;
                        fg = Colors.green.shade900;
                      } else if (isWrong) {
                        border = Colors.red;
                        bg = Colors.red.shade50;
                        fg = Colors.red.shade900;
                      } else if (isSel) {
                        border = Colors.blue;
                        bg = Colors.blue.shade50;
                      }
                      return Material(
                        color: bg ?? (isDark ? scheme.surface : Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () => n.selectVerifyWord(wordIndex, word),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    border ??
                                    (isDark
                                        ? scheme.outlineVariant
                                        : Colors.grey.shade300),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    word,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: fg,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isCorrect) ...[
                                  const SizedBox(width: 4),
                                  Icon(Icons.check, size: 16, color: fg),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }),
        if (s.step3Verified)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade600,
                  radius: 20,
                  child: const Icon(Icons.check_circle, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.mnemonicBackupFlowVerifySuccessTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      Text(
                        l10n.mnemonicBackupFlowVerifySuccessBody,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _step4(BuildContext context, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        const SizedBox(height: 16),
        _circleIcon(
          Icons.auto_awesome,
          const Color(0xFFd1fae5),
          const Color(0xFF059669),
          size: 96,
          iconSize: 48,
        ),
        const SizedBox(height: 20),
        Text(
          l10n.mnemonicBackupFlowDoneTitle,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.mnemonicBackupFlowDoneSubtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? scheme.onSurfaceVariant : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 28),
        _infoCard(
          border: const Color(0xFF86efac),
          bg: const Color(0xFFf0fdf4),
          icon: Icons.check_circle_outline,
          iconColor: const Color(0xFF15803d),
          title: l10n.mnemonicBackupFlowDoneSectionTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _checkLine(l10n.mnemonicBackupFlowDoneCheck1),
              _checkLine(l10n.mnemonicBackupFlowDoneCheck2),
              _checkLine(l10n.mnemonicBackupFlowDoneCheck3),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _infoCard(
          border: const Color(0xFF93c5fd),
          bg: const Color(0xFFeff6ff),
          icon: Icons.shield_outlined,
          iconColor: const Color(0xFF2563eb),
          title: l10n.mnemonicBackupFlowDoneSecurityTitle,
          child: _bulletList([
            l10n.mnemonicBackupFlowDoneSecurity1,
            l10n.mnemonicBackupFlowDoneSecurity2,
            l10n.mnemonicBackupFlowDoneSecurity3,
            l10n.mnemonicBackupFlowDoneSecurity4,
          ], const Color(0xFF1e40af)),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFfaf5ff),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFe9d5ff)),
          ),
          child: Column(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purple.shade600, size: 32),
              const SizedBox(height: 8),
              Text(
                l10n.mnemonicBackupFlowFinalEncouragementTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.purple.shade900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.mnemonicBackupFlowFinalEncouragementBody,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.purple.shade800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleIcon(
    IconData icon,
    Color bg,
    Color fg, {
    double size = 80,
    double iconSize = 40,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [bg, bg.withValues(alpha: 0.7)]),
      ),
      child: Icon(icon, size: iconSize, color: fg),
    );
  }

  Widget _infoCard({
    required Color border,
    required Color bg,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: iconColor.withValues(alpha: 0.95),
                  ),
                ),
                const SizedBox(height: 8),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulletList(List<String> lines, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: color)),
                  Expanded(
                    child: Text(
                      t,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _numberedList(List<String> lines, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${i + 1}. ', style: TextStyle(color: color)),
              Expanded(
                child: Text(
                  lines[i],
                  style: TextStyle(fontSize: 13, height: 1.35, color: color),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _checkLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.check, size: 18, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.green.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
