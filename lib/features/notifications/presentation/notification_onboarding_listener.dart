import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../settings/presentation/settings_state.dart';
import '../data/prayer_notification_service.dart';
import 'notification_onboarding_dialog.dart';

class NotificationOnboardingListener extends StatelessWidget {
  const NotificationOnboardingListener({
    required this.notificationService,
    required this.child,
    super.key,
  });

  final PrayerNotificationService notificationService;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.isLoading && !curr.isLoading,
      listener: (ctx, state) {
        if (!state.settings.notifications.onboardingDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ctx.mounted) {
              showNotificationOnboardingDialog(ctx, notificationService);
            }
          });
        }
      },
      child: child,
    );
  }
}
