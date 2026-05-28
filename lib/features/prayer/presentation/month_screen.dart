import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../../core/utils/hijri_date_format.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/domain/time_format_id.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../data/adhan_calculation_engine.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_schedule.dart';
import 'prayer_name_l10n.dart';

class MonthScreen extends StatefulWidget {
  const MonthScreen({this.initialDate, super.key});
  final DateTime? initialDate;

  @override
  State<MonthScreen> createState() => _MonthScreenState();
}

class _MonthScreenState extends State<MonthScreen> {
  late DateTime _firstOfMonth;
  late DateTime _today;
  final _scrollController = ScrollController();
  List<PrayerSchedule> _schedules = [];
  bool _computing = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    final initialDate = widget.initialDate ?? _today;
    _firstOfMonth = DateTime(initialDate.year, initialDate.month, 1);
    WidgetsBinding.instance.addPostFrameCallback((_) => _computeSchedules());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int get _daysInMonth =>
      DateTime(_firstOfMonth.year, _firstOfMonth.month + 1, 0).day;

  void _computeSchedules() {
    if (!mounted) return;
    final settings = context.read<SettingsCubit>().state.settings;
    if (!settings.setup.isComplete || settings.location == null) {
      setState(() => _computing = false);
      return;
    }
    final engine = AdhanCalculationEngine();
    final days = _daysInMonth;
    final schedules = <PrayerSchedule>[];
    for (int d = 1; d <= days; d++) {
      final date = DateTime(_firstOfMonth.year, _firstOfMonth.month, d);
      schedules.add(engine.compute(
        date: date,
        location: settings.location!,
        calculation: settings.calculation,
      ));
    }
    setState(() {
      _schedules = schedules;
      _computing = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget());
  }

  void _scrollToTarget() {
    if (!_scrollController.hasClients) return;
    DateTime? target;
    bool inThisMonth(DateTime d) =>
        d.year == _firstOfMonth.year && d.month == _firstOfMonth.month;
    if (inThisMonth(_today)) {
      target = _today;
    }
    if (target == null) return;
    const rowHeight = 58.0;
    final offset = ((target.day - 1) * rowHeight - 200.0)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.jumpTo(offset);
  }

  void _changeMonth(int delta) {
    setState(() {
      _firstOfMonth =
          DateTime(_firstOfMonth.year, _firstOfMonth.month + delta, 1);
      _schedules = [];
      _computing = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _computeSchedules());
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);
    final accentSoft = CohereColors.accentSoftColor(brightness);
    final rule = CohereColors.surfRule(brightness);
    final ruleSoft = CohereColors.surfRuleSoft(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsCubit>().state.settings;
    final fmt12 = settings.timeFormat == TimeFormatId.hour12;
    final hijriAdjDays = settings.hijriAdjustmentDays;
    final showSunrise = settings.showSunrise;

    final prayers = PrayerName.values
        .where((p) => showSunrise || p != PrayerName.sunrise)
        .toList();

    HijriCalendar.setLocal(hijriPackageLocale(settings.localeCode));
    final h1 = HijriCalendar.fromDate(
        _firstOfMonth.add(Duration(days: hijriAdjDays)));
    final h2 = HijriCalendar.fromDate(
        DateTime(_firstOfMonth.year, _firstOfMonth.month, _daysInMonth)
            .add(Duration(days: hijriAdjDays)));
    final hijriHeader = h1.hMonth == h2.hMonth
        ? '${h1.longMonthName} ${h1.hYear} AH'
        : '${h1.longMonthName} – ${h2.longMonthName} ${h2.hYear} AH';

    return Scaffold(
      backgroundColor: surfPage,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: surfPage,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: statusBarHeight + 8),
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 24, 0),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: accent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 18,
                        ),
                        label: const Text(
                          'Times',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'MONTHLY',
                        style: cohereMonoLabel(context,
                            fontSize: 11, letterSpacing: 0.14, color: inkMute),
                      ),
                    ],
                  ),
                ),
                // Month nav
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Row(
                    children: [
                      _CircleArrow(
                        icon: Icons.chevron_left,
                        ink: ink,
                        rule: rule,
                        onTap: () => _changeMonth(-1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(_firstOfMonth),
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    fontSize: 26,
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w400,
                                    color: ink,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hijriHeader,
                              style: TextStyle(fontSize: 13, color: inkDim),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      _CircleArrow(
                        icon: Icons.chevron_right,
                        ink: ink,
                        rule: rule,
                        onTap: () => _changeMonth(1),
                      ),
                    ],
                  ),
                ),
                // Sticky column header
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: rule),
                      bottom: BorderSide(color: rule),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          'DATE',
                          style: cohereMonoLabel(context,
                              fontSize: 9, letterSpacing: 0.14, color: inkMute),
                        ),
                      ),
                      ...prayers.map(
                        (p) => Expanded(
                          child: Text(
                            p
                                .label(l10n)
                                .substring(0, min(4, p.label(l10n).length))
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: cohereMonoLabel(context,
                                fontSize: 9,
                                letterSpacing: 0.14,
                                color: inkMute),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _computing
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: _daysInMonth + 1,
                    itemBuilder: (context, index) {
                      if (index == _daysInMonth) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                          child: Center(
                            child: Text(
                              'SHOWING $_daysInMonth DAYS  ·  ${DateFormat('MMMM yyyy').format(_firstOfMonth).toUpperCase()}',
                              style: cohereMonoLabel(context,
                                  fontSize: 10,
                                  letterSpacing: 0.14,
                                  color: inkMute),
                            ),
                          ),
                        );
                      }
                      final day = index + 1;
                      final date = DateTime(
                          _firstOfMonth.year, _firstOfMonth.month, day);
                      final isToday = date.year == _today.year &&
                          date.month == _today.month &&
                          date.day == _today.day;
                      final isFriday = date.weekday == DateTime.friday;

                      final adjusted =
                          date.add(Duration(days: hijriAdjDays));
                      final hijri = HijriCalendar.fromDate(adjusted);
                      final schedule = index < _schedules.length
                          ? _schedules[index]
                          : null;

                      Color? rowBg;
                      if (isToday) { rowBg = accentSoft; }

                      return _DayRow(
                        date: date,
                        day: day,
                        isToday: isToday,
                        isFriday: isFriday,
                        rowBg: rowBg,
                        hijriDay: hijri.hDay,
                        hijriMonthAbbr: _hijriAbbr(hijri.longMonthName),
                        schedule: schedule,
                        prayers: prayers,
                        fmt12: fmt12,
                        accent: accent,
                        ink: ink,
                        inkMute: inkMute,
                        ruleSoft: ruleSoft,
                        brightness: brightness,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  static String _hijriAbbr(String monthName) {
    final words = monthName.trim().split(RegExp(r'[\s\-]+'));
    if (words.length >= 2) {
      return words
          .where((w) => w.isNotEmpty)
          .map((w) => w[0].toUpperCase())
          .join();
    }
    return monthName.substring(0, min(3, monthName.length)).toUpperCase();
  }
}

// ─── Circle arrow button ──────────────────────────────────────────────────────

class _CircleArrow extends StatelessWidget {
  const _CircleArrow({
    required this.icon,
    required this.ink,
    required this.rule,
    required this.onTap,
  });
  final IconData icon;
  final Color ink;
  final Color rule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: rule),
        ),
        child: Icon(icon, size: 20, color: ink),
      ),
    );
  }
}

