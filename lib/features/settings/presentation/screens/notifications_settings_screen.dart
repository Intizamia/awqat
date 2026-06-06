import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme.dart';
import '../../../../core/theme/cohere_colors.dart';
import '../../../../core/widgets/cohere_settings_widgets.dart';
import '../../../notifications/data/prayer_notification_service.dart';
import '../../../prayer/domain/prayer_name.dart';
import '../../../prayer/domain/prayer_notif_type.dart';
import '../../../prayer/presentation/prayer_name_l10n.dart';
import '../../../prayer/presentation/widgets/prayer_notif_disc.dart';
import '../../domain/notification_settings.dart';
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
            _NotifTypesInfograhic(),
            _TestNotifButton(notificationService: notificationService, notifs: notifs),
            Opacity(
              opacity: notifs.enabled ? 1.0 : 0.4,
              child: IgnorePointer(
                ignoring: !notifs.enabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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

class _NotifTypesInfograhic extends StatelessWidget {
  const _NotifTypesInfograhic();

  static const _types = [
    (type: PrayerNotifType.none, desc: 'No alert'),
    (type: PrayerNotifType.reminder, desc: 'System tone'),
    (type: PrayerNotifType.takbir, desc: 'First takbīr'),
    (type: PrayerNotifType.fullAthan, desc: 'Full adhan'),
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final inkMute = CohereColors.inkMute(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);
    final surfElev = CohereColors.surfElevColor(brightness);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ALERT TYPES',
            style: cohereMonoLabel(
              context,
              fontSize: 10,
              letterSpacing: 0.16,
              color: inkMute,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: surfElev,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: rule, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _types.map((entry) {
                final isNone = entry.type == PrayerNotifType.none;
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: isNone
                            ? CustomPaint(
                                painter: PrayerDashedCirclePainter(color: rule),
                                child: Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CustomPaint(
                                      painter: PrayerNotifIconPainter(
                                        type: entry.type,
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
                                      painter: PrayerNotifIconPainter(
                                        type: entry.type,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.type.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: inkDim,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        entry.desc,
                        style: TextStyle(
                          fontSize: 10,
                          color: inkMute,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TestNotifButton extends StatefulWidget {
  const _TestNotifButton({
    required this.notificationService,
    required this.notifs,
  });

  final PrayerNotificationService notificationService;
  final NotificationSettings notifs;

  @override
  State<_TestNotifButton> createState() => _TestNotifButtonState();
}

class _TestNotifButtonState extends State<_TestNotifButton> {
  PrayerName _prayer = PrayerName.dhuhr;
  bool _firing = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final rule = CohereColors.surfRule(brightness);
    final accent = CohereColors.accentColor(brightness);
    final notifType = widget.notifs.notifTypeFor(_prayer);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: rule),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TEST NOTIFICATION',
              style: cohereMonoLabel(
                context,
                fontSize: 10,
                letterSpacing: 0.16,
                color: inkMute,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PrayerName>(
                      value: _prayer,
                      style: TextStyle(fontSize: 14, color: ink, fontFamily: 'Inter'),
                      dropdownColor: CohereColors.surfElevColor(brightness),
                      borderRadius: BorderRadius.circular(10),
                      items: PrayerName.values
                          .map((n) => DropdownMenuItem(
                                value: n,
                                child: Text(n.name),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _prayer = v);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  notifType.label,
                  style: TextStyle(fontSize: 13, color: inkMute),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _firing
                      ? null
                      : () async {
                          setState(() => _firing = true);
                          try {
                            await widget.notificationService
                                .testNotification(_prayer, notifType);
                          } catch (_) {
                            // error already logged in service
                          } finally {
                            if (mounted) setState(() => _firing = false);
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _firing ? rule : accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _firing ? '…' : 'Fire',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _firing ? inkMute : Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
