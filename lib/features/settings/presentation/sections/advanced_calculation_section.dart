import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:times/l10n/app_localizations.dart';

class AdvancedCalculationSection extends StatelessWidget {
  const AdvancedCalculationSection({
    required this.calculation,
    super.key,
  });

  final CalculationSettings calculation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: l10n.advancedSectionTitle,
          subtitle: l10n.advancedSectionSubtitle,
        ),
        if (calculation.isCustomMethod) ...[
          _AngleField(
            label: l10n.fajrAngle,
            value: calculation.fajrAngle ?? 18,
            onChanged: (v) => cubit.updateCalculation(
              calculation.copyWith(fajrAngle: v),
            ),
          ),
          _AngleField(
            label: l10n.ishaAngle,
            value: calculation.ishaAngle ?? 17,
            onChanged: (v) => cubit.updateCalculation(
              calculation.copyWith(ishaAngle: v),
            ),
          ),
          ListTile(
            title: Text(l10n.ishaIntervalMinutes),
            subtitle: Slider(
              value: (calculation.ishaIntervalMinutes ?? 0).toDouble(),
              min: 0,
              max: 120,
              divisions: 24,
              label: '${calculation.ishaIntervalMinutes ?? 0} min',
              onChanged: (v) => cubit.updateCalculation(
                calculation.copyWith(ishaIntervalMinutes: v.round()),
              ),
            ),
          ),
        ],
        ListTile(
          title: Text(l10n.globalOffsetMinutes),
          subtitle: Slider(
            value: calculation.globalOffsetMinutes.toDouble(),
            min: -30,
            max: 30,
            divisions: 12,
            label: '${calculation.globalOffsetMinutes} min',
            onChanged: (v) => cubit.updateCalculation(
              calculation.copyWith(globalOffsetMinutes: v.round()),
            ),
          ),
        ),
        if (calculation.method == CalculationMethodId.ummAlQura)
          SwitchListTile(
            title: Text(l10n.ramadanIshaBoost),
            subtitle: Text(l10n.ramadanIshaBoostSubtitle),
            value: calculation.ramadanIshaBoost,
            onChanged: (v) => cubit.updateCalculation(
              calculation.copyWith(ramadanIshaBoost: v),
            ),
          ),
        ExpansionTile(
          title: Text(l10n.perPrayerOffsets),
          children: [
            _OffsetTile(
              label: l10n.prayerFajr,
              value: calculation.prayerOffsets.fajr,
              onChanged: (v) => _updateOffsets(cubit, calculation, fajr: v),
            ),
            _OffsetTile(
              label: l10n.prayerSunrise,
              value: calculation.prayerOffsets.sunrise,
              onChanged: (v) => _updateOffsets(cubit, calculation, sunrise: v),
            ),
            _OffsetTile(
              label: l10n.prayerDhuhr,
              value: calculation.prayerOffsets.dhuhr,
              onChanged: (v) => _updateOffsets(cubit, calculation, dhuhr: v),
            ),
            _OffsetTile(
              label: l10n.prayerAsr,
              value: calculation.prayerOffsets.asr,
              onChanged: (v) => _updateOffsets(cubit, calculation, asr: v),
            ),
            _OffsetTile(
              label: l10n.prayerMaghrib,
              value: calculation.prayerOffsets.maghrib,
              onChanged: (v) => _updateOffsets(cubit, calculation, maghrib: v),
            ),
            _OffsetTile(
              label: l10n.prayerIsha,
              value: calculation.prayerOffsets.isha,
              onChanged: (v) => _updateOffsets(cubit, calculation, isha: v),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
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
    return ListTile(
      title: Text(label),
      subtitle: Slider(
        value: value,
        min: 10,
        max: 22,
        divisions: 24,
        label: '${value.toStringAsFixed(1)}°',
        onChanged: onChanged,
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
    return ListTile(
      title: Text(label),
      trailing: SizedBox(
        width: 120,
        child: Slider(
          value: value.toDouble(),
          min: -15,
          max: 15,
          divisions: 6,
          label: '$value',
          onChanged: (v) => onChanged(v.round()),
        ),
      ),
    );
  }
}
