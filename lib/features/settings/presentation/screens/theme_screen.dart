import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/settings_grouped_card.dart';
import '../../domain/theme_mode_id.dart';
import '../settings_cubit.dart';
import '../settings_state.dart';
import '../utils/settings_value_labels.dart';
import '../widgets/settings_check_row.dart';
import '../widgets/settings_detail_scaffold.dart';
import '../../../../l10n/app_localizations.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return SettingsDetailScaffold(
          title: l10n.themeMode,
          subtitle: l10n.themeSubtitle,
          isLoading: state.isLoading,
          slivers: [
            SettingsGroupedCardSliver(
              child: SettingsGroupedCard(
                children: [
                  for (final mode in ThemeModeId.values)
                    SettingsCheckRow(
                      title: themeModeLabel(l10n, mode),
                      selected: state.settings.themeMode == mode,
                      onTap: () => cubit.setThemeMode(mode),
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
