import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final calc = state.settings.calculation;
          final cubit = context.read<SettingsCubit>();

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  l10n.chooseCalculationMethod,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ..._methods.map((entry) {
                final (id, label) = entry;
                final selected = calc.method == id;
                return ListTile(
                  title: Text(label),
                  trailing: selected
                      ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () => cubit.setCalculationMethod(id),
                );
              }),
              const Divider(),
              SwitchListTile(
                title: const Text('Location configured'),
                subtitle: const Text('Phase 3 — replace with GPS / city picker'),
                value: state.settings.isLocationConfigured,
                onChanged: (v) => cubit.setLocationConfigured(v),
              ),
              const Divider(),
              _LanguageSection(
                localeCode: state.settings.localeCode,
                onChanged: cubit.setLocale,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection({
    required this.localeCode,
    required this.onChanged,
  });

  final String localeCode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Language',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'en', label: Text('EN')),
              ButtonSegment(value: 'ur', label: Text('UR')),
              ButtonSegment(value: 'ar', label: Text('AR')),
            ],
            selected: {localeCode},
            onSelectionChanged: (Set<String> selected) {
              onChanged(selected.first);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
