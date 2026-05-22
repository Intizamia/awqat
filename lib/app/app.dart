import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:times/app/app_setup_listener.dart';
import 'package:times/app/router.dart';
import 'package:times/app/theme.dart';
import 'package:times/features/location/data/geolocator_location_service.dart';
import 'package:times/features/location/presentation/location_cubit.dart';
import 'package:times/features/prayer/data/adhan_calculation_engine.dart';
import 'package:times/features/prayer/presentation/prayer_times_cubit.dart';
import 'package:times/features/settings/data/settings_repository.dart';
import 'package:times/features/settings/domain/theme_mode_id.dart';
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

  static ThemeMode themeModeFromId(ThemeModeId id) {
    return switch (id) {
      ThemeModeId.light => ThemeMode.light,
      ThemeModeId.dark => ThemeMode.dark,
      ThemeModeId.system => ThemeMode.system,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsCubit(settingsRepository)..load(),
        ),
        BlocProvider(
          create: (context) => LocationCubit(
            locationService: GeolocatorLocationService(),
            settingsCubit: context.read<SettingsCubit>(),
          ),
        ),
        BlocProvider(
          create: (_) => PrayerTimesCubit(AdhanCalculationEngine()),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) =>
            prev.settings.localeCode != curr.settings.localeCode ||
            prev.settings.themeMode != curr.settings.themeMode ||
            prev.isLoading != curr.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            return MaterialApp(
              theme: buildLightTheme(),
              darkTheme: buildDarkTheme(),
              themeMode: ThemeMode.system,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp.router(
            title: 'Times',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: themeModeFromId(state.settings.themeMode),
            locale: localeFromCode(state.settings.localeCode),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _router,
            builder: (context, child) {
              return AppSetupListener(child: child ?? const SizedBox.shrink());
            },
          );
        },
      ),
    );
  }
}
