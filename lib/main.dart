// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, use_super_parameters, avoid_print, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' show TZDateTime;

// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:al_adkar/alyaoum/house.dart';
import 'package:al_adkar/sabah_massae.dart';
import 'package:al_adkar/alyaoum/sabah.dart' as sabah_screen;
import 'package:al_adkar/alyaoum/massae.dart' as massae_screen;
import 'package:al_adkar/a3ibadat.dart';
import 'package:al_adkar/contact.dart';
import 'package:al_adkar/divers_adkar.dart';
import 'package:al_adkar/duaa_from_quran.dart';
import 'package:al_adkar/duaa_from_sunnah.dart';
import 'package:al_adkar/kounouz_maghfira.dart';
import 'package:al_adkar/quibla.dart';
import 'package:al_adkar/tassbih.dart';
import 'package:al_adkar/favorites_screen.dart';
import 'package:al_adkar/islamic_calendar.dart';
import 'package:al_adkar/services/daily_reminder_service.dart';
import 'package:al_adkar/settings_screen.dart';
import 'package:al_adkar/quran_radio.dart';
import 'package:al_adkar/prayer_times.dart';
import 'package:al_adkar/services/notification_helper.dart';
// Notifications are provided by services/notification_helper.dart

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // Timezone init
  tz.initializeTimeZones();
  
  // Set timezone to local - try multiple methods for robustness
  try {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;
    final hours = offset.inHours;
    
    // Try to get actual timezone name first
    try {
      final locationNames = tz.timeZoneDatabase.locations.keys.toList();
      // Common timezone patterns
      final possibleNames = [
        'Africa/Casablanca',  // Morocco
        'Africa/Algiers',     // Algeria  
        'Africa/Tunis',       // Tunisia
        'Africa/Cairo',       // Egypt
        'Asia/Riyadh',        // Saudi Arabia
        'Asia/Dubai',         // UAE
      ];
      
      // Try to find a matching timezone
      for (final name in possibleNames) {
        if (locationNames.contains(name)) {
          final location = tz.getLocation(name);
          final testTime = tz.TZDateTime.from(now, location);
          if (testTime.timeZoneOffset == offset) {
            tz.setLocalLocation(location);
            if (kDebugMode) debugPrint('Using timezone: $name');
            return;
          }
        }
      }
    } catch (_) {
      // Fall through to offset-based timezone
    }
    
    // Fallback: Map offset to Etc/GMT format (note reversed sign convention)
    final String etc =
        'Etc/GMT${hours == 0 ? '' : (hours > 0 ? '-$hours' : '+${hours.abs()}')}';
    tz.setLocalLocation(tz.getLocation(etc));
    if (kDebugMode) debugPrint('Using timezone: $etc (offset: ${offset.inHours}h)');
  } catch (e) {
    if (kDebugMode) debugPrint('Timezone setup failed, using UTC: $e');
    tz.setLocalLocation(tz.UTC);
  }

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      try {
        final payload = response.payload;
        if (kDebugMode) {
          debugPrint('Notification tapped with payload: $payload');
        }
        
        // Only navigate if we have a valid navigator and specific payload
        if (navigatorKey.currentState != null && navigatorKey.currentState!.mounted) {
          if (payload == 'sabah') {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => sabah_screen.Sabah()),
            );
          } else if (payload == 'massae') {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => massae_screen.Massae()),
            );
          }
          // Ignore test payloads and other payloads - don't navigate
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error handling notification response: $e');
        }
        // Don't crash - just log the error
      }
    },
  );

  // Android 13+ runtime permission for notifications
  final androidImpl =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  // n block or fail silently
  androidImpl?.requestExactAlarmsPermission();
  androidImpl?.requestNotificationsPermission();

  // Proactively create channels with desired importance so Android uses them
  try {
    // Main channel for 4 daily adhkar notifications
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        'adhkar_daily',
        'الأذكار اليومية',
        description: 'تذكير يومي بالأذكار كل 6 ساعات (00:00, 06:00, 12:00, 18:00)',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
    );
    
    // Keep prayer times channel
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        'prayer_times',
        'أوقات الصلاة',
        description: 'تنبيه بموعد الصلاة القادمة',
        importance: Importance.high,
      ),
    );
    
    // Test channel for debugging
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        'adhkar_test',
        'اختبار الإشعارات',
        description: 'قناة لاختبار ظهور الإشعارات فورًا',
        importance: Importance.high,
      ),
    );
    
    // 2-hour reminders channel (every 2 hours from 4am to 10pm)
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        'adhkar_2hour',
        'تذكير كل ساعتين',
        description: 'تذكير بالأذكار كل ساعتين من 04:00 صباحًا إلى 10:00 مساءً',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      ),
    );
  } catch (e) {
    // ignore channel creation errors
    if (kDebugMode) {
      debugPrint('Channel creation error: $e');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Custom error handler to suppress TextStyle interpolation errors during theme changes
  FlutterError.onError = (FlutterErrorDetails details) {
    // Check if error is the TextStyle inherit mismatch during theme transition
    final exception = details.exception.toString();
    if (exception.contains('Failed to interpolate TextStyles') || 
        exception.contains('inherit') ||
        exception.contains('TextStyle')) {
      // Silently ignore theme transition errors
      if (kDebugMode) {
        debugPrint('Theme transition error suppressed: $exception');
      }
      return;
    }
    // For all other errors, show the default red error screen
    FlutterError.presentError(details);
  };

  // Also catch errors during build phase
  ErrorWidget.builder = (FlutterErrorDetails details) {
    final exception = details.exception.toString();
    if (exception.contains('Failed to interpolate TextStyles') || 
        exception.contains('inherit') ||
        exception.contains('TextStyle')) {
      // Return empty container instead of red error screen
      return Container();
    }
    // Show default error widget for other errors
    return ErrorWidget(details.exception);
  };

  // Initialize in background; never block app launch
  _initializeAppServices();

  runApp(const MyApp());
}

Future<void> _initializeAppServices() async {
  try {
    await initNotifications();
    NotificationHelper.attach(flutterLocalNotificationsPlugin);
    // Auto-schedule 4 daily notifications - no user toggle needed
    await _scheduleAllDailyNotifications();
    
    // Restore 2-hour notifications if they were previously enabled
    await _restore2HourNotifications();
  } catch (e) {
    // Log error but don't crash
    if (kDebugMode) {
      debugPrint('Notification initialization failed: $e');
    }
  }
}

// Restore 2-hour notifications from saved preferences
Future<void> _restore2HourNotifications() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('adhkar_2hour_enabled') ?? false;
    
    if (enabled) {
      if (kDebugMode) {
        debugPrint('Restoring 2-hour notifications (previously enabled)...');
      }
      
      // Check permissions silently
      final granted = await ensureNotificationPermissions();
      if (granted) {
        await schedule2HourNotifications();
        if (kDebugMode) {
          debugPrint('✅ 2-hour notifications restored successfully');
        }
      } else {
        if (kDebugMode) {
          debugPrint('❌ Cannot restore 2-hour notifications - permissions not granted');
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Error restoring 2-hour notifications: $e');
    }
  }
}

// Schedule 4 daily notifications at 00:00, 06:00, 12:00, 18:00
Future<void> _scheduleAllDailyNotifications() async {
  try {
    // Request permissions silently - don't block on failure
    final androidImpl =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    try {
      await androidImpl?.requestNotificationsPermission();
      await androidImpl?.requestExactAlarmsPermission();
    } catch (e) {
      if (kDebugMode) debugPrint('Permission request failed (will continue): $e');
    }

    // Schedule 4 times: midnight, morning, noon, evening
    await _scheduleSingleNotification(
      id: 1001,
      hour: 0,
      minute: 0,
      title: 'أذكار منتصف الليل',
      body: 'حان وقت الأذكار - اضغط للقراءة',
      payload: 'sabah', // Navigate to sabah screen
    );

    await _scheduleSingleNotification(
      id: 1002,
      hour: 6,
      minute: 0,
      title: 'أذكار الصباح',
      body: 'حان وقت أذكار الصباح - اضغط للقراءة',
      payload: 'sabah',
    );

    await _scheduleSingleNotification(
      id: 1003,
      hour: 12,
      minute: 0,
      title: 'أذكار الظهيرة',
      body: 'حان وقت الأذكار - اضغط للقراءة',
      payload: 'sabah',
    );

    await _scheduleSingleNotification(
      id: 1004,
      hour: 18,
      minute: 0,
      title: 'أذكار المساء',
      body: 'حان وقت أذكار المساء - اضغط للقراءة',
      payload: 'massae',
    );

    if (kDebugMode) {
      debugPrint('✅ All 4 daily notifications scheduled (00:00, 06:00, 12:00, 18:00)');
      debugPendingNotifications();
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Failed to schedule daily notifications: $e');
    }
    // Don't crash - app still works without notifications
  }
}

Future<void> _scheduleSingleNotification({
  required int id,
  required int hour,
  required int minute,
  required String title,
  required String body,
  String? payload,
}) async {
  final scheduledTime = _nextInstanceOfTZTime(TimeOfDay(hour: hour, minute: minute));
  
  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'adhkar_daily',
    'الأذكار اليومية',
    channelDescription: 'تذكير يومي بالأذكار كل 6 ساعات',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    fullScreenIntent: true,
  );
  
  final NotificationDetails details = NotificationDetails(android: androidDetails);

  // Cancel existing notification with same ID
  await flutterLocalNotificationsPlugin.cancel(id);

  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
    if (kDebugMode) {
      debugPrint('Scheduled notification $id at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
    }
  } catch (e) {
    if (kDebugMode) debugPrint('Failed to schedule notification $id: $e');
    // Don't rethrow - try to schedule others
  }
}

