import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/cohere_settings_widgets.dart';
import '../../domain/high_latitude_rule_id.dart';
import '../settings_cubit.dart';
import '../settings_state.dart';
import '../../../../l10n/app_localizations.dart';

class HighLatitudeScreen extends StatelessWidget {
  const HighLatitudeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final calculation = state.settings.calculation;
        final cubit = context.read<SettingsCubit>();

        return CohereDetailScaffold(
          title: l10n.highLatitudeTitle,
          intro:
              'Used at latitudes where the sun does not set far enough '
              'below the horizon to produce a true Fajr or Isha time.',
          children: [
            CohereSectionLabel(label: 'Choose rule'),
            CohereMethodRow(
              title: l10n.highLatitudeMiddle,
              sub: 'Fajr at midnight midpoint; Isha symmetrically.',
              isSelected:
                  calculation.highLatitudeRule ==
                  HighLatitudeRuleId.middleOfTheNight,
              isFirst: true,
              onTap: () => cubit.updateCalculation(
                calculation.copyWith(
                  highLatitudeRule: HighLatitudeRuleId.middleOfTheNight,
                ),
              ),
            ),
            CohereMethodRow(
              title: l10n.highLatitudeSeventh,
              sub: 'Fajr begins at one-seventh of night before sunrise.',
              isSelected:
                  calculation.highLatitudeRule ==
                  HighLatitudeRuleId.seventhOfTheNight,
              onTap: () => cubit.updateCalculation(
                calculation.copyWith(
                  highLatitudeRule: HighLatitudeRuleId.seventhOfTheNight,
                ),
              ),
            ),
            CohereMethodRow(
              title: l10n.highLatitudeAngle,
              sub: 'Calculate based on sun angle below horizon.',
              isSelected:
                  calculation.highLatitudeRule ==
                  HighLatitudeRuleId.twilightAngle,
              onTap: () => cubit.updateCalculation(
                calculation.copyWith(
                  highLatitudeRule: HighLatitudeRuleId.twilightAngle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
