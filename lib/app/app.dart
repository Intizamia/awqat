import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:times/app/router.dart';
import 'package:times/app/theme.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/l10n/app_localizations.dart';

class TimesApp extends StatelessWidget {
  TimesApp({super.key});

  final _router = createRouter();

  static Locale _localeFromCode(String code) {
    return switch (code) {
      'ur' => const Locale('ur'),
      'ar' => const Locale('ar'),
      _ => const Locale('en'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) => prev.localeCode != curr.localeCode,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Times',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: ThemeMode.system,
            locale: _localeFromCode(state.localeCode),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
