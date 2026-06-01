import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../core/theme/cohere_colors.dart';
import '../../../../core/widgets/cohere_settings_widgets.dart';
import '../../../settings/domain/app_settings.dart';
import '../../../settings/presentation/utils/calculation_method_labels.dart';
import '../../../settings/presentation/utils/settings_value_labels.dart';
import '../../../../l10n/app_localizations.dart';

class SetupChecklistBody extends StatelessWidget {
  const SetupChecklistBody({
    required this.settings,
    this.onContinue,
    super.key,
  });

  final AppSettings settings;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final rule = CohereColors.surfRule(brightness);
    final accent = CohereColors.accentColor(brightness);
    final setup = settings.setup;
    final calc = settings.calculation;
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final canContinue = onContinue != null;

    return Scaffold(
      backgroundColor: surfPage,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: surfPage,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, statusBarHeight * 2, 24, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.setup.toUpperCase(),
                    style: cohereMonoLabel(
                      context,
                      fontSize: 11,
                      letterSpacing: 0.12,
                      color: inkDim,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.setupRequiredTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.setupRequiredMessage,
                    style: TextStyle(fontSize: 14, color: inkDim, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
          CohereSectionLabel(label: l10n.setupChecklistGroupLabel),
          _SetupRow(
            label: l10n.calculationMethodTitle,
            value: setup.isCalculationConfigured
                ? calculationMethodLabel(calc.method)
                : l10n.chooseCalculationMethod,
            isDone: setup.isCalculationConfigured,
            isOptional: false,
            isFirst: true,
            rule: rule,
            ink: ink,
            inkMute: inkMute,
            accent: accent,
            onTap: () => context.push('/setup/calculation-method'),
          ),
          _SetupRow(
            label: l10n.locationTitle,
            value: locationSummary(l10n, settings.location),
            isDone: setup.isLocationConfigured,
            isOptional: false,
            isFirst: false,
            rule: rule,
            ink: ink,
            inkMute: inkMute,
            accent: accent,
            onTap: () => context.push('/setup/location'),
          ),
          _SetupRow(
            label: 'Notifications',
            value: 'Optional — configure alert types',
            isDone: false,
            isOptional: true,
            isFirst: false,
            rule: rule,
            ink: ink,
            inkMute: inkMute,
            accent: accent,
            onTap: () => context.push('/setup/notifications'),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: canContinue ? onContinue : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: canContinue ? accent : rule,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: canContinue ? Colors.white : inkMute,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupRow extends StatelessWidget {
  const _SetupRow({
    required this.label,
    required this.value,
    required this.isDone,
    required this.isOptional,
    required this.isFirst,
    required this.rule,
    required this.ink,
    required this.inkMute,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool isDone;
  final bool isOptional;
  final bool isFirst;
  final Color rule;
  final Color ink;
  final Color inkMute;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isFirst
            ? null
            : BoxDecoration(
                border: Border(top: BorderSide(color: rule, width: 1)),
              ),
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? accent
                    : isOptional
                        ? Colors.transparent
                        : Colors.transparent,
                border: Border.all(
                  color: isDone
                      ? accent
                      : isOptional
                          ? inkMute.withValues(alpha: 0.4)
                          : rule,
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : isOptional
                      ? null
                      : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 15,
                          color: ink,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (isOptional) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: inkMute.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Optional',
                            style: TextStyle(
                              fontSize: 10,
                              color: inkMute,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(fontSize: 13, color: inkMute),
                  ),
                ],
              ),
            ),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              size: 16,
              color: inkMute,
            ),
          ],
        ),
      ),
    );
  }
}
