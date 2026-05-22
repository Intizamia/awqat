import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/high_latitude_rule_id.dart';
import 'package:times/features/settings/domain/madhab_id.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:times/l10n/app_localizations.dart';

class CalculationSettingsSection extends StatelessWidget {
  const CalculationSettingsSection({
    required this.calculation,
    super.key,
  });

  final CalculationSettings calculation;

  static const _methods = <(CalculationMethodId, String)>[
    (CalculationMethodId.muslimWorldLeague, 'Muslim World League'),
    (CalculationMethodId.karachi, 'University of Islamic Sciences, Karachi'),
    (CalculationMethodId.northAmerica, 'ISNA (North America)'),
    (CalculationMethodId.ummAlQura, 'Umm Al-Qura, Makkah'),
    (CalculationMethodId.egyptian, 'Egyptian General Authority'),
    (CalculationMethodId.dubai, 'Dubai'),
    (CalculationMethodId.qatar, 'Qatar'),
    (CalculationMethodId.kuwait, 'Kuwait'),
    (CalculationMethodId.singapore, 'Singapore (MUIS)'),
    (CalculationMethodId.tehran, 'Tehran'),
    (CalculationMethodId.turkey, 'Turkey (Diyanet)'),
    (CalculationMethodId.moonsightingCommittee, 'Moonsighting Committee'),
    (CalculationMethodId.other, 'Custom'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: l10n.calculationSectionTitle,
          subtitle: l10n.calculationSectionSubtitle,
        ),
        ..._methods.map((entry) {
          final (id, label) = entry;
          final selected = calculation.method == id;
          return ListTile(
            title: Text(label),
            trailing: selected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () => cubit.setCalculationMethod(id),
          );
        }),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(l10n.madhabTitle, style: Theme.of(context).textTheme.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton<MadhabId>(
            segments: [
              ButtonSegment(value: MadhabId.shafi, label: Text(l10n.madhabShafi)),
              ButtonSegment(value: MadhabId.hanafi, label: Text(l10n.madhabHanafi)),
            ],
            selected: {calculation.madhab},
            onSelectionChanged: (selected) {
              cubit.updateCalculation(
                calculation.copyWith(madhab: selected.first),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            l10n.highLatitudeTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...HighLatitudeRuleId.values.map((rule) {
          final selected = calculation.highLatitudeRule == rule;
          return ListTile(
            title: Text(_highLatitudeLabel(l10n, rule)),
            trailing: selected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () => cubit.updateCalculation(
              calculation.copyWith(highLatitudeRule: rule),
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  String _highLatitudeLabel(AppLocalizations l10n, HighLatitudeRuleId rule) {
    return switch (rule) {
      HighLatitudeRuleId.middleOfTheNight => l10n.highLatitudeMiddle,
      HighLatitudeRuleId.seventhOfTheNight => l10n.highLatitudeSeventh,
      HighLatitudeRuleId.twilightAngle => l10n.highLatitudeAngle,
    };
  }
}
