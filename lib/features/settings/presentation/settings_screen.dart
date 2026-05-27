import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:times/app/theme.dart';
import 'package:times/core/navigation/primary_scroll_registry.dart';
import 'package:times/core/theme/cohere_colors.dart';
import 'package:times/core/widgets/cohere_settings_widgets.dart';
import 'package:times/features/notifications/data/prayer_notification_service.dart';
import 'package:times/features/settings/domain/theme_mode_id.dart';
import 'package:times/features/settings/domain/time_format_id.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/features/settings/presentation/utils/calculation_method_labels.dart';
import 'package:times/features/settings/presentation/utils/settings_value_labels.dart';
import 'package:times/l10n/app_localizations.dart';

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
    PrimaryScrollRegistry.instance
        .register(kSettingsBranchIndex, _scrollController);
  }

  @override
  void dispose() {
    PrimaryScrollRegistry.instance
        .unregister(kSettingsBranchIndex, _scrollController);
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

          return ListView(
            controller: _scrollController,
            children: [
              SizedBox(height: statusBarHeight),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.navSettings.toUpperCase(),
                      style: cohereMonoLabel(context,
                          fontSize: 11,
                          letterSpacing: 0.12,
                          color: inkDim),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.settingsTitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ),

              // Location section
              CohereSectionLabel(label: l10n.settingsGroupLocation),
              CohereNavRow(
                label: locationSummary(l10n, settings.location),
                sub: settings.location != null
                    ? 'Auto · ${settings.location!.timeZoneId}'
                    : l10n.locationSubtitle,
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
                sub: 'Used for Asr time',
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
                sub: 'Adjust per prayer or all at once',
                value: advancedCalculationSummary(l10n, settings),
                onTap: () => context.push('/settings/advanced'),
              ),
              Container(height: 1, color: rule),

              // Display section
              CohereSectionLabel(label: l10n.settingsGroupDisplay),
              _InlineRadioSection(
                label: 'Appearance',
                isFirst: true,
                rule: rule,
                ink: ink,
                inkMute: inkMute,
                child: CohereRadioGroup<ThemeModeId>(
                  value: settings.themeMode,
                  options: [
                    CohereRadioOption(
                        value: ThemeModeId.system, label: l10n.themeSystem),
                    CohereRadioOption(
                        value: ThemeModeId.light, label: l10n.themeLight),
                    CohereRadioOption(
                        value: ThemeModeId.dark, label: l10n.themeDark),
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
                        value: TimeFormatId.hour12, label: l10n.timeFormat12),
                    CohereRadioOption(
                        value: TimeFormatId.hour24, label: l10n.timeFormat24),
                  ],
                  onChanged: cubit.setTimeFormat,
                ),
              ),
              CohereToggleRow(
                label: 'Show Sunrise time',
                sub: 'Display Shuruq between Fajr and Dhuhr',
                value: settings.showSunrise,
                onChanged: cubit.setShowSunrise,
              ),
              Container(height: 1, color: rule),

              // Calendar section
              CohereSectionLabel(label: 'Calendar'),
              CohereStepperRow(
                label: l10n.hijriAdjustmentTitle,
                sub: 'Shift Hijri date for local moon sighting',
                value: settings.hijriAdjustmentDays,
                min: -2,
                max: 2,
                unit: 'day',
                isFirst: true,
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
              CohereToggleRow(
                label: 'Pre-prayer reminder',
                sub: 'Notify 10 minutes before each prayer',
                value: false,
                onChanged: (_) {},
              ),
              CohereToggleRow(
                label: 'Silent during Friday Khutbah',
                value: false,
                onChanged: (_) {},
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

              // Version footer
              _VersionFooter(ink: inkMute),
              const SizedBox(height: 100),
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
    this.isFirst = false,
  });

  final String label;
  final bool isFirst;
  final Color rule;
  final Color ink;
  final Color inkMute;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isFirst
          ? null
          : BoxDecoration(
              border: Border(top: BorderSide(color: rule, width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 15, color: ink)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
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
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Center(
            child: Text(
              label,
              style: cohereMonoLabel(context,
                  fontSize: 11,
                  letterSpacing: 0.14,
                  color: ink.withValues(alpha: 0.55)),
            ),
          ),
        );
      },
    );
  }
}
