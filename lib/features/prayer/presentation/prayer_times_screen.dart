import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/navigation/primary_scroll_registry.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../../core/utils/prayer_time_format.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/domain/time_format_id.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../settings/presentation/settings_state.dart';
import '../data/adhan_calculation_engine.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_schedule.dart';
import '../domain/prayer_time_entry.dart';
import 'prayer_name_l10n.dart';
import 'prayer_times_cubit.dart';
import 'prayer_times_state.dart';
import 'widgets/prayer_date_header.dart';
import 'widgets/setup_checklist_body.dart';

const _kArabicNames = {
  PrayerName.fajr: 'الفجر',
  PrayerName.sunrise: 'الشروق',
  PrayerName.dhuhr: 'الظهر',
  PrayerName.asr: 'العصر',
  PrayerName.maghrib: 'المغرب',
  PrayerName.isha: 'العشاء',
};

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen>
    with WidgetsBindingObserver {
  static const _branchIndex = 0;
  final _scrollController = ScrollController();
  late DateTime _today;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDate = _today;
    WidgetsBinding.instance.addObserver(this);
    PrimaryScrollRegistry.instance.register(_branchIndex, _scrollController);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PrimaryScrollRegistry.instance.unregister(_branchIndex, _scrollController);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      final newToday = DateTime(now.year, now.month, now.day);
      if (newToday != _today) {
        setState(() {
          _today = newToday;
          if (_selectedDate == _today) _selectedDate = newToday;
        });
      }
      _refresh();
    }
  }

  void _refresh() {
    final settings = context.read<SettingsCubit>().state;
    if (!settings.isLoading) {
      context.read<PrayerTimesCubit>().refresh(settings.settings);
    }
  }

  Future<void> _openMonth() async {
    final result = await context.push<DateTime?>('/prayer/month',
        extra: _selectedDate);
    if (result != null && mounted) {
      setState(() => _selectedDate = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.settings != curr.settings && !curr.isLoading,
      listener: (context, state) {
        context.read<PrayerTimesCubit>().refresh(state.settings);
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          if (settingsState.isLoading) {
            return const _LoadingScaffold();
          }

          if (!settingsState.settings.setup.isComplete) {
            return SetupChecklistBody(settings: settingsState.settings);
          }

          return _PrayerList(
            scrollController: _scrollController,
            settings: settingsState.settings,
            onRefresh: _refresh,
            selectedDate: _selectedDate,
            today: _today,
            onDateSelected: (d) => setState(() => _selectedDate = d),
            onMonthTap: _openMonth,
          );
        },
      ),
    );
  }
}

// ─── Loading scaffold ─────────────────────────────────────────────────────────

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: CohereColors.surfPage(brightness),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}

// ─── Main prayer list ─────────────────────────────────────────────────────────

class _PrayerList extends StatelessWidget {
  const _PrayerList({
    required this.scrollController,
    required this.settings,
    required this.onRefresh,
    required this.selectedDate,
    required this.today,
    required this.onDateSelected,
    required this.onMonthTap,
  });

  final ScrollController scrollController;
  final AppSettings settings;
  final VoidCallback onRefresh;
  final DateTime selectedDate;
  final DateTime today;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onMonthTap;

