import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/features/settings/domain/theme_mode_id.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:times/l10n/app_localizations.dart';

class SettingsLanguageThemeSection extends StatelessWidget {
  const SettingsLanguageThemeSection({
    required this.settings,
    super.key,
  });

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.appearanceSectionTitle),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(l10n.language, style: Theme.of(context).textTheme.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'en', label: Text('EN')),
              ButtonSegment(value: 'ur', label: Text('UR')),
              ButtonSegment(value: 'ar', label: Text('AR')),
            ],
            selected: {settings.localeCode},
            onSelectionChanged: (selected) => cubit.setLocale(selected.first),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(l10n.themeMode, style: Theme.of(context).textTheme.titleSmall),
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
            selected: {settings.themeMode},
            onSelectionChanged: (selected) => cubit.setThemeMode(selected.first),
          ),
        ),
      ],
    );
  }
}
