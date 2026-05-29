import 'dart:async';

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
import '../domain/prayer_name.dart';
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

  @override
  void initState() {
    super.initState();
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
    if (state == AppLifecycleState.resumed) _refresh();
  }

  void _refresh() {
    final settings = context.read<SettingsCubit>().state;
    if (!settings.isLoading) {
      context.read<PrayerTimesCubit>().refresh(settings.settings);
    }
  }

  void _openMonth() {
    context.push('/prayer/month');
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
    required this.onMonthTap,
  });

  final ScrollController scrollController;
  final AppSettings settings;
  final VoidCallback onMonthTap;

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

        final fmt = settings.timeFormat;
        final visibleEntries = todaySchedule.entries
            .where((e) => settings.showSunrise || e.name != PrayerName.sunrise)
            .toList();

        final locationLabel = settings.location?.label ?? '';
        final hijriShort = settings.hijriAdjustmentDays != 0
            ? (settings.hijriAdjustmentDays > 0
                  ? 'Q+${settings.hijriAdjustmentDays}'
                  : 'Q${settings.hijriAdjustmentDays}')
            : null;
        final statusBarHeight = MediaQuery.of(context).viewPadding.top;
        final next = todaySchedule.nextPrayer!;

        return Scaffold(
          backgroundColor: surfPage,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sticky header — tapping opens month view
              ColoredBox(
                color: surfPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: statusBarHeight * 2),
                    PrayerDateHeader(
                      date: todaySchedule.date,
                      localeCode: settings.localeCode,
                      hijriAdjustmentDays: settings.hijriAdjustmentDays,
                      locationLabel: locationLabel,
                      hijriAdjustmentShort: hijriShort,
                      onTap: onMonthTap,
                    ),
                    Container(height: 1, color: rule),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    _ClockBlock(next: next, fmt: fmt),
                    ...visibleEntries.map((entry) {
                      final isNext = entry.name == next.name;
                      final isPassed =
                          entry.time.isBefore(DateTime.now()) && !isNext;
                      final notifOn =
                          settings.notifications.enabled &&
                          settings.notifications.isPrayerEnabled(entry.name);
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
            ],
          ),
        );
      },
    );
  }
}

// ─── Clock block ──────────────────────────────────────────────────────────────

class _ClockBlock extends StatefulWidget {
  const _ClockBlock({required this.next, required this.fmt});

  final PrayerTimeEntry next;
  final TimeFormatId fmt;

  @override
  State<_ClockBlock> createState() => _ClockBlockState();
}

class _ClockBlockState extends State<_ClockBlock> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final accent = CohereColors.accentColor(brightness);

    final now = DateTime.now();
    final use12 = widget.fmt == TimeFormatId.hour12;
    final hour = use12 ? (now.hour % 12 == 0 ? 12 : now.hour % 12) : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour < 12 ? 'AM' : 'PM';
    final remaining = widget.next.time.difference(now);
    final cd = remaining.isNegative ? Duration.zero : remaining;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
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
                  fontSize: 48,
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
                  style: cohereMonoLabel(
                    context,
                    fontSize: 14,
                    letterSpacing: 0.16,
                    color: inkDim,
                  ),
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
                  text: widget.next.name.label(l10n),
                  style: TextStyle(fontWeight: FontWeight.w500, color: accent),
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
