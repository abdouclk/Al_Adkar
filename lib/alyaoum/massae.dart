// ignore_for_file: use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/dhikr_card.dart';

class Massae extends StatelessWidget {
  Massae({Key? key}) : super(key: key);

  // Define a list of colors for each widget
  final List<Color> widgetColors = [
    Colors.black, // Color for widget 0
    Colors.black, // Color for widget 1
    Colors.black, // Color for widget 2
    Colors.black, // Color for widget 3
    Colors.black, // Color for widget 4
    Colors.black, // Color for widget 5
    Colors.black, // Color for widget 6
    Colors.black, // Color for widget 7
    Colors.black, // Color for widget 8
    Colors.black, // Color for widget 9
    Colors.black, // Color for widget 10
    Colors.black, // Color for widget 11
    Colors.black, // Color for widget 12
  ];

  // Define a list of colors for the containers of the widgets
  final List<Color> containerColors = [
    Colors.white, // Color for container of widget 0
    Colors.white, // Color for container of widget 1
    Colors.white, // Color for container of widget 2
    Colors.white, // Color for container of widget 3
    Colors.white, // Color for container of widget 4
    Colors.white, // Color for container of widget 5
    Colors.white, // Color for container of widget 6
    Colors.white, // Color for container of widget 7
    Colors.white, // Color for container of widget 8
    Colors.white, // Color for container of widget 9
    Colors.white, // Color for container of widget 10
    Colors.white, // Color for container of widget 11
    Colors.white, // Color for container of widget 12
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'أذكار المساء',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            SectionCard(
              title: '',
              child: Text(
                ' قالَ رسولُ اللَّهِ صَلّى اللهُ عَلَيْهِ وسَلَّم ',
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 1),
            DhikrCard(
              text:
                  'مَنْ قال حِينَ يُصْبِحُ وحينَ يُمسِي : سُبْحانَ اللَّهِ وبحمدِهِ مِائَةَ مَرةٍ لَم يأْتِ أَحدٌ يوْم القِيامة بأَفضَلِ مِما جَاءَ بِهِ ، إِلاَّ أَحدٌ قال مِثلَ مَا قال أَوْ زَادَ ',
              category: 'أذكار المساء',
              fontSize: 28,
              textColor: widgetColors[2],
              containerColor: containerColors[2],
            ),
            SizedBox(height: 20),
            DhikrCard(
              text:
                  ' أعُوذُ بِكَلماتِ اللَّهِ التَّامَّاتِ منْ شَرِّ ما خَلَقَ',
              category: 'أذكار المساء',
              fontSize: 28,
              textColor: widgetColors[2],
              containerColor: containerColors[2],
            ),
            SizedBox(height: 20),
            DhikrCard(
              text:
                  'اللَّهُمَّ بِكَ أَصْبحْنَا وبِكَ أَمسَيْنَا وبِكَ نَحْيا ، وبِكَ نَمُوتُ ، وَإِلَيْكَ النُّشُورُ',
              category: 'أذكار المساء',
              fontSize: 28,
              textColor: widgetColors[3],
              containerColor: containerColors[3],
            ),
            SizedBox(height: 20),
            DhikrCard(
              text:
                  'اللَّهُمَّ فَاطِرَ السَّمَواتِ والأرضِ عَالمَ الغَيْب وَالشَّهَادةِ ، ربَّ كُلِّ شَيءٍ وَمَلِيكَهُ . أَشْهَدُ أَن لاَ إِله إِلاَّ أَنتَ ، أَعُوذُ بكَ منْ شَرِّ نَفسي وشَرِّ الشَّيْطَانِ وَشِرْكهِ',
              category: 'أذكار المساء',
              fontSize: 28,
              textColor: widgetColors[4],
              containerColor: containerColors[4],
            ),
            SizedBox(height: 20),
            SectionCard(
              title: '',
              child: Text(
                ' قالَ رسولُ اللَّهِ صَلّى اللهُ عَلَيْهِ وسَلَّم ',
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 1),
            DhikrCard(
              text:
                  ' اقْرأْ : قُلْ هوَ اللَّه أَحَدٌ ، والمعوِّذَتَيْن حِينَ تُمْسِي وَحِينَ تُصبِحُ ، ثَلاثَ مَرَّاتٍ تَكْفِيكَ مِنْ كلِّ شَيْءٍ  ',
              category: 'أذكار المساء',
              fontSize: 28,
              textColor: widgetColors[6],
              containerColor: containerColors[6],
            ),
            SizedBox(height: 20),
            SectionCard(
              title: '',
              child: Text(
                ' قالَ رسولُ اللَّهِ صَلّى اللهُ عَلَيْهِ وسَلَّم ',
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 1),
            DhikrCard(
              text:
                  'مَا مِنْ عَبْدٍ يَقُولُ في صَبَاحِ كلِّ يَوْمٍ ومَسَاءٍ كلِّ لَيْلَةٍ : بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَع اسْمِهِ شيء في الأرضِ ولا في السماءِ وَهُوَ السَّمِيعُ الْعلِيمُ ، ثلاثَ مَرَّاتٍ ، إِلاَّ لَمْ يَضُرَّهُ شَيءٌ',
              category: 'أذكار المساء',
              fontSize: 28,
              textColor: widgetColors[8],
              containerColor: containerColors[8],
            ),
            SizedBox(height: 20),
            DhikrCard(
              text:
                  'اللَّهُمَّ عِافِنِي في بصَري, لا إلهَ إلا أنتَ. اللَّهُمَّ إنّي أعُوذُ بِكَ مِنَ الكُفْرِ, وَ الفَقْرِ, اللَّهُمَّ إنِّي أعُوذُ بِكَ مِنْ عَذَابِ القَبْرِ, لا إلهَ إلا أَنْتَ\n-----------------------------\n'
                  'ثَلاثاً حِينَ تُصْبحُ, وثَلاثاً حِينَ تُمسِي',
              category: 'أذكار المساء',
              fontSize: 28,
              textColor: widgetColors[9],
              containerColor: containerColors[9],
            ),
            SizedBox(height: 20),
            DhikrCard(
              text:
                  'سبحان الله وبحمده ، عدد خلقه ، ورضا نفسه ، وزنة عرشه ، ومداد كلماته\n'
                  '-----------------------------\n'
                  'ثَلاثاً حِينَ تُصْبحُ, وثَلاثاً حِينَ تُمسِي',
              category: 'أذكار المساء',
              fontSize: 28,
              textColor: widgetColors[11],
              containerColor: containerColors[11],
            ),
            SizedBox(height: 20),
            DhikrCard(
              text:
                  'سَيِّدُ الاستغفار: اللهـمَّ أَنتَ ربِّي, لا إلهَ إلا أنتَ, خَلَقْتَني, وأَنا عبدُكَ, وأَنا على عهدِكَ ووعدِكَ, ما استَطَعْتُ, أعـوذُ بـكَ مِن شرِّ ما صَنَعْتُ, أبوءُ لكَ بنِعْمَتِكَ عليِّ, وأَبوءُ لَكَ بذَنبي, فاغفِرْ لي, فإنَّه لا يَغفِرُ الذُّنوبَ إلا أَنتَ\n-----------------------------\n'
                  'مَن قالَها مِنَ النَّهارِ مُوقِناً بِهَا, فَماتَ مِنْ يَوْمِه قَبْلَ أَنْ يُمْسي, فَهو مِنْ أَهْلِ الجنَّة, وَمَنْ قَالَها مِنْ اللّيِل وَهُو مُوقِنٌ بِها, فَماتَ قَبْلَ أَنْ يُصْبح, فَهو مِنْ أهْل الجنَّة',
              category: 'أذكار المساء',
              fontSize: 28,
              textColor: widgetColors[0],
              containerColor: containerColors[0],
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
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

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Search results for: $query');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('Suggestions for: $query');
  }
}
