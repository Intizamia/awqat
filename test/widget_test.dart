import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:times/app/app.dart';
import 'package:times/features/settings/data/settings_repository.dart';

void main() {
  testWidgets('TimesApp shows prayer times nav label', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repo = await SettingsRepository.create();
    await tester.pumpWidget(TimesApp(settingsRepository: repo));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Complete setup'), findsOneWidget);
  });
}
