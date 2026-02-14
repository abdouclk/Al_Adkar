// ignore_for_file: prefer_const_constructors, use_super_parameters, deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'widgets/app_scaffold.dart';

class IslamicCalendarScreen extends StatefulWidget {
  const IslamicCalendarScreen({Key? key}) : super(key: key);

  @override
  State<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends State<IslamicCalendarScreen> {
  DateTime selectedGregorianDate = DateTime.now();
  bool convertToHijri =
      true; // true = Gregorian to Hijri, false = Hijri to Gregorian

  // Islamic months in Arabic
  final List<String> islamicMonths = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  // Important Islamic dates list removed as the section is hidden

  // Convert Gregorian to Hijri (Umm al-Qura accurate)
  Map<String, int> gregorianToHijri(DateTime gregorianDate) {
    final hijri = HijriCalendar.fromDate(gregorianDate);
    return {'year': hijri.hYear, 'month': hijri.hMonth, 'day': hijri.hDay};
  }

  // Convert Hijri to Gregorian (Umm al-Qura accurate)
  DateTime hijriToGregorian(int year, int month, int day) {
    final hijri = HijriCalendar();
    return hijri.hijriToGregorian(year, month, day);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedGregorianDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF0B6623),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedGregorianDate) {
      setState(() {
        selectedGregorianDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hijriDate = gregorianToHijri(selectedGregorianDate);
    final currentHijri = gregorianToHijri(DateTime.now());

    return AppScaffold(
      title: 'التقويم الهجري',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Hijri Date Card
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0B6623),
                    Color(0xFF1A8B3D),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0B6623).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xFFF3D18A),
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'التاريخ الهجري اليوم',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${currentHijri['day']} ${islamicMonths[currentHijri['month']! - 1]} ${currentHijri['year']} هـ',
                    style: GoogleFonts.cairo(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateTime.now().toString().split(' ')[0],
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Date Converter Card
            Card(
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFFBF8F0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.sync_alt,
                          color: Color(0xFF0B6623),
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'محول التاريخ',
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B6623),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Date Selection
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFF0B6623).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF0B6623).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Color(0xFF0B6623),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'اختر التاريخ',
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0B6623),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF0B6623),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Gregorian Date
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF0B6623).withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'التاريخ الميلادي',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${selectedGregorianDate.day}/${selectedGregorianDate.month}/${selectedGregorianDate.year}',
                            style: GoogleFonts.cairo(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B6623),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Conversion Arrow
                    Icon(
                      Icons.arrow_downward,
                      color: Color(0xFFF3D18A),
                      size: 32,
                    ),

                    SizedBox(height: 16),

                    // Hijri Date
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF0B6623).withOpacity(0.1),
                            Color(0xFF1A8B3D).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF0B6623).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'التاريخ الهجري',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${hijriDate['day']} ${islamicMonths[hijriDate['month']! - 1]} ${hijriDate['year']} هـ',
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B6623),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
