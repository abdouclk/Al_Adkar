// ignore_for_file: use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class Tahlil extends StatefulWidget {
  Tahlil({Key? key}) : super(key: key);

  @override
  State<Tahlil> createState() => _TahlilState();
}

class _TahlilState extends State<Tahlil> {
  int _counter = 0;

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
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'التهليل',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextWidget(
              'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
              fontSize: 24,
              textColor: widgetColors[0],
              containerColor: containerColors[0],
            ),
            SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Text('$_counter / 100',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _counter < 100
                            ? () => setState(() => _counter++)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(24),
                        ),
                        child: Icon(Icons.add, size: 32, color: Colors.white),
                      ),
                      SizedBox(width: 24),
                      ElevatedButton(
                        onPressed: _counter > 0
                            ? () => setState(() => _counter = 0)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(24),
                        ),
                        child:
                            Icon(Icons.refresh, size: 32, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text('اضغط الزر وكرر الذكر حتى تصل إلى 100',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      )),
                ],
              ),
            ),
            SizedBox(height: 32),
            _buildTextWidget(
              'من قالها مائة مرة في يوم كانت له عدل عشر رقاب، وكُتبت له مائة حسنة، ومُحيت عنه مائة سيئة، وكانت له حرزاً من الشيطان',
              fontSize: 20,
              textColor: widgetColors[1],
              containerColor: containerColors[1],
            ),
            SizedBox(height: 20),
            _buildTextWidget(
              'لاَ إِلَهَ إِلاَّ اللَّهُ (أفضل الذكر)',
              fontSize: 28,
              textColor: widgetColors[2],
              containerColor: containerColors[2],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWidget(
    String text, {
    double fontSize = 24,
    Color textColor = const Color.fromARGB(255, 0, 0, 0),
    Color containerColor = const Color.fromARGB(255, 255, 255, 255),
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveTextColor =
        isDark ? theme.colorScheme.onSurface : textColor;
    final effectiveContainerColor =
        isDark ? theme.colorScheme.surface : containerColor;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: effectiveContainerColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: effectiveTextColor,
        ),
        textAlign: TextAlign.center,
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
