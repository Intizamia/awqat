import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/settings/presentation/sections/advanced_calculation_section.dart';
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
        if (state.isLoading) {
          return SettingsDetailScaffold(
            title: l10n.advancedSectionTitle,
            subtitle: l10n.advancedSectionSubtitle,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return SettingsDetailScaffold(
          title: l10n.advancedSectionTitle,
          subtitle: l10n.advancedSectionSubtitle,
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              SettingsGroupedCard(
                children: [
                  AdvancedCalculationBody(
                    calculation: state.settings.calculation,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
