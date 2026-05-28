import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/cohere_settings_widgets.dart';
import '../../../notifications/data/prayer_notification_service.dart';
import '../../../prayer/domain/prayer_name.dart';
import '../../../prayer/presentation/prayer_name_l10n.dart';
import '../settings_cubit.dart';
import '../settings_state.dart';
import '../../../../l10n/app_localizations.dart';

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
        final settings = state.settings;
        final notifs = settings.notifications;
        final cubit = context.read<SettingsCubit>();

        return CohereDetailScaffold(
          title: l10n.notificationsSectionTitle,
          children: [
            CohereSectionLabel(label: 'Master'),
            CohereToggleRow(
              label: l10n.notificationsMaster,
              sub: l10n.notificationsMasterSubtitle,
              isFirst: true,
              value: notifs.enabled,
              onChanged: (value) async {
                if (value) {
                  await notificationService.initialize();
                  final granted = await notificationService
                      .requestPermissions();
                  if (!context.mounted) return;
                  if (!granted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.notificationsPermissionDenied),
                      ),
                    );
                    return;
                  }
                }
                await cubit.setNotificationsEnabled(value);
              },
            ),
            Opacity(
              opacity: notifs.enabled ? 1.0 : 0.4,
              child: IgnorePointer(
                ignoring: !notifs.enabled,
                child: Column(
                  children: [
                    CohereSectionLabel(label: 'Default sound'),
                    CohereMethodRow(
                      title: 'Silent',
                      sub: 'No audible alert',
                      isSelected: false,
                      isFirst: true,
                      onTap: null,
                    ),
                    CohereMethodRow(
                      title: 'Reminder',
                      sub: 'Standard notification tone',
                      isSelected: true,
                      onTap: null,
                    ),
                    CohereMethodRow(
                      title: 'First sentence',
                      sub: 'Plays "Allāhu akbar"',
                      isSelected: false,
                      onTap: null,
                    ),
                    CohereMethodRow(
                      title: 'Full Adhan',
                      sub: 'Plays complete adhan (~2 min)',
                      isSelected: false,
                      onTap: null,
                    ),
                    CohereSectionLabel(label: 'Per prayer'),
                    for (var i = 0; i < PrayerName.values.length; i++)
                      CohereToggleRow(
                        label: PrayerName.values[i].label(l10n),
                        isFirst: i == 0,
                        value: notifs.isPrayerEnabled(PrayerName.values[i]),
                        onChanged: (v) => cubit.setPrayerNotificationEnabled(
                          PrayerName.values[i],
                          v,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
