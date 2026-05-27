import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:awqat/app/app.dart';
import 'package:awqat/features/notifications/data/prayer_notification_service.dart';
import 'package:awqat/features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en');
  await initializeDateFormatting('ar');
  await initializeDateFormatting('ur');
  final settingsRepository = await SettingsRepository.create();
  final notificationService = PrayerNotificationService();
  await notificationService.initialize();
  runApp(
    AwqatApp(
      settingsRepository: settingsRepository,
      notificationService: notificationService,
    ),
  );
}
