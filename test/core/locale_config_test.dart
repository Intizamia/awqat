import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:times/core/l10n/locale_config.dart';

void main() {
  test('Arabic and Urdu use RTL', () {
    expect(textDirectionForLocale(const Locale('ar')), TextDirection.rtl);
    expect(textDirectionForLocale(const Locale('ur')), TextDirection.rtl);
    expect(textDirectionForLocale(const Locale('en')), TextDirection.ltr);
  });
}
