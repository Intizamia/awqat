import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../../../app/app.dart';
import 'prayer_notification_planner.dart';
import '../domain/scheduled_prayer_notification.dart';
import '../../prayer/data/adhan_calculation_engine.dart';
import '../../prayer/domain/prayer_name.dart';
import '../../prayer/domain/prayer_notif_type.dart';
import '../../settings/domain/app_settings.dart';
import '../../../l10n/app_localizations.dart';

// Android channel IDs — each has a fixed sound; never reuse with a different sound.
// Bump suffix (_v2, _v3 …) whenever sound or importance changes to force channel recreation.
const _chSilent = 'prayer_silent_v2';
const _chReminder = 'prayer_reminder_v2';
const _chFirst = 'prayer_athan_takbir_v2';
const _chFull = 'prayer_athan_full_v2';
const _chFajr = 'prayer_athan_fajr_v2';

class PrayerNotificationService {
  PrayerNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    AdhanCalculationEngine? engine,
    this.skipPlatformCalls = false,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _engine = engine ?? AdhanCalculationEngine();

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
    await _ensureAndroidChannels();
    _initialized = true;
  }

  Future<void> _ensureAndroidChannels() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _chSilent,
        'Prayer (silent)',
        description: 'Prayer time badge — no sound',
        importance: Importance.defaultImportance,
        playSound: false,
        enableVibration: false,
      ),
    );
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _chReminder,
        'Prayer (reminder)',
        description: 'Prayer time with default notification tone',
        importance: Importance.high,
      ),
    );
    await android.createNotificationChannel(
      AndroidNotificationChannel(
        _chFirst,
        'Prayer (takbīr)',
        description: 'Plays "Allāhu akbar"',
        importance: Importance.high,
        sound: const RawResourceAndroidNotificationSound('athan_takbir'),
      ),
    );
    await android.createNotificationChannel(
      AndroidNotificationChannel(
        _chFull,
        'Prayer (full athan)',
        description: 'Plays complete adhan',
        importance: Importance.high,
        sound: const RawResourceAndroidNotificationSound('athan_full'),
      ),
    );
    await android.createNotificationChannel(
      AndroidNotificationChannel(
        _chFajr,
        'Fajr (full athan)',
        description: 'Plays complete Fajr adhan',
        importance: Importance.high,
        sound: const RawResourceAndroidNotificationSound('athan_fajr'),
      ),
    );
  }

  Future<bool> hasPermission() async {
    if (skipPlatformCalls) return true;
    await initialize();

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? true;
    }

    // iOS: no revocation check available without extra plugin; assume granted.
    return true;
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

    final details = _buildDetails(item.notifType, item.prayer);

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

  Future<void> testNotification(PrayerName prayer, PrayerNotifType type) async {
    if (type == PrayerNotifType.none) return;
    await initialize();
    if (skipPlatformCalls) return;
    try {
      final details = _buildDetails(type, prayer);
      await _plugin.show(
        id: 9999,
        title: 'Test: ${type.name}',
        body: prayer.name,
        notificationDetails: details,
      );
    } catch (e, st) {
      debugPrint('PrayerNotificationService: testNotification failed: $e\n$st');
      rethrow;
    }
  }

  NotificationDetails _buildDetails(PrayerNotifType type, PrayerName prayer) {
    return NotificationDetails(
      android: _androidDetails(type, prayer),
      iOS: _iosDetails(type),
    );
  }

  AndroidNotificationDetails _androidDetails(
    PrayerNotifType type,
    PrayerName prayer,
  ) {
    switch (type) {
      case PrayerNotifType.none:
        return const AndroidNotificationDetails(
          _chSilent,
          'Prayer (silent)',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          playSound: false,
          enableVibration: false,
        );
      case PrayerNotifType.reminder:
        return const AndroidNotificationDetails(
          _chReminder,
          'Prayer (reminder)',
          importance: Importance.high,
          priority: Priority.high,
        );
      case PrayerNotifType.takbir:
        return const AndroidNotificationDetails(
          _chFirst,
          'Prayer (takbīr)',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('athan_takbir'),
          playSound: true,
        );
      case PrayerNotifType.fullAthan:
        final isFajr = prayer == PrayerName.fajr;
        return AndroidNotificationDetails(
          isFajr ? _chFajr : _chFull,
          isFajr ? 'Fajr (full athan)' : 'Prayer (full athan)',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound(
            isFajr ? 'athan_fajr' : 'athan_full',
          ),
          playSound: true,
        );
    }
  }

  DarwinNotificationDetails _iosDetails(PrayerNotifType type) {
    switch (type) {
      case PrayerNotifType.none:
        return const DarwinNotificationDetails(presentSound: false);
      case PrayerNotifType.reminder:
        return const DarwinNotificationDetails();
      case PrayerNotifType.takbir:
      case PrayerNotifType.fullAthan:
        return const DarwinNotificationDetails(
          sound: 'athan_takbir.wav',
        );
    }
  }
}
