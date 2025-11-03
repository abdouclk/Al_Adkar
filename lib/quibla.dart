// ignore_for_file: prefer_const_constructors, unused_element, use_super_parameters, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/app_scaffold.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class Quibla extends StatefulWidget {
  const Quibla({Key? key}) : super(key: key);

  @override
  State<Quibla> createState() => _QuiblaState();
}

class _QuiblaState extends State<Quibla> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
    // flutter_qiblah manages sensors and location internally via its stream
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'اتجاه القبلة',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B6623).withOpacity(0.1),
              Color(0xFFF3D18A).withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.mosque,
                        size: 50,
                        color: Color(0xFF0B6623),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'اتجاه الكعبة المشرفة',
                        style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B6623),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'قِبْلَة المسلمين في صلاتهم',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Soft outer glow ring
                          Container(
                            width: 290,
                            height: 290,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFF0B6623).withOpacity(0.06),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Static compass face (does not rotate)
                          Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: CustomPaint(
                              painter: ElegantCompassPainter(),
                            ),
                          ),
                          // Qibla needle driven by flutter_qiblah
                          StreamBuilder<QiblahDirection>(
                            stream: FlutterQiblah.qiblahStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Positioned(
                                  bottom: 12,
                                  child: Text(
                                    'تحقق من تفعيل الموقع وحساس البوصلة ثم أعد المحاولة',
                                    style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(color: Color(0xFF0B6623)),
                                      SizedBox(height: 8),
                                      Text(
                                        'جاري تحديد اتجاه القبلة...',
                                        style: GoogleFonts.cairo(fontSize: 14, color: Color(0xFF0B6623)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              final qiblah = snapshot.data!.qiblah; // degrees clockwise from North
                              return Transform.rotate(
                                angle: qiblah * math.pi / 180.0,
                                child: SizedBox(
                                  width: 220,
                                  height: 220,
                                  child: CustomPaint(
                                    painter: NeedlePainter(),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Pulsing golden glow behind center
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final t = _animationController.value;
                              final scale =
                                  1.0 + 0.06 * math.sin(t * 2 * math.pi);
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFF3C04D)
                                        .withOpacity(0.12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFF3C04D)
                                            .withOpacity(0.28),
                                        blurRadius: 30,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // Center Kaaba jewel
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFFFFE37D),
                                  Color(0xFFF3C04D),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFF3C04D).withOpacity(0.45),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.other_houses_rounded,
                              color: Color(0xFF0B6623),
                              size: 26,
                            ),
                          ),
                          // Live readout from flutter_qiblah
                          Positioned(
                            bottom: 10,
                            child: StreamBuilder<QiblahDirection>(
                              stream: FlutterQiblah.qiblahStream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return SizedBox.shrink();
                                final q = snapshot.data!;
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0B6623),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'القبلة: ${q.qiblah.toStringAsFixed(0)}°',
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF0B6623).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'وَجِّهْ جهازك نحو القبلة',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0B6623),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                _buildInfoCard(
                  icon: Icons.location_on,
                  title: 'الموقع',
                  value: 'مكة المكرمة',
                  subtitle: 'المملكة العربية السعودية',
                ),
                SizedBox(height: 15),
                _buildInfoCard(
                  icon: Icons.straighten,
                  title: 'المسافة التقريبية',
                  value: 'حسب موقعك',
                  subtitle: 'استخدم البوصلة للتوجيه الدقيق',
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0B6623),
                        Color(0xFF1A8B3D),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF0B6623).withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.menu_book,
                        color: Color(0xFFFFD700),
                        size: 40,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'فَوَلِّ وَجْهَكَ شَطْرَ الْمَسْجِدِ الْحَرَامِ ۚ وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'سورة البقرة - آية 144',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Color(0xFFF3D18A),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
              color: Color(0xFF0B6623).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Color(0xFF0B6623),
              size: 30,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B6623),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ElegantCompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer and inner rings
    final ring = Paint()
      ..color = const Color(0xFF0B6623)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 4, ring);
    canvas.drawCircle(center, radius - 10,
        ring..color = const Color(0xFF0B6623).withOpacity(0.4));

    // Tick marks: 60 ticks, major every 15, cardinal every 90
    for (int i = 0; i < 60; i++) {
      final angle = (i * 2 * math.pi / 60) - math.pi / 2;
      final isCardinal = i % 15 == 0;
      final isMedium = !isCardinal && i % 5 == 0;

      final tickStart = radius -
          (isCardinal
              ? 18
              : isMedium
                  ? 12
                  : 8);
      final tickEnd = radius - 4;

      final start = Offset(
        center.dx + tickStart * math.cos(angle),
        center.dy + tickStart * math.sin(angle),
      );
      final end = Offset(
        center.dx + tickEnd * math.cos(angle),
        center.dy + tickEnd * math.sin(angle),
      );

      final tickPaint = Paint()
        ..color = const Color(0xFF0B6623).withOpacity(isCardinal
            ? 0.9
            : isMedium
                ? 0.6
                : 0.35)
        ..strokeWidth = isCardinal
            ? 2.5
            : isMedium
                ? 2
                : 1.2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(start, end, tickPaint);
    }

  // Draw a Kaaba icon at the top (North)
    final kaabaIconSize = 32.0;
    final topCenter = Offset(center.dx, center.dy - (radius - 18));
    canvas.save();
    // Optionally, you can draw a subtle highlight circle behind the icon
    canvas.drawCircle(topCenter, kaabaIconSize/2 + 6, Paint()..color = Color(0xFFF3C04D).withOpacity(0.18));
    // Draw the Kaaba icon (using built-in icon)
    TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.other_houses_rounded.codePoint),
        style: TextStyle(
          fontSize: kaabaIconSize,
          fontFamily: Icons.other_houses_rounded.fontFamily,
          color: Color(0xFF0B6623),
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(topCenter.dx - kaabaIconSize/2, topCenter.dy - kaabaIconSize/2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the needle pointing UP by default
    final tip = Offset(center.dx, center.dy - (radius - 8));
    final baseLeft = Offset(center.dx - 10, center.dy + 20);
    final baseRight = Offset(center.dx + 10, center.dy + 20);

    final needlePath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..close();

    final needlePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFD32F2F); // red tip

    canvas.drawPath(needlePath, needlePaint);

    // Tail (counterweight) pointing down
    final tailTip = Offset(center.dx, center.dy + (radius - 18));
    final tailLeft = Offset(center.dx - 7, center.dy - 12);
    final tailRight = Offset(center.dx + 7, center.dy - 12);
    final tailPath = Path()
      ..moveTo(tailTip.dx, tailTip.dy)
      ..lineTo(tailLeft.dx, tailLeft.dy)
      ..lineTo(tailRight.dx, tailRight.dy)
      ..close();

    final tailPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF616161);

    canvas.drawPath(tailPath, tailPaint);

    // Center cap
    final capPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF0B6623);
    canvas.drawCircle(center, 6, capPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _KaabaMarker extends StatelessWidget {
  final double bearingDeg; // absolute bearing from North (0..360)
  final double radius; // distance from center

  const _KaabaMarker({required this.bearingDeg, required this.radius});

  @override
  Widget build(BuildContext context) {
    // Convert to canvas angle (0 rad to the right, + clockwise). Our painter uses
    // labels with 0 at East, -pi/2 at North, so place marker at (bearing - 90) deg.
    final angleRad = (bearingDeg - 90) * math.pi / 180.0;
    final dx = radius * math.cos(angleRad);
    final dy = radius * math.sin(angleRad);

    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(dx, dy),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF3C04D),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF3C04D).withOpacity(0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                Icons
                    .emoji_objects, // simple marker; could be a Kaaba icon image
                size: 14,
                color: const Color(0xFF0B6623),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
