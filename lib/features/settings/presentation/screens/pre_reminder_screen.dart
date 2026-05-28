import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/cohere_colors.dart';
import '../../../../core/widgets/cohere_settings_widgets.dart';
import '../settings_cubit.dart';
import '../settings_state.dart';

const _kOptions = [5, 10, 15, 20, 25, 30];

class _NotificationsOffBanner extends StatelessWidget {
  const _NotificationsOffBanner({required this.brightness});
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final inkMute = CohereColors.inkMute(brightness);
    final rule = CohereColors.surfRule(brightness);

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: rule),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: inkMute),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Notifications are off. Enable them in Settings → Notifications for reminders to fire.',
              style: TextStyle(fontSize: 13, color: inkMute, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class PreReminderScreen extends StatelessWidget {
  const PreReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final notifs = state.settings.notifications;
        final cubit = context.read<SettingsCubit>();
        final brightness = Theme.of(context).brightness;

        return CohereDetailScaffold(
          title: 'Pre-prayer reminder',
          children: [
            if (!notifs.enabled) _NotificationsOffBanner(brightness: brightness),
            CohereSectionLabel(label: 'Enable'),
            CohereToggleRow(
              label: 'Pre-prayer reminder',
              sub: 'Notify before each prayer time',
              isFirst: true,
              value: notifs.preReminderEnabled,
              onChanged: cubit.setPreReminderEnabled,
            ),
            CohereSectionLabel(label: 'Reminder time'),
            for (var i = 0; i < _kOptions.length; i++)
              Opacity(
                opacity: notifs.preReminderEnabled ? 1.0 : 0.4,
                child: CohereMethodRow(
                  title: '${_kOptions[i]} minutes before',
                  isSelected: notifs.preReminderEnabled &&
                      notifs.preReminderMinutes == _kOptions[i],
                  isFirst: i == 0,
                  onTap: notifs.preReminderEnabled
                      ? () => cubit.setPreReminderMinutes(_kOptions[i])
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }
}
