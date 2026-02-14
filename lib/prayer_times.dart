// Prayer Times screen: computes and displays daily prayer times based on current location
// Dependencies: geolocator, adhan

// (no deprecated API usage)

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'services/notification_helper.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Position? _position;
  PrayerTimes? _todayTimes;
  PrayerTimes? _tomorrowTimes;
  Timer? _timer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    setState(() {
      _error = null;
    });
    try {
      // Check service
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'الرجاء تفعيل خدمة الموقع (GPS)';
        });
        return;
      }

      // Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _error = 'تم رفض إذن الموقع. الرجاء السماح من الإعدادات.';
        });
        return;
      }

      // Get position
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );

      // Compute prayer times
      await _computeTimes(pos);

      // Start countdown ticker
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ أثناء جلب الموقع: $e';
      });
    }
  }

  Future<void> _computeTimes(Position pos) async {
    final coords = Coordinates(pos.latitude, pos.longitude);

    // Choose a reasonable default calculation method
    final params = CalculationMethod.muslim_world_league.getParameters()
      ..madhab = Madhab.shafi
      ..highLatitudeRule = HighLatitudeRule.middle_of_the_night;

    final now = DateTime.now();
    final dcToday = DateComponents(now.year, now.month, now.day);
    final n2 = now.add(const Duration(days: 1));
    final dcTomorrow = DateComponents(n2.year, n2.month, n2.day);

    final today = PrayerTimes(coords, dcToday, params);
    final tomorrow = PrayerTimes(coords, dcTomorrow, params);

    setState(() {
      _position = pos;
      _todayTimes = today;
      _tomorrowTimes = tomorrow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أوقات الصلاة',
            style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_error != null) {
      return _buildError(context, _error!);
    }
    if (_todayTimes == null || _position == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = _prayerItems();
    final next = _nextPrayer();
    final nextTime = _nextPrayerTime();

    return RefreshIndicator(
      onRefresh: _init,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(next, nextTime),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _scheduleNextPrayerNotification,
            icon: const Icon(Icons.notifications_active),
            label: Text('إشعار الصلاة القادمة', style: GoogleFonts.cairo()),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          _buildLocationCard(),
          const SizedBox(height: 16),
          _buildTimesCard(items, next),
          const SizedBox(height: 12),
          Text(
            '',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700]),
          )
        ],
      ),
    );
  }

  Future<void> _scheduleNextPrayerNotification() async {
    // Ensure notifications and exact alarm permissions
    final granted = await NotificationHelper.ensureNotificationPermissions();
    if (!granted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('الرجاء تفعيل إذن الإشعارات من الإعدادات',
                style: GoogleFonts.cairo()),
            backgroundColor: Colors.redAccent),
      );
      return;
    }

    await NotificationHelper.createPrayerChannelIfNeeded();

    // Request exact alarm permission (Android 12+) for precise scheduling
    try {
      await NotificationHelper.requestExactAlarmsPermission();
    } catch (e) {
      // Ignore if not supported on this Android version
    }

    final nextName = _nextPrayer();
    final nextTime = _nextPrayerTime();

    // If the next time is very close/past due to seconds, push it by 5 seconds to be safe
    final now = DateTime.now();
    final scheduledTime = nextTime.isAfter(now.add(const Duration(seconds: 5)))
        ? nextTime
        : now.add(
            const Duration(seconds: 10)); // Test notification after 10 seconds

    await NotificationHelper.scheduleAt(
      id: 3001,
      time: scheduledTime,
      title: 'موعد الصلاة 🕌',
      body: 'حان وقت صلاة $nextName - الله أكبر',
      payload: 'prayer',
    );

    final timeDisplay = _formatTime(scheduledTime);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('تم جدولة إشعار $nextName في $timeDisplay',
              style: GoogleFonts.cairo()),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3)),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, size: 48, color: Colors.red[400]),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(fontSize: 16)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _init,
              icon: const Icon(Icons.refresh),
              label: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: Geolocator.openAppSettings,
              child: Text('فتح إعدادات التطبيق', style: GoogleFonts.cairo()),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String nextPrayer, DateTime nextTime) {
    final remaining = nextTime.difference(DateTime.now());
    final r = _formatDuration(remaining);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B6623), Color(0xFF1A8B3D)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B6623).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('الصلاة القادمة',
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(nextPrayer,
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(_formatTime(nextTime),
              style: GoogleFonts.cairo(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20)),
            child: Text('الوقت المتبقي: $r',
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 14)),
          )
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الموقع الحالي',
                    style: GoogleFonts.cairo(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  _position != null
                      ? '(${_position!.latitude.toStringAsFixed(4)}, ${_position!.longitude.toStringAsFixed(4)})'
                      : '...',
                  style: GoogleFonts.cairo(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _init,
            icon: const Icon(Icons.my_location, color: Color(0xFF0B6623)),
            tooltip: 'تحديث الموقع',
          )
        ],
      ),
    );
  }

  Widget _buildTimesCard(List<_PrayerItem> items, String nextPrayer) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF0B6623)),
              const SizedBox(width: 6),
              Text('أوقات اليوم',
                  style: GoogleFonts.cairo(
                      fontSize: 16, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ...items.map((e) {
            final isNext = e.name == nextPrayer;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isNext
                    ? const Color(0xFF0B6623).withValues(alpha: 0.06)
                    : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.name,
                      style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight:
                              isNext ? FontWeight.w800 : FontWeight.w600,
                          color: isNext
                              ? const Color(0xFF0B6623)
                              : Colors.black87)),
                  Text(_formatTime(e.time),
                      style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  List<_PrayerItem> _prayerItems() {
    final t = _todayTimes!;
    return [
      _PrayerItem('الفجر', t.fajr),
      _PrayerItem('الشروق', t.sunrise),
      _PrayerItem('الظهر', t.dhuhr),
      _PrayerItem('العصر', t.asr),
      _PrayerItem('المغرب', t.maghrib),
      _PrayerItem('العشاء', t.isha),
    ];
  }

  String _nextPrayer() {
    final now = DateTime.now();
    final t = _todayTimes!;
    final ordered = [
      MapEntry('الفجر', t.fajr),
      MapEntry('الشروق', t.sunrise),
      MapEntry('الظهر', t.dhuhr),
      MapEntry('العصر', t.asr),
      MapEntry('المغرب', t.maghrib),
      MapEntry('العشاء', t.isha),
    ];
    for (final e in ordered) {
      if (e.value.isAfter(now)) return e.key;
    }
    // After Isha: next is tomorrow Fajr
    return 'الفجر';
  }

  DateTime _nextPrayerTime() {
    final now = DateTime.now();
    final t = _todayTimes!;
    final ordered = [t.fajr, t.sunrise, t.dhuhr, t.asr, t.maghrib, t.isha];
    for (final dt in ordered) {
      if (dt.isAfter(now)) return dt;
    }
    // After Isha: use tomorrow Fajr
    return _tomorrowTimes!.fajr;
  }

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String _formatDuration(Duration d) {
    var seconds = d.inSeconds;
    if (seconds < 0) seconds = 0;
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _PrayerItem {
  final String name;
  final DateTime time;
  _PrayerItem(this.name, this.time);
}
