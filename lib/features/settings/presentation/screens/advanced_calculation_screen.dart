import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/settings/presentation/sections/advanced_calculation_section.dart'
    show AdvancedCalculationGeneralBody, AdvancedCalculationPrayerOffsetsBody;
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/features/settings/presentation/widgets/settings_detail_scaffold.dart';
import 'package:times/l10n/app_localizations.dart';

class AdvancedCalculationScreen extends StatelessWidget {
  const AdvancedCalculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SettingsDetailScaffold(
          title: l10n.advancedSectionTitle,
          subtitle: l10n.advancedSectionSubtitle,
          isLoading: state.isLoading,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AdvancedCalculationGeneralBody(
                  calculation: state.settings.calculation,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  l10n.perPrayerOffsets,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SettingsGroupedCardSliver(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SettingsGroupedCard(
                children: [
                  AdvancedCalculationPrayerOffsetsBody(
                    calculation: state.settings.calculation,
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
