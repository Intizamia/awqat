import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/location/presentation/location_section.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/theme_mode_id.dart';
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
              LocationSection(
                currentLocation: state.settings.location,
              ),
              const Divider(),
              _LanguageSection(
                l10n: l10n,
                localeCode: state.settings.localeCode,
                onChanged: cubit.setLocale,
              ),
              const Divider(),
              _ThemeModeSection(
                l10n: l10n,
                themeMode: state.settings.themeMode,
                onChanged: cubit.setThemeMode,
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
    required this.l10n,
    required this.localeCode,
    required this.onChanged,
  });

  final AppLocalizations l10n;
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
            l10n.language,
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

class _ThemeModeSection extends StatelessWidget {
  const _ThemeModeSection({
    required this.l10n,
    required this.themeMode,
    required this.onChanged,
  });

  final AppLocalizations l10n;
  final ThemeModeId themeMode;
  final ValueChanged<ThemeModeId> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.themeMode,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: SegmentedButton<ThemeModeId>(
            segments: [
              ButtonSegment(
                value: ThemeModeId.system,
                label: Text(l10n.themeSystem),
                icon: const Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeModeId.light,
                label: Text(l10n.themeLight),
                icon: const Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: ThemeModeId.dark,
                label: Text(l10n.themeDark),
                icon: const Icon(Icons.dark_mode),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (Set<ThemeModeId> selected) {
              onChanged(selected.first);
            },
          ),
        ),
      ],
    );
  }
}
