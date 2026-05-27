import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awqat/core/widgets/cohere_settings_widgets.dart';
import 'package:awqat/features/settings/domain/madhab_id.dart';
import 'package:awqat/features/settings/presentation/settings_cubit.dart';
import 'package:awqat/features/settings/presentation/settings_state.dart';
import 'package:awqat/l10n/app_localizations.dart';

class MadhabScreen extends StatelessWidget {
  const MadhabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final calculation = state.settings.calculation;
        final cubit = context.read<SettingsCubit>();

        return CohereDetailScaffold(
          title: l10n.madhabTitle,
          intro: l10n.madhabSubtitle,
          children: [
            CohereSectionLabel(label: 'Choose madhab'),
            CohereMethodRow(
              title: l10n.madhabShafi,
              sub: 'Shadow length = 1× object height.',
              isSelected: calculation.madhab == MadhabId.shafi,
              isFirst: true,
              onTap: () => cubit.updateCalculation(
                calculation.copyWith(madhab: MadhabId.shafi),
              ),
            ),
            CohereMethodRow(
              title: l10n.madhabHanafi,
              sub: 'Shadow length = 2× object height. Later Asr.',
              isSelected: calculation.madhab == MadhabId.hanafi,
              onTap: () => cubit.updateCalculation(
                calculation.copyWith(madhab: MadhabId.hanafi),
              ),
            ),
          ],
        );
      },
    );
  }
}
