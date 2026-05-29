import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/theme.dart';
import '../../../core/navigation/primary_scroll_registry.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../../core/widgets/cohere_settings_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../notifications/data/prayer_notification_service.dart';
import '../domain/theme_mode_id.dart';
import '../domain/time_format_id.dart';
import 'settings_cubit.dart';
import 'settings_state.dart';
import 'utils/calculation_method_labels.dart';
import 'utils/settings_value_labels.dart';

const kSettingsBranchIndex = 2;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.notificationService, super.key});
  final PrayerNotificationService notificationService;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    PrimaryScrollRegistry.instance.register(
      kSettingsBranchIndex,
      _scrollController,
    );
  }

  @override
  void dispose() {
    PrimaryScrollRegistry.instance.unregister(
      kSettingsBranchIndex,
      _scrollController,
    );
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final rule = CohereColors.surfRule(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      backgroundColor: surfPage,
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings;
          final calc = settings.calculation;
          final cubit = context.read<SettingsCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sticky header
              ColoredBox(
                color: surfPage,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, statusBarHeight * 2, 24, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat(
                          'EEEE · d MMMM yyyy',
                        ).format(DateTime.now()).toUpperCase(),
                        style: cohereMonoLabel(
                          context,
                          fontSize: 11,
                          letterSpacing: 0.12,
                          color: inkDim,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.settingsTitle,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  children: [
                    // Location section
                    CohereSectionLabel(label: l10n.settingsGroupLocation),
                    CohereNavRow(
                      label: locationSummary(l10n, settings.location),
                      onTap: () => context.push('/settings/location'),
                    ),
                    Container(height: 1, color: rule),

                    // Calculation section
                    CohereSectionLabel(label: l10n.settingsGroupCalculation),
                    CohereNavRow(
                      label: l10n.calculationMethodTitle,
                      value: calculationMethodLabel(calc.method),
                      onTap: () => context.push('/settings/calculation-method'),
                    ),
                    CohereNavRow(
                      label: l10n.madhabTitle,
                      value: madhabLabel(l10n, calc.madhab),
                      onTap: () => context.push('/settings/madhab'),
                    ),
                    CohereNavRow(
                      label: l10n.highLatitudeTitle,
                      value: highLatitudeLabel(l10n, calc.highLatitudeRule),
                      onTap: () => context.push('/settings/high-latitude'),
                    ),
                    CohereNavRow(
                      label: 'Prayer offsets',
                      value: advancedCalculationSummary(l10n, settings),
                      onTap: () => context.push('/settings/advanced'),
                    ),
                    Container(height: 1, color: rule),

                    // Display section
                    CohereSectionLabel(label: l10n.settingsGroupDisplay),
                    _InlineRadioSection(
                      label: 'Appearance',
                      rule: rule,
                      ink: ink,
                      inkMute: inkMute,
                      child: CohereRadioGroup<ThemeModeId>(
                        value: settings.themeMode,
                        options: [
                          CohereRadioOption(
                            value: ThemeModeId.system,
                            label: l10n.themeSystem,
                          ),
                          CohereRadioOption(
                            value: ThemeModeId.light,
                            label: l10n.themeLight,
                          ),
                          CohereRadioOption(
                            value: ThemeModeId.dark,
                            label: l10n.themeDark,
                          ),
                        ],
                        onChanged: cubit.setThemeMode,
                      ),
                    ),
                    _InlineRadioSection(
                      label: 'Hour format',
                      rule: rule,
                      ink: ink,
                      inkMute: inkMute,
                      child: CohereRadioGroup<TimeFormatId>(
                        value: settings.timeFormat,
                        options: [
                          CohereRadioOption(
                            value: TimeFormatId.hour12,
                            label: l10n.timeFormat12,
                          ),
                          CohereRadioOption(
                            value: TimeFormatId.hour24,
                            label: l10n.timeFormat24,
                          ),
                        ],
                        onChanged: cubit.setTimeFormat,
                      ),
                    ),
                    CohereToggleRow(
                      label: 'Show Sunrise time',
                      value: settings.showSunrise,
                      onChanged: cubit.setShowSunrise,
                    ),
                    Container(height: 1, color: rule),

                    // Calendar section
                    CohereSectionLabel(label: 'Calendar'),
                    CohereStepperRow(
                      label: l10n.hijriAdjustmentTitle,
                      value: settings.hijriAdjustmentDays,
                      min: -2,
                      max: 2,
                      unit: 'day',
                      onChanged: cubit.setHijriAdjustmentDays,
                    ),
                    Container(height: 1, color: rule),

                    // Notifications section
                    CohereSectionLabel(label: l10n.settingsGroupNotifications),
                    CohereNavRow(
                      label: 'Default notification',
                      value: notificationsSummary(l10n, settings),
                      onTap: () => context.push('/settings/notifications'),
                    ),
                    CohereNavRow(
                      label: 'Pre-prayer reminder',
                      value: settings.notifications.preReminderEnabled
                          ? '${settings.notifications.preReminderMinutes} min before'
                          : 'Off',
                      onTap: () => context.push('/settings/pre-reminder'),
                    ),
                    Container(height: 1, color: rule),

                    // Language section
                    CohereSectionLabel(label: l10n.language),
                    CohereNavRow(
                      label: l10n.language,
                      value: languageLabel(settings.localeCode),
                      onTap: () => context.push('/settings/language'),
                    ),
                    Container(height: 1, color: rule),

                    _VersionFooter(ink: inkMute),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InlineRadioSection extends StatelessWidget {
  const _InlineRadioSection({
    required this.label,
    required this.rule,
    required this.ink,
    required this.inkMute,
    required this.child,
  });

  final String label;
  final Color rule;
  final Color ink;
  final Color inkMute;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: rule, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
            child: Text(label, style: TextStyle(fontSize: 15, color: ink)),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _RateSection extends StatefulWidget {
  const _RateSection({required this.inkMute});
  final Color inkMute;

  @override
  State<_RateSection> createState() => _RateSectionState();
}

class _RateSectionState extends State<_RateSection> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final accent = CohereColors.accentColor(brightness);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Column(
        children: [
          Text(
            'RATE AWQAT',
            style: cohereMonoLabel(
              context,
              fontSize: 11,
              letterSpacing: 0.14,
              color: widget.inkMute.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < _rating;
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: CustomPaint(
                    size: const Size(24, 24),
                    painter: _StarPainter(
                      filled: filled,
                      color: filled ? accent : widget.inkMute,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter({required this.filled, required this.color});
  final bool filled;
  final Color color;

  // Star path points on a 24×24 coordinate system (matches design SVG)
  static const _pts = [
    Offset(12.0, 3.2),
    Offset(14.6, 8.75),
    Offset(20.7, 9.5),
    Offset(16.2, 13.65),
    Offset(17.4, 19.65),
    Offset(12.0, 16.65),
    Offset(6.6, 19.65),
    Offset(7.8, 13.65),
    Offset(3.3, 9.5),
    Offset(9.4, 8.75),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    final path = Path()..moveTo(_pts[0].dx * s, _pts[0].dy * s);
    for (var i = 1; i < _pts.length; i++) {
      path.lineTo(_pts[i].dx * s, _pts[i].dy * s);
    }
    path.close();

    final paint = Paint()..color = color;
    if (filled) {
      paint.style = PaintingStyle.fill;
    } else {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s
        ..strokeJoin = StrokeJoin.round;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) =>
      old.filled != filled || old.color != color;
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter({required this.ink});
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final label = info == null
            ? l10n.appTitle
            : l10n.settingsVersionLabel(info.version, info.buildNumber);

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Center(
            child: Text(
              label,
              style: cohereMonoLabel(
                context,
                fontSize: 11,
                letterSpacing: 0.14,
                color: ink.withValues(alpha: 0.55),
              ),
            ),
          ),
        );
      },
    );
  }
}
