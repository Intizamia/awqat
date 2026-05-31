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
import '../domain/prayer_notif_type.dart';
import '../domain/prayer_time_entry.dart';
import 'prayer_name_l10n.dart';
import 'prayer_times_cubit.dart';
import 'prayer_times_state.dart';
import 'widgets/prayer_date_header.dart';
import 'widgets/setup_checklist_body.dart';

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
                      final notifType = settings.notifications.notifTypeFor(
                        entry.name,
                      );
                      return _PrayerRow(
                        name: entry.name,
                        time: entry.time,
                        fmt: fmt,
                        isNext: isNext,
                        isPassed: isPassed,
                        notifType: notifType,
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
    required this.notifType,
  });

  final PrayerName name;
  final DateTime time;
  final TimeFormatId fmt;
  final bool isNext;
  final bool isPassed;
  final PrayerNotifType notifType;

  void _showMenu(BuildContext ctx) {
    final box = ctx.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;
    final screenWidth = MediaQuery.of(ctx).size.width;
    final brightness = Theme.of(ctx).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final menuBg = CohereColors.surfElevColor(brightness);
    final menuBorder = CohereColors.surfRule(brightness);
    final accent = CohereColors.accentColor(brightness);

    final position = RelativeRect.fromLTRB(
      pos.dx,
      pos.dy + size.height + 4,
      screenWidth - pos.dx - size.width,
      0,
    );

    final cubit = ctx.read<SettingsCubit>();

    showMenu<PrayerNotifType>(
      context: ctx,
      position: position,
      color: menuBg,
      elevation: 8,
      shadowColor: Colors.black38,
      menuPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: menuBorder),
      ),
      items: [
        PopupMenuItem<PrayerNotifType>(
          enabled: false,
          height: 36,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            'NOTIFICATION',
            style: cohereMonoLabel(
              ctx,
              fontSize: 10,
              letterSpacing: 0.18,
              color: inkMute,
            ),
          ),
        ),
        for (final type in PrayerNotifType.values)
          PopupMenuItem<PrayerNotifType>(
            value: type,
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CustomPaint(
                    painter: _NotifIconPainter(
                      type: type,
                      color: type == notifType ? accent : ink,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  type.label,
                  style: TextStyle(
                    fontSize: 15,
                    color: type == notifType ? accent : ink,
                    fontWeight: type == notifType
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                ),
                if (type == notifType) ...[
                  const Spacer(),
                  Icon(Icons.check, size: 16, color: accent),
                ],
              ],
            ),
          ),
      ],
    ).then((selected) {
      if (selected != null && selected != notifType) {
        cubit.setPrayerNotifType(name, selected);
      }
    });
  }

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
    final isSilent = notifType == PrayerNotifType.silent;

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
          const SizedBox(width: 14),
          Builder(
            builder: (iconCtx) => GestureDetector(
              onTap: () => _showMenu(iconCtx),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 36,
                height: 36,
                child: isSilent
                    ? CustomPaint(
                        painter: _DashedCirclePainter(color: rule),
                        child: Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CustomPaint(
                              painter: _NotifIconPainter(
                                type: notifType,
                                color: inkMute,
                              ),
                            ),
                          ),
                        ),
                      )
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CustomPaint(
                              painter: _NotifIconPainter(
                                type: notifType,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Notification disc painters ──────────────────────────────────────────────

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.butt;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    final circle = Path()..addOval(Rect.fromCircle(center: center, radius: radius));

    const dashLen = 3.5;
    const gapLen = 3.0;
    final dashPath = Path();
    for (final metric in circle.computeMetrics()) {
      var dist = 0.0;
      var drawing = true;
      while (dist < metric.length) {
        final seg = drawing ? dashLen : gapLen;
        if (drawing) {
          dashPath.addPath(metric.extractPath(dist, dist + seg), Offset.zero);
        }
        dist += seg;
        drawing = !drawing;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter old) => old.color != color;
}

class _NotifIconPainter extends CustomPainter {
  const _NotifIconPainter({required this.type, required this.color});

  final PrayerNotifType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (type) {
      case PrayerNotifType.silent:
        _paintBellOff(canvas, p, s);
      case PrayerNotifType.reminder:
        _paintBell(canvas, p, s);
      case PrayerNotifType.firstSentence:
        _paintMic(canvas, p, s);
      case PrayerNotifType.fullAthan:
        _paintSpeaker(canvas, p, s);
    }
  }

  void _paintBellOff(Canvas canvas, Paint p, double s) {
    canvas.drawPath(
      Path()
        ..moveTo(6 * s, 8 * s)
        ..arcToPoint(
          Offset(18 * s, 8 * s),
          radius: Radius.circular(6 * s),
          clockwise: true,
        )
        ..lineTo(18 * s, 11 * s)
        ..lineTo(19.5 * s, 14 * s)
        ..lineTo(4.5 * s, 14 * s)
        ..lineTo(6 * s, 11 * s)
        ..close(),
      p,
    );
    canvas.drawLine(Offset(3 * s, 3 * s), Offset(21 * s, 21 * s), p);
    canvas.drawPath(
      Path()
        ..moveTo(10 * s, 19 * s)
        ..arcToPoint(
          Offset(14 * s, 19 * s),
          radius: Radius.circular(2 * s),
          clockwise: false,
        ),
      p,
    );
  }

  void _paintBell(Canvas canvas, Paint p, double s) {
    canvas.drawPath(
      Path()
        ..moveTo(6 * s, 8 * s)
        ..arcToPoint(
          Offset(18 * s, 8 * s),
          radius: Radius.circular(6 * s),
          clockwise: true,
        )
        ..lineTo(18 * s, 11 * s)
        ..lineTo(19.5 * s, 14 * s)
        ..lineTo(4.5 * s, 14 * s)
        ..lineTo(6 * s, 11 * s)
        ..close(),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(10 * s, 18 * s)
        ..arcToPoint(
          Offset(14 * s, 18 * s),
          radius: Radius.circular(2 * s),
          clockwise: false,
        ),
      p,
    );
  }

  void _paintMic(Canvas canvas, Paint p, double s) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(9 * s, 3 * s, 6 * s, 12 * s),
        Radius.circular(3 * s),
      ),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(5 * s, 11 * s)
        ..arcToPoint(
          Offset(19 * s, 11 * s),
          radius: Radius.circular(7 * s),
          clockwise: false,
        ),
      p,
    );
    canvas.drawLine(Offset(12 * s, 18 * s), Offset(12 * s, 21 * s), p);
    canvas.drawLine(Offset(9 * s, 21 * s), Offset(15 * s, 21 * s), p);
  }

  void _paintSpeaker(Canvas canvas, Paint p, double s) {
    canvas.drawPath(
      Path()
        ..moveTo(4 * s, 9 * s)
        ..lineTo(4 * s, 15 * s)
        ..lineTo(8 * s, 15 * s)
        ..lineTo(13 * s, 19 * s)
        ..lineTo(13 * s, 5 * s)
        ..lineTo(8 * s, 9 * s)
        ..close(),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(16 * s, 8.5 * s)
        ..arcToPoint(
          Offset(16 * s, 15.5 * s),
          radius: Radius.circular(5 * s),
          clockwise: true,
        ),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(19 * s, 5.5 * s)
        ..arcToPoint(
          Offset(19 * s, 18.5 * s),
          radius: Radius.circular(9 * s),
          clockwise: true,
        ),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant _NotifIconPainter old) =>
      old.type != type || old.color != color;
}
