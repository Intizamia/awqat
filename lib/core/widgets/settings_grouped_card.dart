import 'package:flutter/material.dart';
import '../theme/app_surface_tokens.dart';
import 'schedule_groove_divider.dart';

/// Material card that groups related settings rows with groove dividers.
class SettingsGroupedCard extends StatelessWidget {
  const SettingsGroupedCard({
    required this.children,
    super.key,
    this.horizontalPadding = 20,
  });

  final List<Widget> children;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Material(
        color: AppSurfaceTokens.scheduleGridBodyColor(Theme.of(context)),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        borderRadius: BorderRadius.circular(
          AppSurfaceTokens.scheduleGridCornerRadius,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const ScheduleGrooveDivider(),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
