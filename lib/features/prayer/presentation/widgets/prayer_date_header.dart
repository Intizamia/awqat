import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../core/theme/cohere_colors.dart';
import '../../../../core/utils/hijri_date_format.dart';
import '../../../../l10n/app_localizations.dart';

class PrayerDateHeader extends StatelessWidget {
  const PrayerDateHeader({
    required this.date,
    required this.localeCode,
    required this.hijriAdjustmentDays,
    this.locationLabel,
    this.hijriAdjustmentShort,
    this.isToday = true,
    this.onTap,
    super.key,
  });

  final DateTime date;
  final String localeCode;
  final int hijriAdjustmentDays;
  final String? locationLabel;
  final String? hijriAdjustmentShort;
  final bool isToday;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final inkMute = CohereColors.inkMute(brightness);

    final gregorian = formatGregorianDate(date, localeCode);
    final hijri = formatHijriDate(
      date,
      adjustmentDays: hijriAdjustmentDays,
      appLocaleCode: localeCode,
      suffix: l10n.hijriSuffix,
    );

    final locationStr = locationLabel?.isNotEmpty == true
        ? locationLabel!
        : l10n.locationNotSet;

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locationStr.toUpperCase(),
                    style: cohereMonoLabel(
                      context,
                      fontSize: 11,
                      letterSpacing: 0.12,
                      color: inkDim,
                    ),
                  ),
                  if (hijriAdjustmentShort != null)
                    Text(
                      hijriAdjustmentShort!.toUpperCase(),
                      style: cohereMonoLabel(
                        context,
                        fontSize: 11,
                        letterSpacing: 0.12,
                        color: inkMute,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                gregorian,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 32,
                  letterSpacing: -0.6,
                  fontWeight: FontWeight.w400,
                  height: 1.05,
                  color: ink,
                ),
              ),
              const SizedBox(height: 10),
              Text(hijri, style: TextStyle(fontSize: 16, color: inkDim)),
            ],
          ),
        ),
        if (onTap != null) ...[
          const SizedBox(width: 12),
          Icon(Icons.calendar_month_outlined, size: 22, color: inkMute),
        ],
      ],
    );

    if (onTap != null) {
      // Outer padding creates gap between ripple boundary and screen edges/divider.
      // Inner padding is reduced by the same amount so content stays in position.
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 12, 10),
              child: content,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
      child: content,
    );
  }
}