// Use shared instance from NotificationHelper

TZDateTime _nextInstanceOfTZTime(TimeOfDay time) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );
  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

// Ensure notifications permission is granted (Android 13+)
Future<bool> ensureNotificationPermissions() async {
  final androidImpl =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  // Check notification permission
  final enabled = await androidImpl?.areNotificationsEnabled() ?? true;
  if (!enabled) {
    final granted =
        await androidImpl?.requestNotificationsPermission() ?? false;
    if (!granted) {
      if (kDebugMode) debugPrint('Notification permission denied');
      return false;
    }
  }

  // Check exact alarm permission (Android 12+)
  if (androidImpl != null) {
    try {
      final canSchedule =
          await androidImpl.canScheduleExactNotifications() ?? false;
      if (!canSchedule) {
        if (kDebugMode)
          debugPrint('Exact alarm permission not granted - requesting...');
        await androidImpl.requestExactAlarmsPermission();
        // Check again after request
        final canScheduleAfter =
            await androidImpl.canScheduleExactNotifications() ?? false;
        if (!canScheduleAfter) {
          if (kDebugMode) debugPrint('Exact alarm permission still denied');
          return false;
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error checking exact alarm permission: $e');
      // Continue anyway for older Android versions
    }
  }

  return true;
}

Future<void> scheduleMorning(
    {int hour = 6, int minute = 30, String sound = 'default'}) async {
  final scheduledTime =
      _nextInstanceOfTZTime(TimeOfDay(hour: hour, minute: minute));
  if (kDebugMode) {
    debugPrint('Scheduling morning notification for: $scheduledTime');
  }

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'adhkar_morning',
    'أذكار الصباح',
    channelDescription: 'تذكير يومي بأذكار الصباح',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    fullScreenIntent: true,
    sound:
        sound == 'default' ? null : RawResourceAndroidNotificationSound(sound),
  );
  final NotificationDetails details =
      NotificationDetails(android: androidDetails);

  // Cancel any existing morning notification first
  await flutterLocalNotificationsPlugin.cancel(1001);

  try {
    // Schedule with matchDateTimeComponents.time for daily repeat at the same time
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1001,
      'تذكير الأذكار',
      'اضغط لقراءة أذكار الصباح',
      scheduledTime,
      details,
      payload: 'sabah',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    if (kDebugMode) {
      debugPrint('Morning notification scheduled successfully at $scheduledTime');
      debugPendingNotifications();
    }
  } catch (e) {
    if (kDebugMode) debugPrint('Failed to schedule morning notification: $e');
    rethrow; // Rethrow to allow caller to handle error
  }
}

Future<void> scheduleEvening(
    {int hour = 18, int minute = 30, String sound = 'default'}) async {
  final scheduledTime =
      _nextInstanceOfTZTime(TimeOfDay(hour: hour, minute: minute));
  if (kDebugMode) {
    debugPrint('Scheduling evening notification for: $scheduledTime');
  }

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'adhkar_evening',
    'أذكار المساء',
    channelDescription: 'تذكير يومي بأذكار المساء',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    fullScreenIntent: true,
    sound:
        sound == 'default' ? null : RawResourceAndroidNotificationSound(sound),
  );
  final NotificationDetails details =
      NotificationDetails(android: androidDetails);

  // Cancel any existing evening notification first
  await flutterLocalNotificationsPlugin.cancel(1002);

  try {
    // Schedule with matchDateTimeComponents.time for daily repeat at the same time
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1002,
      'تذكير الأذكار',
      'اضغط لقراءة أذكار المساء',
      scheduledTime,
      details,
      payload: 'massae',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    if (kDebugMode) {
      debugPrint('Evening notification scheduled successfully at $scheduledTime');
      debugPendingNotifications();
    }
  } catch (e) {
    if (kDebugMode) debugPrint('Failed to schedule evening notification: $e');
    rethrow; // Rethrow to allow caller to handle error
  }
}

