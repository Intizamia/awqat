import 'package:flutter/material.dart';
import 'package:times/core/theme/app_surface_tokens.dart';

/// Full-width divider between rows on grouped settings cards.
class ScheduleGrooveDivider extends StatelessWidget {
  const ScheduleGrooveDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Divider(
      height: 1,
      thickness: AppSurfaceTokens.scheduleGrooveDividerThickness,
      color: AppSurfaceTokens.scheduleGrooveDividerColor(theme),
    );
  }
}
