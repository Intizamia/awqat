import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/notifications/data/prayer_notification_service.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/features/settings/presentation/utils/calculation_method_labels.dart';
import 'package:times/features/settings/presentation/utils/settings_value_labels.dart';
import 'package:times/features/settings/presentation/widgets/settings_group_label.dart';
import 'package:times/features/settings/presentation/widgets/settings_nav_row.dart';
import 'package:times/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.notificationService,
    super.key,
  });

  final PrayerNotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings;
          final calc = settings.calculation;

          return ListView(
            children: [
              SettingsGroupLabel(label: l10n.settingsGroupCalculation),
              SettingsGroupedCard(
                children: [
                  SettingsNavRow(
                    icon: Icons.calculate_outlined,
                    title: l10n.calculationMethodTitle,
                    value: calculationMethodLabel(calc.method),
                    onTap: () => context.push('/settings/calculation-method'),
                  ),
                  SettingsNavRow(
                    icon: Icons.account_balance_outlined,
                    title: l10n.madhabTitle,
                    value: madhabLabel(l10n, calc.madhab),
                    onTap: () => context.push('/settings/madhab'),
                  ),
                  SettingsNavRow(
                    icon: Icons.public_outlined,
                    title: l10n.highLatitudeTitle,
                    value: highLatitudeLabel(l10n, calc.highLatitudeRule),
                    onTap: () => context.push('/settings/high-latitude'),
                  ),
                  SettingsNavRow(
                    icon: Icons.tune_outlined,
                    title: l10n.advancedSectionTitle,
                    value: advancedCalculationSummary(l10n, settings),
                    onTap: () => context.push('/settings/advanced'),
                  ),
                ],
              ),
              SettingsGroupLabel(label: l10n.settingsGroupLocation),
              SettingsGroupedCard(
                children: [
                  SettingsNavRow(
                    icon: Icons.place_outlined,
                    title: l10n.locationTitle,
                    value: locationSummary(l10n, settings.location),
                    onTap: () => context.push('/settings/location'),
                  ),
                ],
              ),
              SettingsGroupLabel(label: l10n.settingsGroupNotifications),
              SettingsGroupedCard(
                children: [
                  SettingsNavRow(
                    icon: Icons.notifications_outlined,
                    title: l10n.notificationsSectionTitle,
                    value: notificationsSummary(l10n, settings),
                    onTap: () => context.push('/settings/notifications'),
                  ),
                ],
              ),
              SettingsGroupLabel(label: l10n.settingsGroupDisplay),
              SettingsGroupedCard(
                children: [
                  SettingsNavRow(
                    icon: Icons.visibility_outlined,
                    title: l10n.displaySectionTitle,
                    value: displaySummary(l10n, settings),
                    onTap: () => context.push('/settings/display'),
                  ),
                ],
              ),
              SettingsGroupLabel(label: l10n.settingsGroupAppearance),
              SettingsGroupedCard(
                children: [
                  SettingsNavRow(
                    icon: Icons.language_outlined,
                    title: l10n.language,
                    value: languageLabel(settings.localeCode),
                    onTap: () => context.push('/settings/language'),
                  ),
                  SettingsNavRow(
                    icon: Icons.palette_outlined,
                    title: l10n.themeMode,
                    value: themeModeLabel(l10n, settings.themeMode),
                    onTap: () => context.push('/settings/theme'),
                  ),
                ],
              ),
              SettingsGroupLabel(label: l10n.settingsGroupReset),
              SettingsGroupedCard(
                children: [
                  SettingsNavRow(
                    icon: Icons.restore_outlined,
                    title: l10n.resetSectionTitle,
                    value: l10n.resetSectionSummary,
                    onTap: () => context.push('/settings/reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
