import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.chooseCalculationMethod),
            subtitle: const Text('Phase 1 — method picker'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.read<SettingsCubit>().markCalculationConfigured();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.chooseCalculationMethod)),
              );
            },
          ),
          ListTile(
            title: const Text('Location'),
            subtitle: const Text('Phase 3 — GPS / city'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.read<SettingsCubit>().markLocationConfigured();
            },
          ),
          const Divider(),
          _LanguageSection(l10n: l10n),
        ],
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    final current = cubit.state.localeCode;

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
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'en', label: Text('EN')),
            ButtonSegment(value: 'ur', label: Text('UR')),
            ButtonSegment(value: 'ar', label: Text('AR')),
          ],
          selected: {current},
          onSelectionChanged: (Set<String> selected) {
            cubit.setLocale(selected.first);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
