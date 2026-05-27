import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/schedule_groove_divider.dart';
import '../../domain/app_settings.dart';
import '../../domain/time_format_id.dart';
import '../settings_cubit.dart';
import '../utils/settings_value_labels.dart';
import '../widgets/settings_check_row.dart';
import '../widgets/settings_switch_row.dart';
import '../../../../l10n/app_localizations.dart';

class DisplaySettingsBody extends StatelessWidget {
  const DisplaySettingsBody({required this.settings, super.key});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final format in TimeFormatId.values) ...[
          if (format != TimeFormatId.values.first)
            const ScheduleGrooveDivider(),
          SettingsCheckRow(
            title: timeFormatLabel(l10n, format),
            selected: settings.timeFormat == format,
            onTap: () => cubit.setTimeFormat(format),
          ),
        ],
        const ScheduleGrooveDivider(),
        SettingsSwitchRow(
          title: l10n.showSunrise,
          value: settings.showSunrise,
          onChanged: cubit.setShowSunrise,
        ),
        const ScheduleGrooveDivider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            l10n.hijriAdjustmentTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            l10n.hijriAdjustmentSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Text(
                '${settings.hijriAdjustmentDays}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
      ],
    );
  }
}
