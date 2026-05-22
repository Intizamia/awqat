import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:times/app/main_shell.dart';
import 'package:times/features/coming_soon/presentation/coming_soon_screen.dart';
import 'package:times/features/prayer/presentation/prayer_times_screen.dart';
import 'package:times/features/qibla/presentation/qibla_screen.dart';
import 'package:times/features/notifications/data/prayer_notification_service.dart';
import 'package:times/features/settings/presentation/screens/advanced_calculation_screen.dart';
import 'package:times/features/settings/presentation/screens/calculation_method_screen.dart';
import 'package:times/features/settings/presentation/screens/display_settings_screen.dart';
import 'package:times/features/settings/presentation/screens/high_latitude_screen.dart';
import 'package:times/features/settings/presentation/screens/language_screen.dart';
import 'package:times/features/settings/presentation/screens/location_settings_screen.dart';
import 'package:times/features/settings/presentation/screens/madhab_screen.dart';
import 'package:times/features/settings/presentation/screens/notifications_settings_screen.dart';
import 'package:times/features/settings/presentation/screens/reset_settings_screen.dart';
import 'package:times/features/settings/presentation/screens/theme_screen.dart';
import 'package:times/features/settings/presentation/settings_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter({
  required PrayerNotificationService notificationService,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/prayer',
    routes: [
      GoRoute(
        path: '/qibla',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const QiblaScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/prayer',
                builder: (context, state) => const PrayerTimesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/coming-soon',
                builder: (context, state) => const ComingSoonScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => SettingsScreen(
                  notificationService: notificationService,
                ),
                routes: [
                  GoRoute(
                    path: 'calculation-method',
                    builder: (context, state) =>
                        const CalculationMethodScreen(),
                  ),
                  GoRoute(
                    path: 'madhab',
                    builder: (context, state) => const MadhabScreen(),
                  ),
                  GoRoute(
                    path: 'high-latitude',
                    builder: (context, state) => const HighLatitudeScreen(),
                  ),
                  GoRoute(
                    path: 'advanced',
                    builder: (context, state) =>
                        const AdvancedCalculationScreen(),
                  ),
                  GoRoute(
                    path: 'location',
                    builder: (context, state) => const LocationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) => NotificationsSettingsScreen(
                      notificationService: notificationService,
                    ),
                  ),
                  GoRoute(
                    path: 'display',
                    builder: (context, state) => const DisplaySettingsScreen(),
                  ),
                  GoRoute(
                    path: 'language',
                    builder: (context, state) => const LanguageScreen(),
                  ),
                  GoRoute(
                    path: 'theme',
                    builder: (context, state) => const ThemeScreen(),
                  ),
                  GoRoute(
                    path: 'reset',
                    builder: (context, state) => const ResetSettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
