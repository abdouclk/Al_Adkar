// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:al_adkar/widgets/app_scaffold.dart';
import 'package:al_adkar/alyaoum/clothes.dart';
import 'package:al_adkar/alyaoum/eat.dart';
import 'package:al_adkar/alyaoum/house.dart';
import 'package:al_adkar/alyaoum/massae.dart';
import 'package:al_adkar/alyaoum/sabah.dart';
import 'package:al_adkar/alyaoum/sleep.dart';
import 'package:al_adkar/alyaoum/wc.dart';

class SabahMassaeScreen extends StatelessWidget {
  const SabahMassaeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'الأذكار اليومية',
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SectionCard(
              title: 'تطبيق إسلامي من الكتاب و السنة',
              backgroundColor: theme.primaryColor.withOpacity(0.95),
              child: const Text(
                'مجموعة من الأذكار اليومية المختارة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 7,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: _buildSectionCard(context, index),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomAppBar(
          color: theme.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'aladkar.com©${DateTime.now().year}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, int index) {
    return SectionCard(
      title: _getPostTitle(index),
      onTap: () => _navigateToSection(context, index),
      backgroundColor:
          Theme.of(context).colorScheme.secondary.withOpacity(0.15),
      child: const SizedBox(height: 8),
    );
  }

  void _navigateToSection(BuildContext context, int index) {
    final routes = [
      Sabah(),
      Eat(),
      Wc(),
      Clothes(),
      House(),
      Massae(),
      Sleep(),
    ];

    if (index < routes.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => routes[index],
        ),
      );
    }
  }

  String _getPostTitle(int index) {
    switch (index) {
      case 0:
        return 'أذكار الصباح';
      case 1:
        return 'أذكار الطعام والشراب';
      case 2:
        return 'اذكار الدخول والخروج من الخلاء';
      case 3:
        return 'اذكار لبس وخلع الثياب';
      case 4:
        return 'اذكار الدخول والخروج من المنزل';
      case 5:
        return 'اذكار المساء';
      case 6:
        return 'اذكار قبل النوم';
      default:
        return '';
    }
  }
}
