import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:times/app/router.dart';
import 'package:times/app/theme.dart';
import 'package:times/features/settings/data/settings_repository.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/l10n/app_localizations.dart';

class TimesApp extends StatelessWidget {
  TimesApp({required this.settingsRepository, super.key});

  final SettingsRepository settingsRepository;
  final _router = createRouter();

  static Locale localeFromCode(String code) {
    return switch (code) {
      'ur' => const Locale('ur'),
      'ar' => const Locale('ar'),
      _ => const Locale('en'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(settingsRepository)..load(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) =>
            prev.settings.localeCode != curr.settings.localeCode ||
            prev.isLoading != curr.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            return MaterialApp(
              theme: buildLightTheme(),
              darkTheme: buildDarkTheme(),
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp.router(
            title: 'Times',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: ThemeMode.system,
            locale: localeFromCode(state.settings.localeCode),
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
