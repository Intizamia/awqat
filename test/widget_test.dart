import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:times/app/app.dart';

void main() {
  testWidgets('TimesApp shows prayer times nav label', (tester) async {
    await tester.pumpWidget(TimesApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Complete setup'), findsOneWidget);
  });
}
