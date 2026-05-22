import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/schedule_groove_divider.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:times/l10n/app_localizations.dart';

class AdvancedCalculationSection extends StatelessWidget {
  const AdvancedCalculationSection({
    required this.calculation,
    super.key,
    this.embedded = false,
  });

  final CalculationSettings calculation;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    if (embedded) {
      return AdvancedCalculationBody(calculation: calculation);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: AppLocalizations.of(context)!.advancedSectionTitle,
          subtitle: AppLocalizations.of(context)!.advancedSectionSubtitle,
        ),
        AdvancedCalculationBody(calculation: calculation),
        const SizedBox(height: 8),
      ],
    );
  }
}

class AdvancedCalculationBody extends StatelessWidget {
  const AdvancedCalculationBody({
    required this.calculation,
    super.key,
  });

  final CalculationSettings calculation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    final rows = <Widget>[];

    if (calculation.isCustomMethod) {
      rows.addAll([
        _AngleField(
          label: l10n.fajrAngle,
          value: calculation.fajrAngle ?? 18,
          onChanged: (v) => cubit.updateCalculation(
            calculation.copyWith(fajrAngle: v),
          ),
        ),
        const ScheduleGrooveDivider(),
        _AngleField(
          label: l10n.ishaAngle,
          value: calculation.ishaAngle ?? 17,
          onChanged: (v) => cubit.updateCalculation(
            calculation.copyWith(ishaAngle: v),
          ),
        ),
        const ScheduleGrooveDivider(),
        _IntervalField(
          label: l10n.ishaIntervalMinutes,
          value: calculation.ishaIntervalMinutes ?? 0,
          onChanged: (v) => cubit.updateCalculation(
            calculation.copyWith(ishaIntervalMinutes: v),
          ),
        ),
        const ScheduleGrooveDivider(),
      ]);
    }

    rows.add(
      _OffsetField(
        label: l10n.globalOffsetMinutes,
        value: calculation.globalOffsetMinutes,
        min: -30,
        max: 30,
        divisions: 12,
        onChanged: (v) => cubit.updateCalculation(
          calculation.copyWith(globalOffsetMinutes: v),
        ),
      ),
    );

    if (calculation.method == CalculationMethodId.ummAlQura) {
      rows.addAll([
        const ScheduleGrooveDivider(),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(l10n.ramadanIshaBoost),
          subtitle: Text(l10n.ramadanIshaBoostSubtitle),
          value: calculation.ramadanIshaBoost,
          onChanged: (v) => cubit.updateCalculation(
            calculation.copyWith(ramadanIshaBoost: v),
          ),
        ),
      ]);
    }

    rows.addAll([
      const ScheduleGrooveDivider(),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(
          l10n.perPrayerOffsets,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      _OffsetTile(
        label: l10n.prayerFajr,
        value: calculation.prayerOffsets.fajr,
        onChanged: (v) => _updateOffsets(cubit, calculation, fajr: v),
      ),
      const ScheduleGrooveDivider(),
      _OffsetTile(
        label: l10n.prayerSunrise,
        value: calculation.prayerOffsets.sunrise,
        onChanged: (v) => _updateOffsets(cubit, calculation, sunrise: v),
      ),
      const ScheduleGrooveDivider(),
      _OffsetTile(
        label: l10n.prayerDhuhr,
        value: calculation.prayerOffsets.dhuhr,
        onChanged: (v) => _updateOffsets(cubit, calculation, dhuhr: v),
      ),
      const ScheduleGrooveDivider(),
      _OffsetTile(
        label: l10n.prayerAsr,
        value: calculation.prayerOffsets.asr,
        onChanged: (v) => _updateOffsets(cubit, calculation, asr: v),
      ),
      const ScheduleGrooveDivider(),
      _OffsetTile(
        label: l10n.prayerMaghrib,
        value: calculation.prayerOffsets.maghrib,
        onChanged: (v) => _updateOffsets(cubit, calculation, maghrib: v),
      ),
      const ScheduleGrooveDivider(),
      _OffsetTile(
        label: l10n.prayerIsha,
        value: calculation.prayerOffsets.isha,
        onChanged: (v) => _updateOffsets(cubit, calculation, isha: v),
      ),
    ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  void _updateOffsets(
    SettingsCubit cubit,
    CalculationSettings calculation, {
    int? fajr,
    int? sunrise,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
  }) {
    cubit.updateCalculation(
      calculation.copyWith(
        prayerOffsets: calculation.prayerOffsets.copyWith(
          fajr: fajr,
          sunrise: sunrise,
          dhuhr: dhuhr,
          asr: asr,
          maghrib: maghrib,
          isha: isha,
        ),
      ),
    );
  }
}

class _AngleField extends StatelessWidget {
  const _AngleField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          Slider(
            value: value,
            min: 10,
            max: 22,
            divisions: 24,
            label: '${value.toStringAsFixed(1)}°',
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _IntervalField extends StatelessWidget {
  const _IntervalField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          Slider(
            value: value.toDouble(),
            min: 0,
            max: 120,
            divisions: 24,
            label: '$value min',
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}

class _OffsetField extends StatelessWidget {
  const _OffsetField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final int divisions;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: divisions,
            label: '$value min',
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}

class _OffsetTile extends StatelessWidget {
  const _OffsetTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SizedBox(
            width: 140,
            child: Slider(
              value: value.toDouble(),
              min: -15,
              max: 15,
              divisions: 6,
              label: '$value',
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
        ],
      ),
    );
  }
}
