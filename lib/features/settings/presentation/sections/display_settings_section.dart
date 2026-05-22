import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/features/settings/domain/time_format_id.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:times/l10n/app_localizations.dart';

class DisplaySettingsSection extends StatelessWidget {
  const DisplaySettingsSection({
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
        SettingsSectionHeader(
          title: l10n.displaySectionTitle,
          subtitle: l10n.displaySectionSubtitle,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(l10n.timeFormatTitle, style: Theme.of(context).textTheme.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton<TimeFormatId>(
            segments: [
              ButtonSegment(value: TimeFormatId.hour24, label: Text(l10n.timeFormat24)),
              ButtonSegment(value: TimeFormatId.hour12, label: Text(l10n.timeFormat12)),
            ],
            selected: {settings.timeFormat},
            onSelectionChanged: (selected) {
              cubit.setTimeFormat(selected.first);
            },
          ),
        ),
        SwitchListTile(
          title: Text(l10n.showSunrise),
          value: settings.showSunrise,
          onChanged: cubit.setShowSunrise,
        ),
        ListTile(
          title: Text(l10n.hijriAdjustmentTitle),
          subtitle: Text(l10n.hijriAdjustmentSubtitle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text('${settings.hijriAdjustmentDays}'),
              Expanded(
                child: Slider(
                  value: settings.hijriAdjustmentDays.toDouble(),
                  min: -2,
                  max: 2,
                  divisions: 4,
                  label: '${settings.hijriAdjustmentDays}',
                  onChanged: (v) => cubit.setHijriAdjustmentDays(v.round()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
