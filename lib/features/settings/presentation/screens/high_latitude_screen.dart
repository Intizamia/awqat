import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/settings/domain/high_latitude_rule_id.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/features/settings/presentation/utils/settings_value_labels.dart';
import 'package:times/features/settings/presentation/widgets/settings_check_row.dart';
import 'package:times/features/settings/presentation/widgets/settings_detail_scaffold.dart';
import 'package:times/l10n/app_localizations.dart';

class HighLatitudeScreen extends StatelessWidget {
  const HighLatitudeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final calculation = state.settings.calculation;
        final cubit = context.read<SettingsCubit>();

        return SettingsDetailScaffold(
          title: l10n.highLatitudeTitle,
          subtitle: l10n.highLatitudeSubtitle,
          isLoading: state.isLoading,
          slivers: [
            SettingsGroupedCardSliver(
              child: SettingsGroupedCard(
                children: [
                  for (final rule in HighLatitudeRuleId.values)
                    SettingsCheckRow(
                      title: highLatitudeLabel(l10n, rule),
                      selected: calculation.highLatitudeRule == rule,
                      onTap: () => cubit.updateCalculation(
                        calculation.copyWith(highLatitudeRule: rule),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
