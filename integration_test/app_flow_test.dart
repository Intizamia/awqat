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

  testWidgets('configured app shows prayer list', (tester) async {
    SharedPreferences.setMockInitialValues({
      'app_settings_v1': jsonEncode({
        'calculation': const CalculationSettings(
          method: CalculationMethodId.karachi,
        ).toJson(),
        'localeCode': 'en',
        'location': kDefaultUserLocation.toJson(),
      }),
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

    expect(find.text('Prayer Times'), findsWidgets);
    expect(find.text('Fajr'), findsOneWidget);
    expect(find.text('Complete setup'), findsNothing);
  });
}
