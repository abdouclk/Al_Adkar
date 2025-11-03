// ignore_for_file: prefer_const_constructors, use_super_parameters, use_key_in_widget_constructors, unused_element, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:al_adkar/tassbih/istighfar.dart';
import 'package:al_adkar/tassbih/salat_nabii.dart';
import 'package:al_adkar/tassbih/soubhanallah.dart';
import 'package:al_adkar/tassbih/tahlil.dart';
import 'main.dart';

class Tassbih extends StatelessWidget {
  const Tassbih({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 52, 160, 218),
        title: Text(
          'تحت رعاية موقع الأذكار',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 229, 232, 241),
              Color.fromARGB(255, 85, 167, 239)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 90, 93, 243),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'وَإِنْ مِنْ شَيْءٍ إِلاَّ يُسَبِّحُ بِحَمْدِهِ وَلَكِنْ لاَ تَفْقَهُونَ تَسْبِيحَهُمْ',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  GridItem(
                    text: 'التسبيح',
                    textColor: Colors.white,
                    containerColor: Colors.blue,
                    fontSize: 21.0,
                    route: Soubhanallah(),
                  ),
                  GridItem(
                    text: 'التهليل',
                    textColor: Colors.black,
                    containerColor: Color.fromARGB(255, 70, 230, 180),
                    fontSize: 21.0,
                    route: Tahlil(),
                  ),
                  GridItem(
                    text: '''الصلاة على النبي''',
                    textColor: Colors.black,
                    containerColor: Color.fromARGB(255, 70, 230, 180),
                    fontSize: 21.0,
                    route: SalatNabii(),
                  ),
                  GridItem(
                    text: 'الإستغفار',
                    textColor: Colors.white,
                    containerColor: Colors.blue,
                    fontSize: 21.0,
                    route: Istighfar(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'aladkar.com©${DateTime.now().year}',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
          label: Text(
            'الرئيسية',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(Icons.home),
          backgroundColor: Color.fromARGB(255, 134, 217, 230),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class GridItem extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color containerColor;
  final double fontSize;
  final Widget route;

  const GridItem({
    required this.text,
    required this.textColor,
    required this.containerColor,
    required this.fontSize,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Example route classes for demonstration

class Item2Route extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Text(''),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'aladkar.com©${DateTime.now().year}',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWidget(
    String text, {
    double fontSize = 24,
    Color textColor = const Color.fromARGB(255, 204, 230, 167),
    Color containerColor = const Color.fromARGB(255, 235, 247, 180),
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
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

class CustomSearchDelegate22 extends SearchDelegate<String> {
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
    // Implement your search results here
    return Text('النتيجة: $query');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement your search suggestions here
    return Text('أبحث عن: $query');
  }
}
