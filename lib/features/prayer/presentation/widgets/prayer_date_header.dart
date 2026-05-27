import 'package:flutter/material.dart';
import 'package:awqat/app/theme.dart';
import 'package:awqat/core/theme/cohere_colors.dart';
import 'package:awqat/core/utils/hijri_date_format.dart';
import 'package:awqat/l10n/app_localizations.dart';

class PrayerDateHeader extends StatelessWidget {
  const PrayerDateHeader({
    required this.date,
    required this.localeCode,
    required this.hijriAdjustmentDays,
    this.locationLabel,
    this.hijriAdjustmentShort,
    super.key,
  });

  final DateTime date;
  final String localeCode;
  final int hijriAdjustmentDays;
  final String? locationLabel;
  final String? hijriAdjustmentShort;

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l10n.todayDate.toUpperCase()} · ${locationStr.toUpperCase()}',
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
          const SizedBox(height: 14),
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
          const SizedBox(height: 6),
          Text(hijri, style: TextStyle(fontSize: 15, color: inkDim)),
        ],
      ),
    );
  }
}
