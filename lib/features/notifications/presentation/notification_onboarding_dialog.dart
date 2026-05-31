import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../data/prayer_notification_service.dart';

Future<void> showNotificationOnboardingDialog(
  BuildContext context,
  PrayerNotificationService notificationService,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) => _NotifOnboardingDialog(
      notificationService: notificationService,
      cubit: context.read<SettingsCubit>(),
    ),
  );
}

class _NotifOnboardingDialog extends StatefulWidget {
  const _NotifOnboardingDialog({
    required this.notificationService,
    required this.cubit,
  });

  final PrayerNotificationService notificationService;
  final SettingsCubit cubit;

  @override
  State<_NotifOnboardingDialog> createState() => _NotifOnboardingDialogState();
}

class _NotifOnboardingDialogState extends State<_NotifOnboardingDialog> {
  bool _loading = false;

  Future<void> _onEnable() async {
    setState(() => _loading = true);
    await widget.notificationService.initialize();
    final granted = await widget.notificationService.requestPermissions();
    await widget.cubit.completeNotificationOnboarding(granted: granted);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _onSkip() async {
    await widget.cubit.completeNotificationOnboarding(granted: false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final surfElev = CohereColors.surfElevColor(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);

    return Dialog(
      backgroundColor: surfElev,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NOTIFICATIONS',
              style: cohereMonoLabel(
                context,
                fontSize: 11,
                letterSpacing: 0.16,
                color: inkMute,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Stay on time with prayer alerts',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: ink,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Get notified at each prayer time with the adhan. You can change the alert type per prayer anytime in Settings.',
              style: TextStyle(fontSize: 15, color: inkMute, height: 1.5),
            ),
            const SizedBox(height: 24),
            Container(height: 1, color: rule),
            const SizedBox(height: 16),
            if (_loading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: accent,
                    ),
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _onEnable,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Enable notifications',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: surfPage,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _onSkip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Not now',
                          style: TextStyle(fontSize: 15, color: inkMute),
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
