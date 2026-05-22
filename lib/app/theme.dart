import 'package:flutter/material.dart';

/// Brand seed — Material green 800.
const Color kSeedColor = Color(0xFF2E7D32);

ThemeData _baseTheme(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kSeedColor,
      brightness: brightness,
    ),
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

ThemeData buildLightTheme() => _baseTheme(Brightness.light);

ThemeData buildDarkTheme() => _baseTheme(Brightness.dark);
