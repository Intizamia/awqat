import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:awqat/app/app.dart';
import 'package:awqat/features/notifications/data/prayer_notification_planner.dart';
import 'package:awqat/features/notifications/domain/scheduled_prayer_notification.dart';
import 'package:awqat/features/prayer/data/adhan_calculation_engine.dart';
import 'package:awqat/features/settings/domain/app_settings.dart';
import 'package:awqat/l10n/app_localizations.dart';

const _channelId = 'prayer_times';
const _channelName = 'Prayer times';

class PrayerNotificationService {
  PrayerNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    AdhanCalculationEngine? engine,
    this.skipPlatformCalls = false,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _engine = engine ?? AdhanCalculationEngine();

  /// Skips plugin calls (widget tests).
  final bool skipPlatformCalls;

  final FlutterLocalNotificationsPlugin _plugin;
  final AdhanCalculationEngine _engine;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    if (skipPlatformCalls) {
      _initialized = true;
      return;
    }

    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings: settings);
    await _ensureAndroidChannel();
    _initialized = true;
  }

  Future<void> _ensureAndroidChannel() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'Alerts when prayer times begin',
        importance: Importance.high,
      ),
    );
  }

  Future<bool> requestPermissions() async {
    if (skipPlatformCalls) return true;
    var granted = true;

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final notificationGranted =
          await android.requestNotificationsPermission() ?? false;
      await android.requestExactAlarmsPermission();
      granted = notificationGranted;
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final iosGranted = await ios.requestPermissions(alert: true, sound: true);
      granted = iosGranted ?? granted;
    }

    return granted;
  }

  Future<void> reschedule(AppSettings settings) async {
    await initialize();
    if (skipPlatformCalls) return;
    await _plugin.cancelAll();

    if (!settings.notifications.enabled || !settings.setup.isComplete) {
      return;
    }

    final location = settings.location;
    if (location == null) return;

    final l10n = await AppLocalizations.delegate.load(
      AwqatApp.localeFromCode(settings.localeCode),
    );
    final planned = planPrayerNotifications(
      settings: settings,
      engine: _engine,
      l10n: l10n,
    );

    final tzLocation = tz.getLocation(location.timeZoneId);

    for (final item in planned) {
      await _scheduleOne(item, tzLocation);
    }
  }

  Future<void> _scheduleOne(
    ScheduledPrayerNotification item,
    tz.Location tzLocation,
  ) async {
    final scheduled = tz.TZDateTime.from(item.scheduledAt, tzLocation);
    if (!scheduled.isAfter(tz.TZDateTime.now(tzLocation))) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Alerts when prayer times begin',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _plugin.zonedSchedule(
        id: item.id,
        title: item.title,
        body: item.body,
        scheduledDate: scheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e, st) {
      debugPrint('PrayerNotificationService: schedule failed: $e\n$st');
    }
  }
}