Future<void> cancelMorning() async =>
    flutterLocalNotificationsPlugin.cancel(1001);
Future<void> cancelEvening() async =>
    flutterLocalNotificationsPlugin.cancel(1002);

// Test notification - fires immediately
Future<bool> sendTestNotification() async {
  if (kDebugMode) debugPrint('Sending test notification...');
  
  final androidImpl =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  // For immediate notifications, only check basic notification permission
  // (don't need exact alarm permission)
  try {
    final enabled = await androidImpl?.areNotificationsEnabled() ?? true;
    if (!enabled) {
      if (kDebugMode) debugPrint('Notifications not enabled, requesting...');
      final granted = await androidImpl?.requestNotificationsPermission() ?? false;
      if (!granted) {
        if (kDebugMode) debugPrint('Notification permission denied by user');
        return false;
      }
    }
  } catch (e) {
    if (kDebugMode) debugPrint('Error checking notification permission: $e');
    // Continue anyway - might work on older Android versions
  }

  // Ensure test channel exists
  try {
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        'adhkar_test',
        'اختبار الإشعارات',
        description: 'قناة لاختبار ظهور الإشعارات فورًا',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
    );
    if (kDebugMode) debugPrint('Test channel created/updated');
  } catch (e) {
    if (kDebugMode) debugPrint('Error creating test channel: $e');
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'adhkar_test',
    'اختبار الإشعارات',
    channelDescription: 'إشعار تجريبي للتأكد من عمل الإشعارات',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    showWhen: true,
    icon: '@mipmap/ic_launcher',
  );
  const NotificationDetails details =
      NotificationDetails(android: androidDetails);
  
  try {
    await flutterLocalNotificationsPlugin.show(
      9999,
      'اختبار الإشعارات ✓',
      'إذا ظهر هذا الإشعار، فإن الإشعارات تعمل بشكل صحيح!',
      details,
      payload: 'test',
    );
    if (kDebugMode) debugPrint('✅ Test notification sent successfully');
    return true;
  } catch (e) {
    if (kDebugMode) debugPrint('❌ Error sending test notification: $e');
    return false;
  }
}

