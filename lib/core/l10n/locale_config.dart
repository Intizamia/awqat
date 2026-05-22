import 'package:flutter/material.dart';

/// Locales that use right-to-left layout.
const kRtlLocaleCodes = {'ar', 'ur'};

bool isRtlLocaleCode(String code) => kRtlLocaleCodes.contains(code);

TextDirection textDirectionForLocale(Locale locale) {
  return isRtlLocaleCode(locale.languageCode)
      ? TextDirection.rtl
      : TextDirection.ltr;
}
