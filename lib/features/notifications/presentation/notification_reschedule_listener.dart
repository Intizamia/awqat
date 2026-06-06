import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/prayer_notification_service.dart';
import '../../prayer/presentation/prayer_times_cubit.dart';
import '../../prayer/presentation/prayer_times_state.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../settings/presentation/settings_state.dart';

/// Reschedules local prayer notifications when settings or times change.
class NotificationRescheduleListener extends StatefulWidget {
  const NotificationRescheduleListener({
    required this.notificationService,
    required this.child,
    super.key,
  });

  final PrayerNotificationService notificationService;
  final Widget child;

  @override
  State<NotificationRescheduleListener> createState() =>
      _NotificationRescheduleListenerState();
}

class _NotificationRescheduleListenerState
    extends State<NotificationRescheduleListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _syncPermission();
      _reschedule();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncPermission().then((_) => _reschedule());
    }
  }

  Future<void> _syncPermission() async {
    final settingsState = context.read<SettingsCubit>().state;
    if (settingsState.isLoading) return;
    if (!settingsState.settings.notifications.enabled) return;

    final granted = await widget.notificationService.hasPermission();
    if (!granted && mounted) {
      await context.read<SettingsCubit>().setNotificationsEnabled(false);
    }
  }

  void _reschedule() {
    final settingsState = context.read<SettingsCubit>().state;
    if (settingsState.isLoading) return;
    widget.notificationService.reschedule(settingsState.settings);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (prev, curr) =>
              !curr.isLoading &&
              (prev.settings != curr.settings ||
                  prev.isLoading != curr.isLoading),
          listener: (context, state) => _reschedule(),
        ),
        BlocListener<PrayerTimesCubit, PrayerTimesState>(
          listenWhen: (prev, curr) =>
              prev.schedule != curr.schedule && !curr.isLoading,
          listener: (context, state) => _reschedule(),
        ),
      ],
      child: widget.child,
    );
  }
}
