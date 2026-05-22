import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/settings/domain/madhab_id.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/features/settings/presentation/utils/settings_value_labels.dart';
import 'package:times/features/settings/presentation/widgets/settings_check_row.dart';
import 'package:times/features/settings/presentation/widgets/settings_detail_scaffold.dart';
import 'package:times/l10n/app_localizations.dart';

class MadhabScreen extends StatelessWidget {
  const MadhabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return SettingsDetailScaffold(
            title: l10n.madhabTitle,
            subtitle: l10n.madhabSubtitle,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final calculation = state.settings.calculation;
        final cubit = context.read<SettingsCubit>();

        return SettingsDetailScaffold(
          title: l10n.madhabTitle,
          subtitle: l10n.madhabSubtitle,
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              SettingsGroupedCard(
                children: [
                  for (final madhab in MadhabId.values)
                    SettingsCheckRow(
                      title: madhabLabel(l10n, madhab),
                      selected: calculation.madhab == madhab,
                      onTap: () {
                        cubit.updateCalculation(
                          calculation.copyWith(madhab: madhab),
                        );
                        if (context.mounted) Navigator.of(context).pop();
                      },
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