// ─── Day row ─────────────────────────────────────────────────────────────────

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.date,
    required this.day,
    required this.isToday,
    required this.isFriday,
    required this.rowBg,
    required this.hijriDay,
    required this.hijriMonthAbbr,
    required this.schedule,
    required this.prayers,
    required this.fmt12,
    required this.accent,
    required this.ink,
    required this.inkMute,
    required this.ruleSoft,
    required this.brightness,
  });

  final DateTime date;
  final int day;
  final bool isToday;
  final bool isFriday;
  final Color? rowBg;
  final int hijriDay;
  final String hijriMonthAbbr;
  final PrayerSchedule? schedule;
  final List<PrayerName> prayers;
  final bool fmt12;
  final Color accent;
  final Color ink;
  final Color inkMute;
  final Color ruleSoft;
  final Brightness brightness;

  static const _weekdayLetters = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  Color get _dayNumColor {
    if (!isToday) return ink;
    return brightness == Brightness.dark ? ink : accent;
  }

  Color get _metaColor {
    if (!isToday) return inkMute;
    return brightness == Brightness.dark
        ? ink.withValues(alpha: 0.65)
        : accent.withValues(alpha: 0.85);
  }

  String _compactTime(DateTime time) {
    if (fmt12) {
      final h = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final m = time.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final wdLetter = _weekdayLetters[date.weekday % 7];

    return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: rowBg,
              border: Border(top: BorderSide(color: ruleSoft, width: 1)),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            day.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 18,
                              letterSpacing: -0.3,
                              fontWeight: FontWeight.w400,
                              color: _dayNumColor,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            wdLetter,
                            style: cohereMonoLabel(context,
                                fontSize: 9,
                                letterSpacing: 0.14,
                                color: _metaColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$hijriDay $hijriMonthAbbr',
                        style: cohereMonoLabel(context,
                            fontSize: 9,
                            letterSpacing: 0.08,
                            color: _metaColor),
                      ),
                    ],
                  ),
                ),
                ...prayers.map((p) {
                  final entry = schedule?.entries
                      .where((e) => e.name == p)
                      .firstOrNull;
                  final timeStr =
                      entry != null ? _compactTime(entry.time) : '--:--';
                  final isSunrise = p == PrayerName.sunrise;
                  return Expanded(
                    child: Text(
                      timeStr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight:
                            isToday ? FontWeight.w600 : FontWeight.w400,
                        color: isSunrise
                            ? inkMute
                            : (isToday &&
                                    brightness == Brightness.dark
                                ? ink
                                : ink),
                        fontFeatures: const [FontFeature.tabularFigures()],
                        letterSpacing: -0.1,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          // Today: left accent rail
          if (isToday)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 3, color: accent),
            ),
          // Friday: right subtle rail
          if (isFriday)
            Positioned(
              right: 0,
              top: 8,
              bottom: 8,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
    );
  }
}
