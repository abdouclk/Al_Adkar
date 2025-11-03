// ignore_for_file: prefer_const_constructors, use_super_parameters, use_key_in_widget_constructors, unused_element, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:al_adkar/tassbih/istighfar.dart';
import 'package:al_adkar/tassbih/salat_nabii.dart';
import 'package:al_adkar/tassbih/soubhanallah.dart';
import 'package:al_adkar/tassbih/tahlil.dart';
import 'widgets/app_scaffold.dart';

class Tassbih extends StatelessWidget {
  const Tassbih({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'كنوز الحسنات',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionCard(
              title: '',
              child: Text(
                'وَإِنْ مِنْ شَيْءٍ إِلاَّ يُسَبِّحُ بِحَمْدِهِ وَلَكِنْ لاَ تَفْقَهُونَ تَسْبِيحَهُمْ',
                style: TextStyle(
                    fontSize: 22, height: 2.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  SectionCard(
                    title: 'التسبيح',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Soubhanallah()),
                    ),
                    child:
                        Icon(Icons.sunny, size: 48, color: Color(0xFFFFD700)),
                  ),
                  SectionCard(
                    title: 'التهليل',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Tahlil()),
                    ),
                    child: Icon(Icons.star, size: 48, color: Color(0xFFFFD700)),
                  ),
                  SectionCard(
                    title: 'الصلاة على النبي',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalatNabii()),
                    ),
                    child:
                        Icon(Icons.mosque, size: 48, color: Color(0xFFFFD700)),
                  ),
                  SectionCard(
                    title: 'الاستغفار',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Istighfar()),
                    ),
                    child: Icon(Icons.favorite,
                        size: 48, color: Color(0xFFFFD700)),
                  ),
                ],
              ),
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
}