// Helper function to check pending notifications for debugging
Future<void> debugPendingNotifications() async {
  if (kDebugMode) {
    final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    debugPrint('=== PENDING NOTIFICATIONS DEBUG ===');
    debugPrint('Total pending: ${pending.length}');
    for (final notif in pending) {
      debugPrint('ID: ${notif.id}, Title: ${notif.title}, Body: ${notif.body}');
    }
    debugPrint('===================================');
  }
}

// Test scheduled notification - fires after 10 seconds
Future<bool> sendScheduledTestNotification() async {
  if (kDebugMode) debugPrint('Scheduling test notification for 10 seconds from now...');
  
  final granted = await ensureNotificationPermissions();
  if (!granted) {
    if (kDebugMode) debugPrint('Permissions not granted');
    return false;
  }

  final testTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
  if (kDebugMode) {
    debugPrint('Current time: ${tz.TZDateTime.now(tz.local)}');
    debugPrint('Scheduled time: $testTime');
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'adhkar_test',
    'اختبار الإشعارات',
    channelDescription: 'إشعار تجريبي مجدول',
    importance: Importance.max,
    priority: Priority.high,
    enableLights: true,
    fullScreenIntent: true,
  );
  const NotificationDetails details = NotificationDetails(android: androidDetails);

  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      9998,
      'اختبار الإشعار المجدول',
      'إذا ظهر هذا الإشعار، فإن الإشعارات المجدولة تعمل!',
      testTime,
      details,
      payload: 'test_scheduled',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    if (kDebugMode) debugPrint('Scheduled test notification successfully');
    await debugPendingNotifications();
    return true;
  } catch (e) {
    if (kDebugMode) debugPrint('Failed to schedule test notification: $e');
    return false;
  }
}

