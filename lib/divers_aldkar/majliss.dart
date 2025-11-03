// ignore_for_file: use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/dhikr_card.dart';

class Majliss extends StatelessWidget {
  Majliss({Key? key}) : super(key: key);

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
      title: 'دعاء المجلس',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DhikrCard(
              text:
                  'كفارة المجلس: سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ'
                  '\n-----------------------------\n'
                  // Divider line after the text
                  // You can add the Divider widget in the parent Column
                  'من قال هذا في مجلس ذكر كان كالطابع عليه، ومن قاله في مجلس لغو كان كفارة له',
              category: 'دعاء المجلس',
              fontSize: 24,
              textColor: widgetColors[0],
              containerColor: containerColors[0],
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
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
