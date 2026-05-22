import 'package:flutter/material.dart';

/// Shared sizing for settings hub rows and detail option rows.
abstract final class SettingsRowMetrics {
  static const double minHeight = 72;

  static const EdgeInsets contentPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);
}
