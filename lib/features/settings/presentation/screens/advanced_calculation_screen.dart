import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/cohere_settings_widgets.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/l10n/app_localizations.dart';

class AdvancedCalculationScreen extends StatelessWidget {
  const AdvancedCalculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final calc = state.settings.calculation;
        final cubit = context.read<SettingsCubit>();

        void update(CalculationSettings updated) =>
            cubit.updateCalculation(updated);

        return CohereDetailScaffold(
          title: l10n.advancedSectionTitle,
          intro: l10n.advancedSectionSubtitle,
          children: [
            // Global offset
            CohereSectionLabel(label: 'Global'),
            CohereStepperRow(
              label: l10n.globalOffsetMinutes,
              value: calc.globalOffsetMinutes,
              min: -30,
              max: 30,
              unit: 'min',
              isFirst: true,
              onChanged: (v) =>
                  update(calc.copyWith(globalOffsetMinutes: v)),
            ),

            // Custom method angles
            if (calc.isCustomMethod) ...[
              CohereSectionLabel(label: 'Custom angles'),
              CohereStepperRow(
                label: l10n.fajrAngle,
                value: (calc.fajrAngle ?? 18).round(),
                min: 10,
                max: 22,
                unit: '°',
                isFirst: true,
                onChanged: (v) =>
                    update(calc.copyWith(fajrAngle: v.toDouble())),
              ),
              CohereStepperRow(
                label: l10n.ishaAngle,
                value: (calc.ishaAngle ?? 17).round(),
                min: 10,
                max: 22,
                unit: '°',
                onChanged: (v) =>
                    update(calc.copyWith(ishaAngle: v.toDouble())),
              ),
              CohereStepperRow(
                label: l10n.ishaIntervalMinutes,
                value: calc.ishaIntervalMinutes ?? 0,
                min: 0,
                max: 120,
                unit: 'min',
                onChanged: (v) =>
                    update(calc.copyWith(ishaIntervalMinutes: v)),
              ),
            ],

            // Umm Al-Qura Ramadan boost
            if (calc.method == CalculationMethodId.ummAlQura) ...[
              CohereSectionLabel(label: 'Ramadan'),
              CohereToggleRow(
                label: l10n.ramadanIshaBoost,
                sub: l10n.ramadanIshaBoostSubtitle,
                value: calc.ramadanIshaBoost,
                isFirst: true,
                onChanged: (v) =>
                    update(calc.copyWith(ramadanIshaBoost: v)),
              ),
            ],

            // Per-prayer offsets
            CohereSectionLabel(label: l10n.perPrayerOffsets),
            CohereStepperRow(
              label: l10n.prayerFajr,
              value: calc.prayerOffsets.fajr,
              isFirst: true,
              onChanged: (v) => update(calc.copyWith(
                  prayerOffsets: calc.prayerOffsets.copyWith(fajr: v))),
            ),
            CohereStepperRow(
              label: l10n.prayerSunrise,
              value: calc.prayerOffsets.sunrise,
              onChanged: (v) => update(calc.copyWith(
                  prayerOffsets: calc.prayerOffsets.copyWith(sunrise: v))),
            ),
            CohereStepperRow(
              label: l10n.prayerDhuhr,
              value: calc.prayerOffsets.dhuhr,
              onChanged: (v) => update(calc.copyWith(
                  prayerOffsets: calc.prayerOffsets.copyWith(dhuhr: v))),
            ),
            CohereStepperRow(
              label: l10n.prayerAsr,
              value: calc.prayerOffsets.asr,
              onChanged: (v) => update(calc.copyWith(
                  prayerOffsets: calc.prayerOffsets.copyWith(asr: v))),
            ),
            CohereStepperRow(
              label: l10n.prayerMaghrib,
              value: calc.prayerOffsets.maghrib,
              onChanged: (v) => update(calc.copyWith(
                  prayerOffsets: calc.prayerOffsets.copyWith(maghrib: v))),
            ),
            CohereStepperRow(
              label: l10n.prayerIsha,
              value: calc.prayerOffsets.isha,
              onChanged: (v) => update(calc.copyWith(
                  prayerOffsets: calc.prayerOffsets.copyWith(isha: v))),
            ),
          ],
        );
      },
    );
  }
}
