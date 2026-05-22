import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/location/presentation/location_section.dart';
import 'package:times/features/notifications/data/prayer_notification_service.dart';
import 'package:times/features/settings/presentation/sections/notification_settings_section.dart';
import 'package:times/features/settings/presentation/sections/advanced_calculation_section.dart';
import 'package:times/features/settings/presentation/sections/calculation_settings_section.dart';
import 'package:times/features/settings/presentation/sections/display_settings_section.dart';
import 'package:times/features/settings/presentation/sections/settings_reset_section.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/features/settings/presentation/widgets/settings_language_theme_section.dart';
import 'package:times/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.notificationService,
    super.key,
  });

  final PrayerNotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings;

          return ListView(
            children: [
              CalculationSettingsSection(calculation: settings.calculation),
              const Divider(height: 1),
              AdvancedCalculationSection(calculation: settings.calculation),
              const Divider(height: 1),
              LocationSection(currentLocation: settings.location),
              const Divider(height: 1),
              NotificationSettingsSection(
                settings: settings,
                notificationService: notificationService,
              ),
              const Divider(height: 1),
              DisplaySettingsSection(settings: settings),
              const Divider(height: 1),
              SettingsLanguageThemeSection(settings: settings),
              const Divider(height: 1),
              const SettingsResetSection(),
            ],
          );
        },
      ),
    );
  }
}