// Schedule 2-hour repeating notifications (4am to 10pm)
Future<void> schedule2HourNotifications() async {
  try {
    if (kDebugMode) debugPrint('⏰ Starting to schedule 2-hour notifications...');
    
    final granted = await ensureNotificationPermissions();
    if (!granted) {
      if (kDebugMode) debugPrint('❌ Permissions not granted for 2-hour notifications');
      throw Exception('Notification permissions not granted');
    }

    // Times: 4am, 6am, 8am, 10am, 12pm, 2pm, 4pm, 6pm, 8pm, 10pm
    final times = [
      {'hour': 4, 'minute': 0, 'id': 2001, 'title': 'تذكير الأذكار'},
      {'hour': 6, 'minute': 0, 'id': 2002, 'title': 'أذكار الصباح'},
      {'hour': 8, 'minute': 0, 'id': 2003, 'title': 'تذكير الأذكار'},
      {'hour': 10, 'minute': 0, 'id': 2004, 'title': 'تذكير الأذكار'},
      {'hour': 12, 'minute': 0, 'id': 2005, 'title': 'تذكير الأذكار'},
      {'hour': 14, 'minute': 0, 'id': 2006, 'title': 'تذكير الأذكار'},
      {'hour': 16, 'minute': 0, 'id': 2007, 'title': 'تذكير الأذكار'},
      {'hour': 18, 'minute': 0, 'id': 2008, 'title': 'أذكار المساء'},
      {'hour': 20, 'minute': 0, 'id': 2009, 'title': 'تذكير الأذكار'},
      {'hour': 22, 'minute': 0, 'id': 2010, 'title': 'تذكير الأذكار'},
    ];

    int successCount = 0;
    for (final time in times) {
      final success = await _schedule2HourNotification(
        id: time['id'] as int,
        hour: time['hour'] as int,
        minute: time['minute'] as int,
        title: time['title'] as String,
      );
      if (success) successCount++;
    }

    if (kDebugMode) {
      debugPrint('✅ Successfully scheduled $successCount/${times.length} 2-hour notifications');
      await debugPendingNotifications();
    }
  } catch (e) {
    if (kDebugMode) debugPrint('❌ Error scheduling 2-hour notifications: $e');
    rethrow;
  }
}

Future<bool> _schedule2HourNotification({
  required int id,
  required int hour,
  required int minute,
  required String title,
}) async {
  final scheduledTime = _nextInstanceOfTZTime(TimeOfDay(hour: hour, minute: minute));

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'adhkar_2hour',
    'تذكير كل ساعتين',
    channelDescription: 'تذكير بالأذكار كل ساعتين من 04:00 صباحًا إلى 10:00 مساءً',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    fullScreenIntent: true,
    showWhen: true,
    icon: '@mipmap/ic_launcher',
  );

  const NotificationDetails details = NotificationDetails(android: androidDetails);

  // Cancel existing notification with same ID
  await flutterLocalNotificationsPlugin.cancel(id);

  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      'حان وقت الأذكار - اضغط للقراءة',
      scheduledTime,
      details,
      payload: 'sabah',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    if (kDebugMode) {
      final now = tz.TZDateTime.now(tz.local);
      debugPrint('  ✓ Scheduled #$id at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} (next: ${scheduledTime.toString().split(' ')[1].substring(0, 8)})');
    }
    return true;
  } catch (e) {
    if (kDebugMode) debugPrint('  ✗ Failed to schedule #$id: $e');
    return false;
  }
}