  bool get _isViewingToday =>
      selectedDate.year == today.year &&
      selectedDate.month == today.month &&
      selectedDate.day == today.day;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, prayerState) {
        final brightness = Theme.of(context).brightness;
        final surfPage = CohereColors.surfPage(brightness);
        final rule = CohereColors.surfRule(brightness);

        if (prayerState.isLoading) {
          return Scaffold(
            backgroundColor: surfPage,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (prayerState.errorMessage != null) {
          return Scaffold(
            backgroundColor: surfPage,
            body: Center(child: Text(prayerState.errorMessage!)),
          );
        }

        final todaySchedule = prayerState.schedule;
        if (todaySchedule == null) {
          return Scaffold(backgroundColor: surfPage, body: const SizedBox());
        }

        // For non-today, compute inline (synchronous + fast for a single day)
        final PrayerSchedule displaySchedule;
        if (_isViewingToday) {
          displaySchedule = todaySchedule;
        } else {
          displaySchedule = AdhanCalculationEngine().compute(
            date: selectedDate,
            location: settings.location!,
            calculation: settings.calculation,
          );
        }

        final fmt = settings.timeFormat;
        final visibleEntries = displaySchedule.entries
            .where(
                (e) => settings.showSunrise || e.name != PrayerName.sunrise)
            .toList();

        final locationLabel = settings.location?.label ?? '';
        final hijriShort = settings.hijriAdjustmentDays != 0
            ? (settings.hijriAdjustmentDays > 0
                ? 'Q+${settings.hijriAdjustmentDays}'
                : 'Q${settings.hijriAdjustmentDays}')
            : null;
        final statusBarHeight = MediaQuery.of(context).viewPadding.top;

        // Today's next prayer + countdown (only meaningful when viewing today)
        final next = todaySchedule.nextPrayer!;
        final remaining = next.time.difference(DateTime.now());

        return Scaffold(
          backgroundColor: surfPage,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sticky header
              ColoredBox(
                color: surfPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: statusBarHeight * 2),
                    PrayerDateHeader(
                      date: selectedDate,
                      localeCode: settings.localeCode,
                      hijriAdjustmentDays: settings.hijriAdjustmentDays,
                      locationLabel: locationLabel,
                      hijriAdjustmentShort: hijriShort,
                      isToday: _isViewingToday,
                    ),
                    _WeekStrip(
                      selectedDate: selectedDate,
                      today: today,
                      onDaySelected: onDateSelected,
                      onMonthTap: onMonthTap,
                    ),
                    // Hidden when not viewing today: clock block disappears,
                    // making this divider overlap the prayer list's top border.
                    if (_isViewingToday)
                      Container(
                        height: 1,
                        color: rule,
                      ),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _isViewingToday ? () async => onRefresh() : () async {},
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      if (_isViewingToday)
                        _ClockBlock(
                          next: next,
                          remaining: remaining,
                          fmt: fmt,
                        ),
                      ...visibleEntries.map((entry) {
                        final isNext =
                            _isViewingToday && entry.name == next.name;
                        final isPassed = _isViewingToday
                            ? entry.time.isBefore(DateTime.now()) && !isNext
                            : false;
                        final notifOn = settings.notifications.enabled &&
                            settings.notifications
                                .isPrayerEnabled(entry.name);
                        return _PrayerRow(
                          name: entry.name,
                          time: entry.time,
                          fmt: fmt,
                          isNext: isNext,
                          isPassed: isPassed,
                          notifOn: notifOn,
                          notifMasterEnabled: settings.notifications.enabled,
                        );
                      }),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Week strip ───────────────────────────────────────────────────────────────

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.selectedDate,
    required this.today,
    required this.onDaySelected,
    required this.onMonthTap,
  });

  final DateTime selectedDate;
  final DateTime today;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onMonthTap;

  List<DateTime> get _stripDays => List.generate(7, (i) {
        final d = today.add(Duration(days: i - 3));
        return DateTime(d.year, d.month, d.day);
      });

  static const _wdLetters = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);
    final surfPage = CohereColors.surfPage(brightness);
    final surfStone = CohereColors.surfStone(brightness);
    final rule = CohereColors.surfRule(brightness);
    final days = _stripDays;

    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            ...days.map((d) {
              final isSel = d.year == selectedDate.year &&
                  d.month == selectedDate.month &&
                  d.day == selectedDate.day;
              final isToday = d.year == today.year &&
                  d.month == today.month &&
                  d.day == today.day;
              final wdLetter = _wdLetters[d.weekday % 7];

              final chipBg = isSel ? ink : Colors.transparent;
              final chipBorder = isSel ? ink : (isToday ? accent : rule);
              final numColor = isSel ? surfPage : ink;
              final wdColor =
                  isSel ? surfPage.withValues(alpha: 0.7) : inkMute;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => onDaySelected(d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 42,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    decoration: BoxDecoration(
                      color: chipBg,
                      border: Border.all(color: chipBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          wdLetter,
                          style: cohereMonoLabel(context,
                              fontSize: 9, letterSpacing: 0.14, color: wdColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          d.day.toString(),
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.3,
                            color: numColor,
                            height: 1.0,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(width: 2),
            // Month CTA
            GestureDetector(
              onTap: onMonthTap,
              child: Container(
                width: 72,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: surfStone,
                  border: Border.all(color: rule),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MONTH',
                      style: cohereMonoLabel(context,
                          fontSize: 9, letterSpacing: 0.14, color: inkMute),
                    ),
                    const SizedBox(height: 5),
                    Icon(Icons.calendar_month_outlined, size: 16, color: ink),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Clock block ──────────────────────────────────────────────────────────────

class _ClockBlock extends StatelessWidget {
  const _ClockBlock({
    required this.next,
    required this.remaining,
    required this.fmt,
  });

  final PrayerTimeEntry next;
  final Duration remaining;
  final TimeFormatId fmt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final accent = CohereColors.accentColor(brightness);

    final now = DateTime.now();
    final use12 = fmt == TimeFormatId.hour12;
    final hour =
        use12 ? (now.hour % 12 == 0 ? 12 : now.hour % 12) : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour < 12 ? 'AM' : 'PM';
    final cd = remaining.isNegative ? Duration.zero : remaining;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$hour:$minute',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 64,
                      letterSpacing: -2.4,
                      fontWeight: FontWeight.w400,
                      height: 0.95,
                      color: ink,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
              if (use12) ...[
                const SizedBox(width: 14),
                Text(
                  ampm,
                  style: cohereMonoLabel(context,
                      fontSize: 14, letterSpacing: 0.16, color: inkDim),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 18, color: inkDim),
              children: [
                const TextSpan(text: 'Next: '),
                TextSpan(
                  text: next.name.label(l10n),
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: accent),
                ),
                TextSpan(text: ' in ${formatCountdown(cd)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Prayer row ───────────────────────────────────────────────────────────────

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.name,
    required this.time,
    required this.fmt,
    required this.isNext,
    required this.isPassed,
    required this.notifOn,
    required this.notifMasterEnabled,
  });

  final PrayerName name;
  final DateTime time;
  final TimeFormatId fmt;
  final bool isNext;
  final bool isPassed;
  final bool notifOn;
  final bool notifMasterEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);

    final nameColor = isPassed ? inkMute : ink;
    final timeColor = isNext ? accent : (isPassed ? inkMute : ink);
    final arabic = _kArabicNames[name] ?? '';

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: rule, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isNext ? accent : Colors.transparent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.label(l10n),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 22,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w400,
                        color: nameColor,
                      ),
                ),
                if (arabic.isNotEmpty)
                  Text(
                    arabic,
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.1,
                      color: inkMute,
                      fontFamily: 'Inter',
                    ),
                  ),
              ],
            ),
          ),
          Text(
            formatPrayerTime(time, format: fmt),
            style: TextStyle(
              fontSize: 18,
              fontWeight: isNext ? FontWeight.w600 : FontWeight.w500,
              color: timeColor,
              fontFamily: 'Inter',
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: Icon(
                notifOn && notifMasterEnabled
                    ? Icons.notifications_outlined
                    : Icons.notifications_off_outlined,
                size: 18,
                color: inkMute,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
