import 'package:flutter/material.dart';
import 'package:times/core/utils/hijri_date_format.dart';
import 'package:times/l10n/app_localizations.dart';

class PrayerDateHeader extends StatelessWidget {
  const PrayerDateHeader({
    required this.date,
    required this.localeCode,
    required this.hijriAdjustmentDays,
    super.key,
  });

  final DateTime date;
  final String localeCode;
  final int hijriAdjustmentDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final gregorian = formatGregorianDate(date, localeCode);
    final hijri = formatHijriDate(
      date,
      adjustmentDays: hijriAdjustmentDays,
      appLocaleCode: localeCode,
      suffix: l10n.hijriSuffix,
    );

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.todayDate,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              gregorian,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              hijri,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
              textDirection:
                  localeCode == 'ar' || localeCode == 'ur' ? TextDirection.rtl : null,
            ),
            if (hijriAdjustmentDays != 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.hijriAdjustmentApplied(hijriAdjustmentDays),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