// Cancel all 2-hour notifications
Future<void> cancel2HourNotifications() async {
  try {
    // Cancel IDs 2001-2010
    for (int id = 2001; id <= 2010; id++) {
      await flutterLocalNotificationsPlugin.cancel(id);
    }
    if (kDebugMode) {
      debugPrint('✅ All 2-hour notifications cancelled');
      debugPendingNotifications();
    }
  } catch (e) {
    if (kDebugMode) debugPrint('Error cancelling 2-hour notifications: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;
  double _fontSize = 1.0;

  TextTheme _buildTextTheme({
    required Color bodyColor,
    required Color displayColor,
    required Color labelColor,
  }) {
    return TextTheme(
      displayLarge: GoogleFonts.cairo(fontSize: 28 * _fontSize, fontWeight: FontWeight.w800, color: displayColor).copyWith(inherit: true),
      displayMedium: GoogleFonts.cairo(fontSize: 26 * _fontSize, fontWeight: FontWeight.w700, color: displayColor).copyWith(inherit: true),
      displaySmall: GoogleFonts.cairo(fontSize: 24 * _fontSize, fontWeight: FontWeight.w700, color: displayColor).copyWith(inherit: true),
      headlineLarge: GoogleFonts.cairo(fontSize: 24 * _fontSize, fontWeight: FontWeight.w700, color: displayColor).copyWith(inherit: true),
      headlineMedium: GoogleFonts.cairo(fontSize: 22 * _fontSize, fontWeight: FontWeight.w700, color: displayColor).copyWith(inherit: true),
      headlineSmall: GoogleFonts.cairo(fontSize: 20 * _fontSize, fontWeight: FontWeight.w600, color: displayColor).copyWith(inherit: true),
      titleLarge: GoogleFonts.cairo(fontSize: 20 * _fontSize, fontWeight: FontWeight.w600, color: bodyColor).copyWith(inherit: true),
      titleMedium: GoogleFonts.cairo(fontSize: 18 * _fontSize, fontWeight: FontWeight.w600, color: bodyColor).copyWith(inherit: true),
      titleSmall: GoogleFonts.cairo(fontSize: 16 * _fontSize, fontWeight: FontWeight.w600, color: bodyColor).copyWith(inherit: true),
      bodyLarge: GoogleFonts.cairo(fontSize: 18 * _fontSize, color: bodyColor).copyWith(inherit: true),
      bodyMedium: GoogleFonts.cairo(fontSize: 16 * _fontSize, color: bodyColor).copyWith(inherit: true),
      bodySmall: GoogleFonts.cairo(fontSize: 14 * _fontSize, color: bodyColor).copyWith(inherit: true),
      labelLarge: GoogleFonts.cairo(fontSize: 14 * _fontSize, fontWeight: FontWeight.w600, color: labelColor).copyWith(inherit: true),
      labelMedium: GoogleFonts.cairo(fontSize: 12 * _fontSize, fontWeight: FontWeight.w600, color: labelColor).copyWith(inherit: true),
      labelSmall: GoogleFonts.cairo(fontSize: 11 * _fontSize, fontWeight: FontWeight.w500, color: labelColor).copyWith(inherit: true),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadFontSizePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('dark_mode_enabled') ?? false;
    });
  }

  Future<void> _loadFontSizePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('font_size') ?? 1.0;
    });
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _darkMode = isDark;
    });
  }

  void _updateFontSize(double size) {
    setState(() {
      _fontSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightTextTheme = _buildTextTheme(
      bodyColor: Colors.black87,
      displayColor: const Color(0xFF0B6623),
      labelColor: Colors.black87,
    );
    final darkTextTheme = _buildTextTheme(
      bodyColor: Colors.white70,
      displayColor: const Color(0xFF4CAF50),
      labelColor: Colors.white70,
    );

    return MaterialApp(
      key: ValueKey(_darkMode), // Force rebuild on theme change
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      // Arabic locale + RTL support
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Global theme using Google Fonts (Cairo) and an Islamic-friendly palette
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0B6623), // deep green
          secondary: Color(0xFFF3D18A), // warm gold
          background: Color(0xFFFBF8F0), // soft warm background
        ),
        scaffoldBackgroundColor: const Color(0xFFFBF8F0),
        primaryColor: const Color(0xFF0B6623),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0B6623),
          centerTitle: true,
          elevation: 2,
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 20 * _fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ).copyWith(inherit: true),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: lightTextTheme,
        primaryTextTheme: lightTextTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0B6623),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.cairo(
                fontSize: 16 * _fontSize, fontWeight: FontWeight.w700).copyWith(inherit: true),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0B6623),
          secondary: Color(0xFFF3D18A),
          background: Color(0xFF1A1A1A),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        primaryColor: const Color(0xFF0B6623),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0B6623),
          centerTitle: true,
          elevation: 2,
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 20 * _fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ).copyWith(inherit: true),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: darkTextTheme,
        primaryTextTheme: darkTextTheme,
      ),
      builder: (context, child) {
        // Force RTL for Arabic content and ensure text uses Cairo font
        return Directionality(
            textDirection: TextDirection.rtl, child: child ?? const SizedBox());
      },
      home: HomeScreen(
          onThemeChanged: _toggleTheme, onFontSizeChanged: _updateFontSize),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<double> onFontSizeChanged;

  const HomeScreen(
      {Key? key, required this.onThemeChanged, required this.onFontSizeChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تطبيق الأذكار',
            style:
                GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                        onThemeChanged: onThemeChanged,
                        onFontSizeChanged: onFontSizeChanged)),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B6623), // Deep Islamic green
              Color(0xFF1A8B3D), // Medium green
              Color(0xFFF3D18A), // Warm gold
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Beautiful Header Section
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'تطبيق الأذكار',
                        style: GoogleFonts.cairo(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0B6623),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFF3D18A).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'من الكتاب و السنة',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0B6623),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Daily Reminder Card
              SliverToBoxAdapter(
                child: _buildDailyReminderCard(context),
              ),

              // Grid of Beautiful Cards
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildCategoryCard(context, index);
                    },
                    childCount: 12,
                  ),
                ),
              ),

              // Bottom spacing
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'aladkar.com©${DateTime.now().year}',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyReminderCard(BuildContext context) {
    final duaOfTheDay = DailyReminderService.getDuaOfTheDay();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0B6623),
            Color(0xFF1A8B3D),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF0B6623).withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'دعاء اليوم من القرآن الكريم',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFF3D18A).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  duaOfTheDay['text']!,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.8,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3D18A).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '[${duaOfTheDay['source']}]',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B6623),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, int index) {
    final cardData = _getCardData(index);

    return InkWell(
      onTap: () => _navigateToScreen(context, index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with decorative circle
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0B6623),
                    Color(0xFF1A8B3D),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0B6623).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                cardData['icon'],
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            // Title text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                cardData['title'],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0B6623),
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getCardData(int index) {
    switch (index) {
      case 0:
        return {
          'title': 'أذكار اليوم و الليلة',
          'icon': Icons.brightness_6, // شمس وهلال معًا (رمز لليل والنهار)
        };
      case 1:
        return {
          'title': 'اذكار العبادات',
          'icon': Icons.mosque,
        };
      case 2:
        return {
          'title': 'أذكار متنوعة',
          'icon': Icons.menu_book,
        };
      case 3:
        return {
          'title': 'كنوز المغفرة',
          'icon': Icons.volunteer_activism, // يد مرفوعة للدعاء ونور نازل عليها
        };
      case 4:
        return {
          'title': 'كنوز الحسنات',
          'icon': Icons.diamond, // صندوق كنز مفتوح يخرج منه نور ذهبي
        };
      case 5:
        return {
          'title': 'أدعية من السنة النبوية',
          'icon': Icons.import_contacts,
        };
      case 6:
        return {
          'title': 'أدعية من القرآن الكريم',
          'icon': Icons.auto_stories, // مصحف مفتوح يتلألأ منه نور
        };
      case 7:
        return {
          'title': 'اتجاه القبلة',
          'icon': Icons.explore, // بوصلة جميلة
        };
      case 8:
        return {
          'title': 'الأذكار المفضلة',
          'icon': Icons.favorite, // علامة "إعجاب" إسلامية الطابع
        };
      case 9:
        return {
          'title': 'التقويم الهجري',
          'icon': Icons.calendar_month,
        };
      case 10:
        return {
          'title': 'إذاعة القرآن الكريم',
          'icon': Icons.radio,
        };
      case 11:
        return {
          'title': 'أوقات الصلاة',
          'icon': Icons.access_time,
        };
      default:
        return {'title': '', 'icon': Icons.help};
    }
  }

  void _navigateToScreen(BuildContext context, int index) {
    Widget? screen;

    switch (index) {
      case 0:
        screen = SabahMassaeScreen();
        break;
      case 1:
        screen = A3ibadat();
        break;
      case 2:
        screen = DiversAdkar();
        break;
      case 3:
        screen = KounouzMaghfira();
        break;
      case 4:
        screen = Tassbih();
        break;
      case 5:
        screen = DuaaFromSunnah();
        break;
      case 6:
        screen = DuaaFromQuran();
        break;
      case 7:
        screen = Quibla();
        break;
      case 8:
        screen = FavoritesScreen();
        break;
      case 9:
        screen = IslamicCalendarScreen();
        break;
      case 10:
        screen = QuranRadio();
        break;
      case 11:
        screen = PrayerTimesScreen();
        break;
    }

    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen!),
      );
    }
  }
}

