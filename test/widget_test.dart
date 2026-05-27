import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awqat/app/app.dart';
import 'package:awqat/features/notifications/data/prayer_notification_service.dart';
import 'package:awqat/features/settings/data/settings_repository.dart';

void main() {
  testWidgets('TimesApp shows setup checklist when not configured', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'app_settings_v1': jsonEncode({'localeCode': 'en'}),
    });
    final repo = await SettingsRepository.create();
    final notificationService = PrayerNotificationService(
      skipPlatformCalls: true,
    );
    await tester.pumpWidget(
      AwqatApp(
        settingsRepository: repo,
        notificationService: notificationService,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Complete setup'), findsOneWidget);
    expect(find.text('Calculation method'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Choose calculation method'), findsOneWidget);
    expect(find.text('No location selected'), findsOneWidget);
  });
}
