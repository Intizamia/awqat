import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:times/app/main_shell.dart';
import 'package:times/features/coming_soon/presentation/coming_soon_screen.dart';
import 'package:times/features/prayer/presentation/prayer_times_screen.dart';
import 'package:times/features/qibla/presentation/qibla_screen.dart';
import 'package:times/features/settings/presentation/settings_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
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
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
