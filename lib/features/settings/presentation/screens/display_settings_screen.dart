import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/settings_grouped_card.dart';
import '../sections/display_settings_section.dart';
import '../settings_cubit.dart';
import '../settings_state.dart';
import '../widgets/settings_detail_scaffold.dart';
import '../../../../l10n/app_localizations.dart';

class DisplaySettingsScreen extends StatelessWidget {
  const DisplaySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SettingsDetailScaffold(
          title: l10n.displaySectionTitle,
          subtitle: l10n.displaySectionSubtitle,
          isLoading: state.isLoading,
          slivers: [
            SettingsGroupedCardSliver(
              child: SettingsGroupedCard(
                children: [DisplaySettingsBody(settings: state.settings)],
              ),
            ),
          ],
        );
      },
    );
  }
}
