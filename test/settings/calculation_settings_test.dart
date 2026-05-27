import 'package:flutter_test/flutter_test.dart';
import 'package:awqat/features/settings/domain/calculation_method_id.dart';
import 'package:awqat/features/settings/domain/calculation_settings.dart';

void main() {
  test('CalculationSettings round-trip JSON', () {
    const original = CalculationSettings(
      method: CalculationMethodId.karachi,
      globalOffsetMinutes: 2,
    );

    final restored = CalculationSettings.fromJson(original.toJson());

    expect(restored.method, CalculationMethodId.karachi);
    expect(restored.globalOffsetMinutes, 2);
    expect(restored.isConfigured, isTrue);
  });

  test('isConfigured is false when method is null', () {
    const settings = CalculationSettings();
    expect(settings.isConfigured, isFalse);
  });
}
