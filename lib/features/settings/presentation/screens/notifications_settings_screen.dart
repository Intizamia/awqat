import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/notifications/data/prayer_notification_service.dart';
import 'package:times/features/settings/presentation/sections/notification_settings_section.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/features/settings/presentation/widgets/settings_detail_scaffold.dart';
import 'package:times/l10n/app_localizations.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({
    required this.notificationService,
    super.key,
  });

  final PrayerNotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return SettingsDetailScaffold(
            title: l10n.notificationsSectionTitle,
            subtitle: l10n.notificationsSectionSubtitle,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return SettingsDetailScaffold(
          title: l10n.notificationsSectionTitle,
          subtitle: l10n.notificationsSectionSubtitle,
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              SettingsGroupedCard(
                children: [
                  NotificationSettingsBody(
                    settings: state.settings,
                    notificationService: notificationService,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
