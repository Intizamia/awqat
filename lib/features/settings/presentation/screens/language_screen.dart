import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/features/settings/presentation/utils/settings_value_labels.dart';
import 'package:times/features/settings/presentation/widgets/settings_check_row.dart';
import 'package:times/features/settings/presentation/widgets/settings_detail_scaffold.dart';
import 'package:times/l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const _locales = ['en', 'ur', 'ar'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return SettingsDetailScaffold(
            title: l10n.language,
            subtitle: l10n.languageSubtitle,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final cubit = context.read<SettingsCubit>();

        return SettingsDetailScaffold(
          title: l10n.language,
          subtitle: l10n.languageSubtitle,
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              SettingsGroupedCard(
                children: [
                  for (final code in _locales)
                    SettingsCheckRow(
                      title: languageLabel(code),
                      selected: state.settings.localeCode == code,
                      onTap: () {
                        cubit.setLocale(code);
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
