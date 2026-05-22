import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/notifications/data/prayer_notification_service.dart';
import 'package:times/features/prayer/domain/prayer_name.dart';
import 'package:times/features/prayer/presentation/prayer_name_l10n.dart';
import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:times/l10n/app_localizations.dart';

class NotificationSettingsSection extends StatelessWidget {
  const NotificationSettingsSection({
    required this.settings,
    required this.notificationService,
    super.key,
  });

  final AppSettings settings;
  final PrayerNotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: l10n.notificationsSectionTitle,
          subtitle: l10n.notificationsSectionSubtitle,
        ),
        SwitchListTile(
          title: Text(l10n.notificationsMaster),
          subtitle: Text(l10n.notificationsMasterSubtitle),
          value: settings.notifications.enabled,
          onChanged: (value) async {
            if (value) {
              await notificationService.initialize();
              final granted = await notificationService.requestPermissions();
              if (!context.mounted) return;
              if (!granted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.notificationsPermissionDenied)),
                );
                return;
              }
            }
            await cubit.setNotificationsEnabled(value);
          },
        ),
        if (settings.notifications.enabled) ...[
          for (final prayer in PrayerName.values)
            SwitchListTile(
              title: Text(prayer.label(l10n)),
              value: settings.notifications.isPrayerEnabled(prayer),
              onChanged: (value) =>
                  cubit.setPrayerNotificationEnabled(prayer, value),
            ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}
