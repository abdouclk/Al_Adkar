// ignore_for_file: avoid_print

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// The plugin instance is attached from main.dart to avoid duplicates
class NotificationHelper {
  static FlutterLocalNotificationsPlugin? _plugin;

  static void attach(FlutterLocalNotificationsPlugin plugin) {
    _plugin = plugin;
  }

  static bool get isAttached => _plugin != null;

  // Ensure notifications permission is granted (Android 13+)
  static Future<bool> ensureNotificationPermissions() async {
    final androidImpl = _plugin?.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final enabled = await androidImpl?.areNotificationsEnabled() ?? true;
    if (enabled) return true;
    final granted = await androidImpl?.requestNotificationsPermission() ?? true;
    return granted;
  }

  static Future<void> createPrayerChannelIfNeeded() async {
    final androidImpl = _plugin?.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        'prayer_times_v2',
        'التذكيرات',
        description: 'إشعارات التذكير بالتطبيق',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
    );
  }

  static Future<void> scheduleAt({
    required int id,
    required DateTime time,
    required String title,
    required String body,
    String? payload,
    String channelId = 'prayer_times_v2',
    String channelName = 'التذكيرات',
    String channelDescription = 'إشعارات التذكير بالتطبيق',
  }) async {
    if (_plugin == null) {
      throw Exception('Notification system not initialized yet');
    }

    final utcTime = time.isUtc ? time : time.toUtc();
    final tzTime = tz.TZDateTime.from(utcTime, tz.local);
    final now = tz.TZDateTime.now(tz.local);

    if (tzTime.isBefore(now)) return;

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      visibility: NotificationVisibility.public,
      ticker: 'تذكير',
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(body),
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    try {
      await _plugin!.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        details,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      print('Failed to schedule notification: $e');
    }
  }

  static Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'prayer_times_v2',
  }) async {
    if (_plugin == null) {
      throw Exception('Notification system not initialized yet');
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      'التذكيرات',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    try {
      await _plugin!.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
        payload: payload,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }
}