// Removed _AdhkarReminderCard widget - now in SettingsScreen

// Legacy widget kept for reference but no longer used
class _AdhkarReminderCard extends StatefulWidget {
  @override
  State<_AdhkarReminderCard> createState() => _AdhkarReminderCardState();
}

class _AdhkarReminderCardState extends State<_AdhkarReminderCard> {
  bool _morningEnabled = false;
  bool _eveningEnabled = false;
  int _morningHour = 6;
  int _morningMinute = 30;
  int _eveningHour = 18;
  int _eveningMinute = 30;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _morningEnabled = prefs.getBool('adhkar_morning_enabled') ?? false;
      _eveningEnabled = prefs.getBool('adhkar_evening_enabled') ?? false;
      _morningHour = prefs.getInt('adhkar_morning_hour') ?? 6;
      _morningMinute = prefs.getInt('adhkar_morning_minute') ?? 30;
      _eveningHour = prefs.getInt('adhkar_evening_hour') ?? 18;
      _eveningMinute = prefs.getInt('adhkar_evening_minute') ?? 30;
    });
    // Reschedule if needed on app start
    if (_morningEnabled) {
      await scheduleMorning(hour: _morningHour, minute: _morningMinute);
    }
    if (_eveningEnabled) {
      await scheduleEvening(hour: _eveningHour, minute: _eveningMinute);
    }
  }

  Future<void> _toggleMorning(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _morningEnabled = value);
    await prefs.setBool('adhkar_morning_enabled', value);
    if (value) {
      await scheduleMorning(hour: _morningHour, minute: _morningMinute);
    } else {
      await cancelMorning();
    }
  }

  Future<void> _toggleEvening(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _eveningEnabled = value);
    await prefs.setBool('adhkar_evening_enabled', value);
    if (value) {
      await scheduleEvening(hour: _eveningHour, minute: _eveningMinute);
    } else {
      await cancelEvening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active, color: Color(0xFF0B6623)),
              SizedBox(width: 8),
              Text(
                'تذكير الأذكار اليومي',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0B6623),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildRow(
            title: 'أذكار الصباح',
            subtitle:
                'الساعة ${_morningHour.toString().padLeft(2, '0')}:${_morningMinute.toString().padLeft(2, '0')}',
            value: _morningEnabled,
            onChanged: _toggleMorning,
          ),
          SizedBox(height: 8),
          _buildRow(
            title: 'أذكار المساء',
            subtitle:
                'الساعة ${_eveningHour.toString().padLeft(2, '0')}:${_eveningMinute.toString().padLeft(2, '0')}',
            value: _eveningEnabled,
            onChanged: _toggleEvening,
          ),
          SizedBox(height: 6),
          Text(
            'يمكنك تغيير الوقت لاحقًا حسب رغبتك.',
            style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style:
                      GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF0B6623),
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () async {
                if (title.contains('الصباح')) {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay(hour: _morningHour, minute: _morningMinute),
                  );
                  if (picked != null) {
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      _morningHour = picked.hour;
                      _morningMinute = picked.minute;
                    });
                    await prefs.setInt('adhkar_morning_hour', _morningHour);
                    await prefs.setInt('adhkar_morning_minute', _morningMinute);
                    if (_morningEnabled) {
                      await scheduleMorning(
                          hour: _morningHour, minute: _morningMinute);
                    }
                  }
                } else {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay(hour: _eveningHour, minute: _eveningMinute),
                  );
                  if (picked != null) {
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      _eveningHour = picked.hour;
                      _eveningMinute = picked.minute;
                    });
                    await prefs.setInt('adhkar_evening_hour', _eveningHour);
                    await prefs.setInt('adhkar_evening_minute', _eveningMinute);
                    if (_eveningEnabled) {
                      await scheduleEvening(
                          hour: _eveningHour, minute: _eveningMinute);
                    }
                  }
                }
              },
              icon: Icon(Icons.access_time, color: Color(0xFF0B6623)),
              label: Text('تغيير الوقت',
                  style: GoogleFonts.cairo(color: Color(0xFF0B6623))),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () async {
                if (title.contains('الصباح')) {
                  const AndroidNotificationDetails androidDetails =
                      AndroidNotificationDetails(
                    'adhkar_morning',
                    'أذكار الصباح',
                    channelDescription: 'تذكير يومي بأذكار الصباح',
                    importance: Importance.high,
                    priority: Priority.high,
                  );
                  const NotificationDetails details =
                      NotificationDetails(android: androidDetails);
                  await flutterLocalNotificationsPlugin.show(
                    9001,
                    'تذكير الأذكار',
                    'اضغط لقراءة أذكار الصباح',
                    details,
                    payload: 'sabah',
                  );
                } else {
                  const AndroidNotificationDetails androidDetails =
                      AndroidNotificationDetails(
                    'adhkar_evening',
                    'أذكار المساء',
                    channelDescription: 'تذكير يومي بأذكار المساء',
                    importance: Importance.high,
                    priority: Priority.high,
                  );
                  const NotificationDetails details =
                      NotificationDetails(android: androidDetails);
                  await flutterLocalNotificationsPlugin.show(
                    9002,
                    'تذكير الأذكار',
                    'اضغط لقراءة أذكار المساء',
                    details,
                    payload: 'massae',
                  );
                }
              },
              icon: Icon(Icons.notifications_active, color: Color(0xFF0B6623)),
              label: Text('اختبار الآن',
                  style: GoogleFonts.cairo(color: Color(0xFF0B6623))),
            ),
          ],
        ),
        Divider(height: 20),
      ],
    );
  }
}
