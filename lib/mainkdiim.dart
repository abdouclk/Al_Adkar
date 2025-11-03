// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arabic_font/arabic_font.dart';

// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:al_adkar/alyaoum/house.dart';
import 'package:al_adkar/sabah_massae.dart';
import 'package:al_adkar/a3ibadat.dart';
import 'package:al_adkar/contact.dart';
import 'package:al_adkar/divers_adkar.dart';
import 'package:al_adkar/duaa_from_quran.dart';
import 'package:al_adkar/duaa_from_sunnah.dart';
import 'package:al_adkar/kounouz_maghfira.dart';
import 'package:al_adkar/quibla.dart';
import 'package:al_adkar/tassbih.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily:
            ArabicThemeData.font(arabicFont: ArabicFont.dinNextLTArabic),
        package: ArabicThemeData.package,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 85, 167, 239),
          title: const Text(
            'تحت رعاية موقع الأذكار',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Color.fromARGB(255, 229, 232, 241),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    color: Color.fromARGB(255, 90, 93, 243),
                    child: const Text(
                      'تطبيق إسلامي من الكتاب و السنة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 239, 240, 237),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 7,
                itemBuilder: (context, index) {
                  // Define a list of colors
                  List<Color> colors = [
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                    Color.fromARGB(255, 90, 93, 243),
                  ];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: ListTile(
                        tileColor:
                            colors[index], // Set the color of the ListTile
                        title: Center(
                          child: Text(
                            _getPostTitle(index),
                            style: const TextStyle(
                              fontSize: 27,

                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 246, 246, 245), // Text color
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          if (index == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SabahMassaeScreen(),
                              ),
                            );
                          } else if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Builder(
                                        builder: (context) => A3ibadat(),
                                      )),
                            );
                          } else if (index == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Builder(
                                        builder: (context) => DiversAdkar(),
                                      )),
                            );
                          } else if (index == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Builder(
                                        builder: (context) => KounouzMaghfira(),
                                      )),
                            );
                          } else if (index == 4) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Builder(
                                        builder: (context) => Tassbih(),
                                      )),
                            );
                          } else if (index == 5) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Builder(
                                        builder: (context) => DuaaFromSunnah(),
                                      )),
                            );
                          } else if (index == 6) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Builder(
                                        builder: (context) => DuaaFromQuran(),
                                      )),
                            );
                          } else {
                            // Navigate to other screens based on the index
                          }
                        },
                      ));
                },
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
      ),
    );
  }

  String _getPostTitle(int index) {
    switch (index) {
      case 0:
        return ('أذكار اليوم و الليلة');
      case 1:
        return 'اذكار العبادات';
      case 2:
        return 'أذكار متنوعة';
      case 3:
        return 'كنوز المغفرة';
      case 4:
        return 'كنوز الحسنات';
      case 5:
        return 'أدعية من السنة النبوية';
      case 6:
        return 'أدعية من القرآن الكريم';

      default:
        return '';
    }
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
    // Implement your search results here
    return Text('Search results for: $query');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement your search suggestions here
    return Text('Suggestions for: $query');
  }
}
