// ignore_for_file: unused_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'widgets/app_scaffold.dart';
import 'divers_aldkar/dayne.dart';
import 'divers_aldkar/ghadab.dart';
import 'divers_aldkar/hazan.dart';
import 'divers_aldkar/hilal.dart';
import 'divers_aldkar/imane.dart';
import 'divers_aldkar/jimaa.dart';
import 'divers_aldkar/karab.dart';
import 'divers_aldkar/majliss.dart';
import 'divers_aldkar/manam.dart';
import 'divers_aldkar/marid.dart';
import 'divers_aldkar/matar.dart';
import 'divers_aldkar/moubtala.dart';
import 'divers_aldkar/moussiba.dart';
import 'divers_aldkar/nahr.dart';
import 'divers_aldkar/rih.dart';
import 'divers_aldkar/safar.dart';

class DiversAdkar extends StatelessWidget {
  const DiversAdkar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'أذكار متنوعة',
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 16,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: SectionCard(
                    title: _getPostTitle(index),
                    child: const SizedBox.shrink(),
                    onTap: () => _navigateToScreen(context, index),
                  ),
                );
              },
            ),
          ],
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

  static void _navigateToScreen(BuildContext context, int index) {
    final screens = [
      Manam(),
      Hazan(),
      Karab(),
      Dayne(),
      Imane(),
      Moussiba(),
      Majliss(),
      Ghadab(),
      Safar(),
      Rih(),
      Matar(),
      Nahr(),
      Jimaa(),
      Marid(),
      Moubtala(),
      Hilal(),
    ];
    if (index >= 0 && index < screens.length) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screens[index]),
      );
    }
  }

  static String _getPostTitle(int index) {
    switch (index) {
      case 0:
        return 'ما يقال إذا رأى في منامه ما يحب أو يكره';
      case 1:
        return 'الدعاء عند الهم والحزن';
      case 2:
        return 'دعاء الكرب';
      case 3:
        return 'دعاء قضاء الدين';
      case 4:
        return 'دعاء من أصابه شك في الإيمان';
      case 5:
        return 'دعاء من أصيب بمصيبة';
      case 6:
        return 'دعاء اللغو في الحديث (كفارة المجلس )';
      case 7:
        return 'ما يقال عند الغضب';
      case 8:
        return 'دعاء السفر و الرجوع منه';
      case 9:
        return 'الدعاء عند هيجان الريح';
      case 10:
        return 'الدعاء عند المطر';
      case 11:
        return 'الدعاء عند الذبح والنحر';
      case 12:
        return 'ما يقول الرجل إذا أتى أهله';
      case 13:
        return 'دعاء المريض و من احس بوجع في جسده';
      case 14:
        return 'الدعاء عند رؤية مبتلى';
      case 15:
        return 'دعاء رؤية الهلال';
      default:
        return '';
    }
  }
}
