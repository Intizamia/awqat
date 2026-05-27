import 'package:flutter_test/flutter_test.dart';
import 'package:awqat/core/utils/timezone_resolver.dart';

void main() {
  test('resolves Karachi timezone', () {
    expect(resolveTimeZoneId(24.8607, 67.0011), 'Asia/Karachi');
  });

  test('resolves London timezone', () {
    final tz = resolveTimeZoneId(51.5074, -0.1278);
    expect(tz, 'Europe/London');
  });
}
