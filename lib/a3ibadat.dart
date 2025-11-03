// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:al_adkar/widgets/app_scaffold.dart';
import 'package:al_adkar/a3ibadat/woudoue.dart';
import 'package:al_adkar/a3ibadat/istikhara.dart';
import 'package:al_adkar/a3ibadat/go_mosque.dart';
import 'package:al_adkar/a3ibadat/mosque_in_out.dart';
import 'package:al_adkar/a3ibadat/after_pray.dart';
import 'package:al_adkar/a3ibadat/adan.dart';
import 'package:al_adkar/a3ibadat/jeune.dart';

class A3ibadat extends StatelessWidget {
  const A3ibadat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'أذكار العبادات',
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SectionCard(
              title: 'تطبيق إسلامي من الكتاب و السنة',
              backgroundColor: theme.primaryColor.withOpacity(0.95),
              child: const Text(
                'مجموعة مختارة من أذكار العبادات',
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
      Adan(),
      Woudoue(),
      GoMosque(),
      MosqueInOut(),
      AfterPray(),
      Istikhara(),
      Jeune(),
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
        return 'اذكار عند سماع الاذان';
      case 1:
        return 'اذكار بعد الوضوء';
      case 2:
        return 'دعاء الخروج إلى المسجد';
      case 3:
        return 'دعاء الدخول الى المسجد والخروج منه';
      case 4:
        return 'اذكار بعد الصلاة';
      case 5:
        return 'دعاء صلاة الاستخارة';
      case 6:
        return 'دعاء الصائم عند الإفطار';
      default:
        return '';
    }
  }
}
