// ignore_for_file: use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class SalatNabii extends StatefulWidget {
  SalatNabii({Key? key}) : super(key: key);

  @override
  State<SalatNabii> createState() => _SalatNabiiState();
}

class _SalatNabiiState extends State<SalatNabii> {
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
    return AppScaffold(
      title: 'الصلاة على النبي',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextWidget(
              'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ',
              fontSize: 24,
              textColor: widgetColors[0],
              containerColor: containerColors[0],
            ),
            SizedBox(height: 32),
            _buildTextWidget(
              'اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ',
              fontSize: 24,
              textColor: widgetColors[1],
              containerColor: containerColors[1],
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
                      style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildTextWidget(
              'من صلى علي واحدة صلى الله عليه بها عشراً',
              fontSize: 20,
              textColor: widgetColors[2],
              containerColor: containerColors[2],
            ),
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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: containerColor,
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
          color: textColor,
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
