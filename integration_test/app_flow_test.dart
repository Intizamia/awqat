import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awqat/app/app.dart';
import 'package:awqat/features/notifications/data/prayer_notification_service.dart';
import 'package:awqat/features/settings/data/settings_repository.dart';
import 'package:awqat/features/settings/domain/calculation_method_id.dart';
import 'package:awqat/features/settings/domain/calculation_settings.dart';
import 'package:awqat/features/settings/domain/user_location.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const settingsKey = 'app_settings_v1';

  tearDown(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(settingsKey);
  });

  test('settings load correctly from shared prefs', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      settingsKey,
      jsonEncode({
        'calculation': const CalculationSettings(
          method: CalculationMethodId.karachi,
        ).toJson(),
        'localeCode': 'en',
        'location': kDefaultUserLocation.toJson(),
        'setupDismissed': true,
      }),
    );
    final repo = await SettingsRepository.create();
    final settings = repo.load();
    expect(
      settings.setup.isComplete,
      isTrue,
      reason:
          'location=${settings.location}, method=${settings.calculation.method}',
    );
  });

  testWidgets('configured app shows prayer list', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      settingsKey,
      jsonEncode({
        'calculation': const CalculationSettings(
          method: CalculationMethodId.karachi,
        ).toJson(),
        'localeCode': 'en',
        'location': kDefaultUserLocation.toJson(),
        'setupDismissed': true,
      }),
    );

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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('PRAYERS'), findsOneWidget);
    expect(find.text('Complete setup'), findsNothing);
    expect(find.text('Fajr'), findsOneWidget);
    expect(find.text('KARACHI'), findsWidgets);
  });
}
