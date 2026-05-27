import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/cohere_settings_widgets.dart';
import '../settings_cubit.dart';
import '../settings_state.dart';
import '../../../../l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const _locales = [
    ('en', 'English', 'English'),
    ('ar', 'Arabic', 'العربية'),
    ('ur', 'Urdu', 'اردو'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        final current = state.settings.localeCode;

        return CohereDetailScaffold(
          title: l10n.language,
          intro: l10n.languageSubtitle,
          children: [
            CohereSectionLabel(label: 'Choose language'),
            for (var i = 0; i < _locales.length; i++)
              CohereMethodRow(
                title: _locales[i].$2,
                sub: _locales[i].$3,
                isSelected: current == _locales[i].$1,
                isFirst: i == 0,
                onTap: () => cubit.setLocale(_locales[i].$1),
              ),
          ],
        );
      },
    );
  }
}
