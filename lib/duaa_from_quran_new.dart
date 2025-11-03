// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'main.dart';
import 'widgets/app_scaffold.dart';

class DuaaFromQuran extends StatelessWidget {
  const DuaaFromQuran({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'تحت رعاية موقع الأذكار',
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'أدعية من القرآن الكريم',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: theme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ..._buildDuaaList(theme),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
          label: const Text(
            'الرئيسية',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(Icons.home),
          backgroundColor: theme.colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© \${DateTime.now().year} aladkar.com',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDuaaList(ThemeData theme) {
    final List<Map<String, String>> duaas = [
      {
        'text':
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ [1] الرَّحْمَنِ الرَّحِيمِ [2] مَالِكِ يَوْمِ الدِّينِ [3] إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ [4] اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ [5] صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ [6] غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ [7]',
        'source': '[الفاتحة:1- 7]'
      },
      {
        'text':
            'الْحَمْدُ لِلَّهِ فَاطِرِ السَّمَاوَاتِ وَالْأَرْضِ جَاعِلِ الْمَلَائِكَةِ رُسُلًا أُولِي أَجْنِحَةٍ مَثْنَى وَثُلَاثَ وَرُبَاعَ يَزِيدُ فِي الْخَلْقِ مَا يَشَاءُ إِنَّ اللَّهَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ [1]',
        'source': '[فاطر:1]'
      },
      // Add all other duaas here
    ];

    return duaas
        .expand((duaa) => [
              SectionCard(
                title: duaa['source']!,
                backgroundColor: Colors.white,
                child: Text(
                  duaa['text']!,
                  style: TextStyle(
                    fontSize: 26,
                    color: theme.primaryColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 16),
            ])
        .toList();
  }
}
