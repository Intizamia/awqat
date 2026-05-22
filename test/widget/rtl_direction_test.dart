import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:times/app/app.dart';
import 'package:times/features/notifications/data/prayer_notification_service.dart';
import 'package:times/features/settings/data/settings_repository.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/user_location.dart';

void main() {
  testWidgets('Arabic locale applies RTL directionality', (tester) async {
    SharedPreferences.setMockInitialValues({
      'app_settings_v1': jsonEncode({
        'calculation': const CalculationSettings(
          method: CalculationMethodId.karachi,
        ).toJson(),
        'localeCode': 'ar',
        'location': kDefaultUserLocation.toJson(),
      }),
    });

    final repo = await SettingsRepository.create();
    await tester.pumpWidget(
      TimesApp(
        settingsRepository: repo,
        notificationService: PrayerNotificationService(skipPlatformCalls: true),
      ),
    );
    await tester.pumpAndSettle();

    final titleContext = tester.element(find.text('مواقيت الصلاة').first);
    final direction = titleContext
        .findAncestorWidgetOfExactType<Directionality>()!
        .textDirection;
    expect(direction, TextDirection.rtl);
  });
}
