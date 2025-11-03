// ignore_for_file: use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/dhikr_card.dart';

class Eat extends StatelessWidget {
  Eat({Key? key}) : super(key: key);

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
      title: 'أذكار الطعام والشراب',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  'إذا أكل أَحَدُكُمْ فَليَذْكُر اسْمَ اللَّه تعالى، فإنْ نسي أَنْ يَذْكُرَ اسْمَ اللَّه تَعَالَى في أَوَّلِهِ، فَليَقُلْ: بِسْمِ اللَّه أَوَّلَهُ وَآخِرَهُ',
              category: 'أذكار الطعام',
              fontSize: 28,
              textColor: widgetColors[3],
              containerColor: containerColors[3],
            ),
            SizedBox(height: 10),
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
                  'منْ أَكَلَ طَعَاماً فقال: الحَمْدُ للَّهِ الذي أَطْعَمَني هذا، وَرَزَقْنِيهِ مِنْ غيْرِ حَوْلٍ مِنِّي وَلا قُوّةٍ، غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
              category: 'أذكار الطعام',
              fontSize: 28,
              textColor: widgetColors[3],
              containerColor: containerColors[3],
            ),
            SizedBox(height: 20),
            DhikrCard(
              text:
                  'عن ابن عباس رضي الله عنهما أن النبي صلى الله عليه وسلم نهى أن يتنفس في الإناء أو ينفخ فيه',
              category: 'أذكار الطعام',
              fontSize: 28,
              textColor: widgetColors[4],
              containerColor: containerColors[4],
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
