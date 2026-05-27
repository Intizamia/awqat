import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/cohere_colors.dart';

ThemeData buildLightTheme() => _buildTheme(Brightness.light);
ThemeData buildDarkTheme() => _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final accent = isDark ? CohereColors.accentDark : CohereColors.accent;
  final accentSoft = isDark
      ? CohereColors.accentSoftDark
      : CohereColors.accentSoft;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: accent,
    onPrimary: isDark ? Colors.black : Colors.white,
    primaryContainer: accentSoft,
    onPrimaryContainer: accent,
    secondary: isDark ? CohereColors.inkDimDark : CohereColors.slate,
    onSecondary: isDark ? Colors.black : Colors.white,
    error: isDark ? const Color(0xFFFF6B6B) : const Color(0xFFB30000),
    onError: isDark ? Colors.black : Colors.white,
    surface: isDark ? CohereColors.darkPage : CohereColors.canvas,
    onSurface: isDark ? CohereColors.inkDark : CohereColors.ink,
    onSurfaceVariant: isDark ? CohereColors.inkDimDark : CohereColors.slate,
    outline: isDark ? CohereColors.darkRule : CohereColors.hairline,
    outlineVariant: isDark
        ? CohereColors.darkRuleSoft
        : CohereColors.hairlineSoft,
    surfaceContainerLowest: isDark
        ? CohereColors.darkPage
        : CohereColors.canvas,
    surfaceContainerLow: isDark ? CohereColors.darkCard : CohereColors.surfElev,
    surfaceContainer: isDark ? CohereColors.darkStone : CohereColors.softStone,
    surfaceContainerHigh: isDark
        ? CohereColors.darkElev
        : CohereColors.softStone,
    surfaceContainerHighest: isDark
        ? CohereColors.darkElev
        : CohereColors.softStone,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: _buildTextTheme(colorScheme),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outline,
      thickness: 1,
      space: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      surfaceTintColor: Colors.transparent,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return isDark ? CohereColors.darkRule : CohereColors.hairline;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

TextTheme _buildTextTheme(ColorScheme colorScheme) {
  final onSurface = colorScheme.onSurface;
  final onSurfaceVariant = colorScheme.onSurfaceVariant;

  return TextTheme(
    // Display — Space Grotesk
    displayLarge: GoogleFonts.spaceGrotesk(
      fontSize: 72,
      fontWeight: FontWeight.w400,
      letterSpacing: -2.4,
      height: 0.95,
      color: onSurface,
    ),
    displayMedium: GoogleFonts.spaceGrotesk(
      fontSize: 52,
      fontWeight: FontWeight.w400,
      letterSpacing: -1.4,
      height: 1.0,
      color: onSurface,
    ),
    displaySmall: GoogleFonts.spaceGrotesk(
      fontSize: 40,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.8,
      height: 1.0,
      color: onSurface,
    ),
    // Headlines — Space Grotesk
    headlineLarge: GoogleFonts.spaceGrotesk(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.6,
      height: 1.05,
      color: onSurface,
    ),
    headlineMedium: GoogleFonts.spaceGrotesk(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
      color: onSurface,
    ),
    headlineSmall: GoogleFonts.spaceGrotesk(
      fontSize: 19,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
      color: onSurface,
    ),
    // Titles — Inter
    titleLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    // Body — Inter
    bodyLarge: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: onSurface,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: onSurface,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: onSurfaceVariant,
    ),
    // Labels — Inter
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: onSurfaceVariant,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: onSurfaceVariant,
    ),
  );
}

/// JetBrains Mono uppercase label style — used for section headers, timestamps.
TextStyle cohereMonoLabel(
  BuildContext context, {
  double fontSize = 11,
  Color? color,
  double? letterSpacing,
}) {
  final c = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
  return GoogleFonts.jetBrainsMono(
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    letterSpacing: letterSpacing ?? (fontSize * 0.14),
    color: c,
  );
}

/// Tabular-nums Inter for times.
TextStyle cohereTabularTime(
  BuildContext context, {
  double fontSize = 18,
  FontWeight fontWeight = FontWeight.w500,
  Color? color,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? Theme.of(context).colorScheme.onSurface,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
