import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// The plugin instance is attached from main.dart to avoid duplicates
class NotificationHelper {
  static FlutterLocalNotificationsPlugin? _plugin;
  static void attach(FlutterLocalNotificationsPlugin plugin) {
    _plugin = plugin;
  }

  // Ensure notifications permission is granted (Android 13+)
  static Future<bool> ensureNotificationPermissions() async {
    final androidImpl = _plugin?.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final enabled = await androidImpl?.areNotificationsEnabled() ?? true;
    if (enabled) return true;
    final granted = await androidImpl?.requestNotificationsPermission() ?? true;
    return granted;
  }

  // Request exact alarm permission (Android 12+)
  static Future<void> requestExactAlarmsPermission() async {
    final androidImpl = _plugin?.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestExactAlarmsPermission();
  }

  static Future<void> createPrayerChannelIfNeeded() async {
    final androidImpl = _plugin?.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        'prayer_times',
        'أوقات الصلاة',
        description: 'تنبيه بموعد الصلاة القادمة',
        importance: Importance.high,
      ),
    );
  }

  static Future<void> scheduleAt({
    required int id,
    required DateTime time,
    required String title,
    required String body,
    String? payload,
    String channelId = 'prayer_times',
    String channelName = 'أوقات الصلاة',
    String channelDescription = 'تنبيه بموعد الصلاة القادمة',
  }) async {
    if (_plugin == null) return;
    // Convert to TZ time in local zone
    final tzTime = tz.TZDateTime.from(time, tz.local);

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);

    await _plugin!.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
