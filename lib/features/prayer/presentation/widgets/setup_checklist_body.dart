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
  const SetupChecklistBody({required this.settings, super.key});

  final AppSettings settings;

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

    return Scaffold(
      backgroundColor: surfPage,
      body: ListView(
        children: [
          SizedBox(height: statusBarHeight),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
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
          CohereSectionLabel(label: l10n.setupChecklistGroupLabel),
          _SetupRow(
            label: l10n.calculationMethodTitle,
            value: setup.isCalculationConfigured
                ? calculationMethodLabel(calc.method)
                : l10n.chooseCalculationMethod,
            isDone: setup.isCalculationConfigured,
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
            isFirst: false,
            rule: rule,
            ink: ink,
            inkMute: inkMute,
            accent: accent,
            onTap: () => context.push('/setup/location'),
          ),
          const SizedBox(height: 100),
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
                color: isDone ? accent : Colors.transparent,
                border: Border.all(color: isDone ? accent : rule, width: 1.5),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      color: ink,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 13, color: inkMute)),
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
