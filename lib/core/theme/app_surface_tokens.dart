import 'package:flutter/material.dart';

/// Shared tonal surfaces for grouped settings cards and schedule-style rows.
abstract final class AppSurfaceTokens {
  static const double scheduleGridCornerRadius = 16;
  static const double scheduleGrooveDividerThickness = 1.5;

  static Color scheduleGridBodyColor(ThemeData theme) {
    final scheme = theme.colorScheme;
    final kpiTone = scheme.surfaceContainerHigh;
    if (theme.brightness == Brightness.light) {
      return Color.lerp(kpiTone, scheme.surface, 0.36)!;
    }
    return Color.lerp(kpiTone, scheme.surface, 0.6)!;
  }

  static Color scheduleGridIconWellColor(ThemeData theme) {
    final scheme = theme.colorScheme;
    final canvas = scheduleGridBodyColor(theme);
    final scaffoldLift = Color.alphaBlend(
      theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
      canvas,
    );
    return Color.alphaBlend(
      scheme.primary.withValues(alpha: 0.06),
      Color.alphaBlend(scheme.surface.withValues(alpha: 0.22), scaffoldLift),
    );
  }

  static Color scheduleGrooveDividerColor(ThemeData theme) {
    final canvas = scheduleGridBodyColor(theme);
    return Color.alphaBlend(
      theme.scaffoldBackgroundColor.withValues(alpha: 0.75),
      canvas,
    );
  }
}
