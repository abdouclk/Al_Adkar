// ignore_for_file: use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/dhikr_card.dart';

class House extends StatelessWidget {
  House({Key? key}) : super(key: key);

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
      title: 'أذكار دخول وخروج المنزل',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DhikrCard(
              text:
                  'دُعَاءُ دُخُولِ المَنْزِلِ: بِسْمِ اللهِ وَلَجْنَا، وَبِسْمِ اللهِ خَرَجْنَا، وَعَلَى اللهِ رَبِّنَا تَوَكَّلْنَا',
              category: 'أذكار المنزل',
              fontSize: 24,
              textColor: widgetColors[0],
              containerColor: containerColors[0],
            ),
            SizedBox(height: 20),
            DhikrCard(
              text:
                  'دُعَاءُ الخُرُوجِ مِنَ المَنْزِلِ: بِسْمِ اللهِ، تَوَكَّلْتُ عَلَى اللهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
              category: 'أذكار المنزل',
              fontSize: 24,
              textColor: widgetColors[1],
              containerColor: containerColors[1],
            ),
            SizedBox(height: 20),
            DhikrCard(
              text:
                  'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أَضِلَّ أَوْ أُضَلَّ، أَوْ أَزِلَّ أَوْ أُزَلَّ، أَوْ أَظْلِمَ أَوْ أُظْلَمَ، أَوْ أَجْهَلَ أَوْ يُجْهَلَ عَلَيَّ',
              category: 'أذكار المنزل',
              fontSize: 22,
              textColor: widgetColors[2],
              containerColor: containerColors[2],
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
