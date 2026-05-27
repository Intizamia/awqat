import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awqat/core/widgets/settings_grouped_card.dart';
import 'package:awqat/features/settings/presentation/sections/display_settings_section.dart';
import 'package:awqat/features/settings/presentation/settings_cubit.dart';
import 'package:awqat/features/settings/presentation/settings_state.dart';
import 'package:awqat/features/settings/presentation/widgets/settings_detail_scaffold.dart';
import 'package:awqat/l10n/app_localizations.dart';

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
