import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import '../features/notifications/data/prayer_notification_service.dart';
import '../features/notifications/presentation/notification_onboarding_listener.dart';
import '../features/notifications/presentation/notification_reschedule_listener.dart';
import 'theme.dart';
import '../core/l10n/locale_config.dart';
import '../features/location/data/geolocator_location_service.dart';
import '../features/location/presentation/location_cubit.dart';
import '../features/prayer/data/adhan_calculation_engine.dart';
import '../features/prayer/presentation/prayer_times_cubit.dart';
import '../features/settings/data/settings_repository.dart';
import '../features/settings/domain/theme_mode_id.dart';
import '../features/settings/presentation/settings_cubit.dart';
import '../features/settings/presentation/settings_state.dart';
import '../l10n/app_localizations.dart';

class AwqatApp extends StatelessWidget {
  AwqatApp({
    required this.settingsRepository,
    required this.notificationService,
    super.key,
  });

  final SettingsRepository settingsRepository;
  final PrayerNotificationService notificationService;
  late final _router = createRouter(notificationService: notificationService);

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
        BlocProvider(create: (_) => SettingsCubit(settingsRepository)..load()),
        BlocProvider(
          create: (context) => LocationCubit(
            locationService: GeolocatorLocationService(),
            settingsCubit: context.read<SettingsCubit>(),
          ),
        ),
        BlocProvider(create: (_) => PrayerTimesCubit(AdhanCalculationEngine())),
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

          final locale = localeFromCode(state.settings.localeCode);

          return MaterialApp.router(
            title: 'Times',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: themeModeFromId(state.settings.themeMode),
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localeListResolutionCallback: (locales, supported) {
              for (final preferred in locales ?? const <Locale>[]) {
                for (final candidate in supported) {
                  if (candidate.languageCode == preferred.languageCode) {
                    return candidate;
                  }
                }
              }
              return const Locale('en');
            },
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _router,
            builder: (context, child) {
              final content = child ?? const SizedBox.shrink();
              return NotificationOnboardingListener(
                notificationService: notificationService,
                child: NotificationRescheduleListener(
                  notificationService: notificationService,
                  child: Directionality(
                    textDirection: textDirectionForLocale(locale),
                    child: content,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
