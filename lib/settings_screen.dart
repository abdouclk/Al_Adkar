// ignore_for_file: use_super_parameters, prefer_const_constructors, deprecated_member_use, unused_element, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/app_scaffold.dart';
import 'main.dart';
import 'dart:io' show Platform;
import 'package:android_intent_plus/android_intent.dart';

class SettingsScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<double> onFontSizeChanged;

  const SettingsScreen(
      {Key? key, required this.onThemeChanged, required this.onFontSizeChanged})
      : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  bool _darkModeEnabled = false;
  bool _2hourNotificationsEnabled = false;
  TimeOfDay _morningTime = TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _eveningTime = TimeOfDay(hour: 18, minute: 0);
  String _notificationSound = 'default';
  double _fontSize = 1.0; // 1.0 is normal size

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled =
          prefs.getBool('adhkar_notifications_enabled') ?? false;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _2hourNotificationsEnabled =
          prefs.getBool('adhkar_2hour_enabled') ?? false;

      // Load custom times
      final morningHour = prefs.getInt('morning_hour') ?? 6;
      final morningMinute = prefs.getInt('morning_minute') ?? 0;
      _morningTime = TimeOfDay(hour: morningHour, minute: morningMinute);

      final eveningHour = prefs.getInt('evening_hour') ?? 18;
      final eveningMinute = prefs.getInt('evening_minute') ?? 0;
      _eveningTime = TimeOfDay(hour: eveningHour, minute: eveningMinute);

      _notificationSound = prefs.getString('notification_sound') ?? 'default';
      _fontSize = prefs.getDouble('font_size') ?? 1.0;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      // Ensure permission is granted on Android 13+
      final granted = await ensureNotificationPermissions();
      if (!granted) {
        setState(() => _notificationsEnabled = false);
        await prefs.setBool('adhkar_notifications_enabled', false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'يرجى السماح للإشعارات من إعدادات النظام\nالإعدادات > التطبيقات > الأذكار > الأذونات',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: 'فتح الإعدادات',
                textColor: Colors.white,
                onPressed: () async {
                  // Try to open app settings
                  if (Platform.isAndroid) {
                    try {
                      final intent = AndroidIntent(
                        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
                        arguments: <String, dynamic>{
                          'android.provider.extra.APP_PACKAGE':
                              'com.abdouclk.aladkar',
                        },
                      );
                      await intent.launch();
                    } catch (_) {
                      // Fallback to general settings
                      final intent = AndroidIntent(
                        action: 'android.settings.SETTINGS',
                      );
                      await intent.launch();
                    }
                  }
                },
              ),
            ),
          );
        }
        return;
      }

      // Schedule with custom times and sound
      try {
        await scheduleMorning(
            hour: _morningTime.hour,
            minute: _morningTime.minute,
            sound: _notificationSound);
        await scheduleEvening(
            hour: _eveningTime.hour,
            minute: _eveningTime.minute,
            sound: _notificationSound);

        setState(() => _notificationsEnabled = true);
        await prefs.setBool('adhkar_notifications_enabled', true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تفعيل تذكير الأذكار بنجاح ✓',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Color(0xFF0B6623),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        setState(() => _notificationsEnabled = false);
        await prefs.setBool('adhkar_notifications_enabled', false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'فشل جدولة الإشعارات\n\nالحل: افتح الإعدادات وفعّل:\n1. الإشعارات\n2. المنبهات والتذكيرات (Set alarms & reminders)',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 6),
              action: SnackBarAction(
                label: 'فتح الإعدادات',
                textColor: Colors.white,
                onPressed: () async {
                  if (Platform.isAndroid) {
                    try {
                      final intent = AndroidIntent(
                        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
                        data: 'package:com.abdouclk.aladkar',
                      );
                      await intent.launch();
                    } catch (_) {
                      // Fallback
                      final intent = AndroidIntent(
                        action: 'android.settings.SETTINGS',
                      );
                      await intent.launch();
                    }
                  }
                },
              ),
            ),
          );
        }
      }
    } else {
      // Cancel both
      await cancelMorning();
      await cancelEvening();
      setState(() => _notificationsEnabled = false);
      await prefs.setBool('adhkar_notifications_enabled', false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إيقاف تذكير الأذكار',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.grey.shade700,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _darkModeEnabled = value);
    await prefs.setBool('dark_mode_enabled', value);
    widget.onThemeChanged(value);
  }

  Future<void> _toggle2HourNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      // Ensure permissions
      final granted = await ensureNotificationPermissions();
      if (!granted) {
        setState(() => _2hourNotificationsEnabled = false);
        await prefs.setBool('adhkar_2hour_enabled', false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'يرجى السماح للإشعارات من إعدادات النظام',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 4),
              action: SnackBarAction(
                label: 'فتح الإعدادات',
                textColor: Colors.white,
                onPressed: () async {
                  if (Platform.isAndroid) {
                    try {
                      final intent = AndroidIntent(
                        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
                        arguments: <String, dynamic>{
                          'android.provider.extra.APP_PACKAGE':
                              'com.abdouclk.aladkar',
                        },
                      );
                      await intent.launch();
                    } catch (_) {
                      final intent = AndroidIntent(
                        action: 'android.settings.SETTINGS',
                      );
                      await intent.launch();
                    }
                  }
                },
              ),
            ),
          );
        }
        return;
      }

      // Schedule 2-hour notifications
      try {
        await schedule2HourNotifications();
        setState(() => _2hourNotificationsEnabled = true);
        await prefs.setBool('adhkar_2hour_enabled', true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تفعيل التذكير كل ساعتين ✓\n(من 06:00 ص إلى 10:00 م)',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Color(0xFF0B6623),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        setState(() => _2hourNotificationsEnabled = false);
        await prefs.setBool('adhkar_2hour_enabled', false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'فشل جدولة الإشعارات - تحقق من الأذونات',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } else {
      // Cancel 2-hour notifications
      await cancel2HourNotifications();
      setState(() => _2hourNotificationsEnabled = false);
      await prefs.setBool('adhkar_2hour_enabled', false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إيقاف التذكير كل ساعتين',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.grey.shade700,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _pickMorningTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _morningTime,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );

    if (picked != null && picked != _morningTime) {
      final prefs = await SharedPreferences.getInstance();
      setState(() => _morningTime = picked);
      await prefs.setInt('morning_hour', picked.hour);
      await prefs.setInt('morning_minute', picked.minute);

      // Reschedule if notifications are enabled
      if (_notificationsEnabled) {
        try {
          // Ensure permissions before scheduling
          final granted = await ensureNotificationPermissions();
          if (!granted) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'يجب السماح بالإشعارات أولاً. افتح الإعدادات وفعّل الأذونات',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 4),
                ),
              );
            }
            return;
          }

          await scheduleMorning(
              hour: picked.hour,
              minute: picked.minute,
              sound: _notificationSound);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم تحديث وقت تذكير الصباح',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Color(0xFF0B6623),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'فشل تحديث وقت التذكير: ${e.toString()}',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        // Just save the time without scheduling
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم حفظ الوقت. فعّل الإشعارات لتطبيق التغييرات',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  Future<void> _pickEveningTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _eveningTime,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );

    if (picked != null && picked != _eveningTime) {
      final prefs = await SharedPreferences.getInstance();
      setState(() => _eveningTime = picked);
      await prefs.setInt('evening_hour', picked.hour);
      await prefs.setInt('evening_minute', picked.minute);

      // Reschedule if notifications are enabled
      if (_notificationsEnabled) {
        try {
          // Ensure permissions before scheduling
          final granted = await ensureNotificationPermissions();
          if (!granted) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'يجب السماح بالإشعارات أولاً. افتح الإعدادات وفعّل الأذونات',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 4),
                ),
              );
            }
            return;
          }

          await scheduleEvening(
              hour: picked.hour,
              minute: picked.minute,
              sound: _notificationSound);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم تحديث وقت تذكير المساء',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Color(0xFF0B6623),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'فشل تحديث وقت التذكير: ${e.toString()}',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        // Just save the time without scheduling
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم حفظ الوقت. فعّل الإشعارات لتطبيق التغييرات',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  Future<void> _changeNotificationSound(String? sound) async {
    if (sound == null) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() => _notificationSound = sound);
    await prefs.setString('notification_sound', sound);

    // Reschedule notifications with new sound if enabled
    if (_notificationsEnabled) {
      await scheduleMorning(
          hour: _morningTime.hour, minute: _morningTime.minute, sound: sound);
      await scheduleEvening(
          hour: _eveningTime.hour, minute: _eveningTime.minute, sound: sound);
    }
  }

  Future<void> _changeFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _fontSize = value);
    await prefs.setDouble('font_size', value);
    widget.onFontSizeChanged(value);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getSoundLabel(String sound) {
    switch (sound) {
      case 'default':
        return 'افتراضي';
      case 'alert':
        return 'تنبيه';
      case 'chime':
        return 'جرس';
      case 'bell':
        return 'ناقوس';
      default:
        return 'افتراضي';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'الإعدادات',
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Notifications Info Section
          _buildPermissionButton(),

          SizedBox(height: 12),
          // Test Notification Button
          _buildTestNotificationButton(),
          
          SizedBox(height: 12),
          // Debug: Show pending notifications
          _buildDebugPendingButton(),

          SizedBox(height: 24),
          // 2-Hour Notifications Section
          _buildSectionHeader('إشعارات الأذكار'),
          _buildSettingCard(
            icon: Icons.notifications_active,
            title: 'تذكير كل ساعتين',
            subtitle: _2hourNotificationsEnabled
                ? 'مفعّل (من 6ص - 10م)'
                : 'معطل',
            value: _2hourNotificationsEnabled,
            onChanged: _toggle2HourNotifications,
          ),
          
          SizedBox(height: 16),
          // Battery optimization info card
          _buildBatteryOptimizationCard(),

          SizedBox(height: 24),
          // Appearance Section
          _buildSectionHeader('المظهر'),
          _buildSettingCard(
            icon: Icons.dark_mode,
            title: 'الوضع الليلي',
            subtitle: _darkModeEnabled ? 'مفعّل' : 'معطل',
            value: _darkModeEnabled,
            onChanged: _toggleDarkMode,
          ),
          SizedBox(height: 12),
          _buildFontSizeCard(),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'aladkar.com©${DateTime.now().year}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color.fromARGB(211, 0, 0, 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  // Info card for displaying notification information
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconColor.withOpacity(0.1),
            iconColor.withOpacity(0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: iconColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerCard({
    required IconData icon,
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatTimeOfDay(time),
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.chevron_left,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundPickerCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.music_note,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'صوت الإشعار',
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _notificationSound,
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down,
                  color: Theme.of(context).primaryColor),
              dropdownColor: Theme.of(context).cardColor,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
              items: ['default', 'alert', 'chime', 'bell'].map((sound) {
                return DropdownMenuItem<String>(
                  value: sound,
                  child: Text(_getSoundLabel(sound)),
                );
              }).toList(),
              onChanged: _changeNotificationSound,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugTestCard() {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade300, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, color: Colors.orange.shade700),
              SizedBox(width: 8),
              Text('اختبار الإشعارات (تجريبي)',
                  style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.orange.shade900)),
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final success = await sendScheduledTestNotification();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'تم جدولة إشعار تجريبي خلال 10 ثوانٍ. راقب الإشعارات!'
                          : 'فشل جدولة الإشعار التجريبي',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(),
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            icon: Icon(Icons.alarm_add),
            label: Text('اختبار إشعار مجدول (10 ثوانٍ)',
                style: GoogleFonts.cairo(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              minimumSize: Size(double.infinity, 48),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ملاحظة: إذا لم يظهر الإشعار، تحقق من أذونات "المنبهات الدقيقة" في إعدادات النظام',
            style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Button to open app notification settings
  Widget _buildPermissionButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        if (Platform.isAndroid) {
          try {
            // Try to open exact alarm settings first
            final intent = AndroidIntent(
              action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
              data: 'package:com.abdouclk.aladkar',
            );
            await intent.launch();
          } catch (_) {
            try {
              // Fallback to app details settings
              final intent = AndroidIntent(
                action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
                data: 'package:com.abdouclk.aladkar',
              );
              await intent.launch();
            } catch (_) {
              // Final fallback to general settings
              final intent = AndroidIntent(
                action: 'android.settings.SETTINGS',
              );
              await intent.launch();
            }
          }
        }
      },
      icon: Icon(Icons.settings, size: 20),
      label: Text(
        'فتح إعدادات الأذونات',
        style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0B6623),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    );
  }

  Widget _buildTestNotificationButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        final success = await sendTestNotification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'تم إرسال الإشعار بنجاح! ✓\nتحقق من شريط الإشعارات في الأعلى'
                    : 'فشل إرسال الإشعار\nيرجى التحقق من أذونات الإشعارات في إعدادات الهاتف',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(fontSize: 14, height: 1.5),
              ),
              backgroundColor: success ? Color(0xFF0B6623) : Colors.red,
              duration: Duration(seconds: success ? 3 : 5),
              action: !success ? SnackBarAction(
                label: 'فتح الإعدادات',
                textColor: Colors.white,
                onPressed: () async {
                  if (Platform.isAndroid) {
                    try {
                      final intent = AndroidIntent(
                        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
                        arguments: <String, dynamic>{
                          'android.provider.extra.APP_PACKAGE':
                              'com.abdouclk.aladkar',
                        },
                      );
                      await intent.launch();
                    } catch (_) {
                      final intent = AndroidIntent(
                        action: 'android.settings.SETTINGS',
                      );
                      await intent.launch();
                    }
                  }
                },
              ) : null,
            ),
          );
        }
      },
      icon: Icon(Icons.notification_add, size: 20),
      label: Text(
        'اختبار إشعار فوري',
        style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    );
  }

  Widget _buildDebugPendingButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
          
          // Group by type
          int twoHourCount = pending.where((n) => n.id >= 2001 && n.id <= 2009).length;
          int dailyCount = pending.where((n) => n.id >= 1001 && n.id <= 1004).length;
          int otherCount = pending.length - twoHourCount - dailyCount;
          
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: Text(
                    'الإشعارات المجدولة',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إجمالي: ${pending.length} إشعار',
                        style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12),
                      Text('تذكير كل ساعتين: $twoHourCount',
                          style: GoogleFonts.cairo(fontSize: 14)),
                      Text('الأذكار اليومية: $dailyCount',
                          style: GoogleFonts.cairo(fontSize: 14)),
                      if (otherCount > 0)
                        Text('أخرى: $otherCount',
                            style: GoogleFonts.cairo(fontSize: 14)),
                      if (pending.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'لا توجد إشعارات مجدولة حاليًا',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('حسنًا', style: GoogleFonts.cairo()),
                    ),
                  ],
                ),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ: ${e.toString()}', textAlign: TextAlign.center),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      icon: Icon(Icons.bug_report, size: 18),
      label: Text(
        'عرض الإشعارات المجدولة',
        style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade700,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildBatteryOptimizationCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.battery_alert, color: Colors.blue.shade700, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'نصيحة مهمة للإشعارات',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'لضمان ظهور الإشعارات في الوقت المحدد، يُنصح بإيقاف تحسين البطارية للتطبيق.',
            style: GoogleFonts.cairo(
              fontSize: 14,
              height: 1.6,
              color: Colors.blue.shade900,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              if (Platform.isAndroid) {
                try {
                  // Try to open battery optimization settings for the app
                  final intent = AndroidIntent(
                    action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
                  );
                  await intent.launch();
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'ابحث عن "الأذكار" واختر "غير مقيد" أو "Unrestricted"',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(fontSize: 13),
                        ),
                        backgroundColor: Colors.blue.shade700,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                } catch (e) {
                  // Fallback: Open app details page
                  try {
                    final intent = AndroidIntent(
                      action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
                      data: 'package:com.abdouclk.aladkar',
                    );
                    await intent.launch();
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'افتح "البطارية" واختر "غير مقيد"',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(fontSize: 13),
                          ),
                          backgroundColor: Colors.blue.shade700,
                          duration: Duration(seconds: 4),
                        ),
                      );
                    }
                  } catch (_) {
                    // Final fallback
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'افتح: الإعدادات > التطبيقات > الأذكار > البطارية > غير مقيد',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(fontSize: 12),
                          ),
                          backgroundColor: Colors.orange,
                          duration: Duration(seconds: 6),
                        ),
                      );
                    }
                  }
                }
              }
            },
            icon: Icon(Icons.battery_charging_full, size: 20),
            label: Text(
              'فتح إعدادات البطارية',
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.text_fields,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'حجم الخط',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              Text(
                '${(_fontSize * 100).toInt()}%',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text(
                'صغير',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 0.8,
                  max: 1.5,
                  divisions: 14,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: _changeFontSize,
                ),
              ),
              Text(
                'كبير',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'نص تجريبي - اللهم صل على محمد',
              style: GoogleFonts.cairo(
                fontSize: 16 * _fontSize,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
