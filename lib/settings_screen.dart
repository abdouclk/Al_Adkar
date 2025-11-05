// ignore_for_file: use_super_parameters, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/app_scaffold.dart';
import 'main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    setState(() => _notificationsEnabled = value);
    await prefs.setBool('adhkar_notifications_enabled', value);

    if (value) {
      // Ensure permission is granted on Android 13+
      final granted = await ensureNotificationPermissions();
      if (!granted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى السماح للإشعارات من إعدادات النظام',
                textAlign: TextAlign.center),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      // Schedule with custom times and sound
      await scheduleMorning(
          hour: _morningTime.hour,
          minute: _morningTime.minute,
          sound: _notificationSound);
      await scheduleEvening(
          hour: _eveningTime.hour,
          minute: _eveningTime.minute,
          sound: _notificationSound);
    } else {
      // Cancel both
      await cancelMorning();
      await cancelEvening();
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _darkModeEnabled = value);
    await prefs.setBool('dark_mode_enabled', value);
    widget.onThemeChanged(value);
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
        await scheduleMorning(
            hour: picked.hour,
            minute: picked.minute,
            sound: _notificationSound);
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
        await scheduleEvening(
            hour: picked.hour,
            minute: picked.minute,
            sound: _notificationSound);
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
          // Notifications Section
          _buildSectionHeader('الإشعارات'),
          _buildSettingCard(
            icon: Icons.notifications_active,
            title: 'إشعارات أذكار الصباح والمساء',
            subtitle: _notificationsEnabled ? 'مفعّلة' : 'معطلة',
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),

          // Time pickers (shown only if notifications enabled)
          if (_notificationsEnabled) ...[
            SizedBox(height: 12),
            _buildTestNotificationButton(),
            SizedBox(height: 12),
            _buildScheduledTestButton(),
            SizedBox(height: 12),
            _buildTroubleshootCard(),
            SizedBox(height: 12),
            _buildTimePickerCard(
              icon: Icons.wb_sunny,
              title: 'وقت أذكار الصباح',
              time: _morningTime,
              onTap: _pickMorningTime,
            ),
            SizedBox(height: 12),
            _buildTimePickerCard(
              icon: Icons.nightlight_round,
              title: 'وقت أذكار المساء',
              time: _eveningTime,
              onTap: _pickEveningTime,
            ),
            SizedBox(height: 12),
            _buildSoundPickerCard(),
          ],

          SizedBox(height: 16),
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

  Widget _buildTestNotificationButton() {
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
      child: ElevatedButton.icon(
        onPressed: () async {
          final ok = await sendTestNotification();
          if (!mounted) return;
          if (ok) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('تم إرسال إشعار تجريبي', textAlign: TextAlign.center),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'لم يتم السماح بالإشعارات. فعّلها من إعدادات النظام ثم جرّب مرة أخرى.',
                    textAlign: TextAlign.center),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        icon: Icon(Icons.notification_add),
        label: Text(
          'اختبار الإشعارات',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduledTestButton() {
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
      child: ElevatedButton.icon(
        onPressed: () async {
          final ok = await ensureNotificationPermissions();
          if (!ok) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'لم يتم السماح بالإشعارات. فعّلها من إعدادات النظام ثم جرّب مرة أخرى.',
                    textAlign: TextAlign.center),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 3),
              ),
            );
            return;
          }

          // Schedule a notification 10 seconds from now using exactAllowWhileIdle
          final when = tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));
          const AndroidNotificationDetails androidDetails =
              AndroidNotificationDetails(
            'adhkar_test',
            'اختبار الإشعارات',
            channelDescription: 'إشعار مجدول للاختبار بعد 10 ثوانٍ',
            importance: Importance.high,
            priority: Priority.high,
          );
          const NotificationDetails details =
              NotificationDetails(android: androidDetails);
          await flutterLocalNotificationsPlugin.zonedSchedule(
            9010,
            'اختبار الإشعارات (مجدول)',
            'سيظهر هذا الإشعار بعد 10 ثوانٍ إن كانت الأذونات مفعلة',
            when,
            details,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تمت جدولة إشعار بعد 10 ثوانٍ',
                  textAlign: TextAlign.center),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: Icon(Icons.schedule),
        label: Text(
          'تجربة إشعار بعد 10 ثوانٍ',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildTroubleshootCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings_suggest, color: Color(0xFF0B6623)),
              const SizedBox(width: 8),
              Text('حل مشاكل الإشعارات ',
                  style: GoogleFonts.cairo(
                      fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _quickActionButton(
                icon: Icons.notifications_active,
                label: 'إعدادات الإشعارات',
                onTap: _openAppNotificationSettings,
              ),
              _quickActionButton(
                icon: Icons.alarm_on,
                label: 'السماح بالمنبّهات الدقيقة',
                onTap: _openExactAlarmSettings,
              ),
              _quickActionButton(
                icon: Icons.battery_alert,
                label: 'إلغاء قيود البطارية',
                onTap: _openBatteryOptimization,
              ),
              _quickActionButton(
                icon: Icons.play_circle_fill,
                label: 'التشغيل التلقائي (Oppo)',
                onTap: _openOppoAutoStart,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: GoogleFonts.cairo(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        side:
            BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.4)),
        foregroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _openAppNotificationSettings() {
    if (!Platform.isAndroid) return;
    final intent = AndroidIntent(
      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
      arguments: <String, dynamic>{
        'android.provider.extra.APP_PACKAGE': 'com.abdouclk.aladkar',
      },
    );
    intent.launch();
  }

  void _openExactAlarmSettings() {
    if (!Platform.isAndroid) return;
    final intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      package: 'com.abdouclk.aladkar',
    );
    intent.launch();
  }

  void _openBatteryOptimization() {
    if (!Platform.isAndroid) return;
    final intent = AndroidIntent(
      action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
    );
    intent.launch();
  }

  void _openOppoAutoStart() {
    if (!Platform.isAndroid) return;
    // Try common OPPO/ColorOS autostart settings activities
    final candidates = <AndroidIntent>[
      AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: 'com.coloros.safecenter',
        componentName:
            'com.coloros.safecenter.startupapp.StartupAppListActivity',
      ),
      AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: 'com.oppo.safe',
        componentName:
            'com.oppo.safe.permission.startup.StartupAppListActivity',
      ),
      AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:com.abdouclk.aladkar',
      ),
    ];

    // Try intents sequentially
    for (final intent in candidates) {
      intent.launch();
    }
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
