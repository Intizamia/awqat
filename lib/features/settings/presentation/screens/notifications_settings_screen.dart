import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/cohere_colors.dart';
import '../../../../core/widgets/cohere_settings_widgets.dart';
import '../../../notifications/data/prayer_notification_service.dart';
import '../../../prayer/domain/prayer_name.dart';
import '../../../prayer/presentation/prayer_name_l10n.dart';
import '../../../prayer/presentation/widgets/prayer_notif_disc.dart';
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
        final brightness = Theme.of(context).brightness;
        final ink = CohereColors.inkColor(brightness);
        final rule = CohereColors.surfRule(brightness);

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
                    CohereSectionLabel(label: 'Per prayer'),
                    for (var i = 0; i < PrayerName.values.length; i++)
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: rule, width: 1),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 14, 20, 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                PrayerName.values[i].label(l10n),
                                style: TextStyle(fontSize: 15, color: ink),
                              ),
                            ),
                            PrayerNotifDisc(
                              name: PrayerName.values[i],
                              notifType: notifs.notifTypeFor(
                                PrayerName.values[i],
                              ),
                            ),
                          ],
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
