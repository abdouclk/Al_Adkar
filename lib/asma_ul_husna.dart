// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/app_scaffold.dart';

class AsmaUlHusna extends StatefulWidget {
  const AsmaUlHusna({Key? key}) : super(key: key);

  @override
  State<AsmaUlHusna> createState() => _AsmaUlHusnaState();
}

class _AsmaUlHusnaState extends State<AsmaUlHusna> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _names = [
    {
      'number': '1',
      'arabic': 'الرَّحْمَن',
      'transliteration': 'Ar-Rahman',
      'meaning': 'الرحيم الذي وسعت رحمته كل شيء'
    },
    {
      'number': '2',
      'arabic': 'الرَّحِيم',
      'transliteration': 'Ar-Raheem',
      'meaning': 'ذو الرحمة الواسعة للمؤمنين'
    },
    {
      'number': '3',
      'arabic': 'الْمَلِك',
      'transliteration': 'Al-Malik',
      'meaning': 'المتصرف في ملكه كما يشاء'
    },
    {
      'number': '4',
      'arabic': 'الْقُدُّوس',
      'transliteration': 'Al-Quddus',
      'meaning': 'المنزه عن كل عيب ونقص'
    },
    {
      'number': '5',
      'arabic': 'السَّلاَم',
      'transliteration': 'As-Salam',
      'meaning': 'السالم من النقائص والعيوب'
    },
    {
      'number': '6',
      'arabic': 'الْمُؤْمِن',
      'transliteration': 'Al-Mu\'min',
      'meaning': 'المصدق لوعده والآمن عباده'
    },
    {
      'number': '7',
      'arabic': 'الْمُهَيْمِن',
      'transliteration': 'Al-Muhaymin',
      'meaning': 'الرقيب الحافظ لكل شيء'
    },
    {
      'number': '8',
      'arabic': 'الْعَزِيز',
      'transliteration': 'Al-Aziz',
      'meaning': 'القوي الغالب الذي لا يُغلب'
    },
    {
      'number': '9',
      'arabic': 'الْجَبَّار',
      'transliteration': 'Al-Jabbar',
      'meaning': 'القاهر الذي يجبر الخلق على ما يريد'
    },
    {
      'number': '10',
      'arabic': 'الْمُتَكَبِّر',
      'transliteration': 'Al-Mutakabbir',
      'meaning': 'المتعالي عن صفات الخلق'
    },
    {
      'number': '11',
      'arabic': 'الْخَالِق',
      'transliteration': 'Al-Khaliq',
      'meaning': 'الموجد للأشياء من العدم'
    },
    {
      'number': '12',
      'arabic': 'الْبَارِئ',
      'transliteration': 'Al-Bari',
      'meaning': 'خالق الخلق لا عن مثال'
    },
    {
      'number': '13',
      'arabic': 'الْمُصَوِّر',
      'transliteration': 'Al-Musawwir',
      'meaning': 'المقدر لكل موجود على صورته'
    },
    {
      'number': '14',
      'arabic': 'الْغَفَّار',
      'transliteration': 'Al-Ghaffar',
      'meaning': 'الكثير المغفرة لذنوب عباده'
    },
    {
      'number': '15',
      'arabic': 'الْقَهَّار',
      'transliteration': 'Al-Qahhar',
      'meaning': 'الغالب الذي قهر كل شيء'
    },
    {
      'number': '16',
      'arabic': 'الْوَهَّاب',
      'transliteration': 'Al-Wahhab',
      'meaning': 'كثير العطاء والمنح'
    },
    {
      'number': '17',
      'arabic': 'الرَّزَّاق',
      'transliteration': 'Ar-Razzaq',
      'meaning': 'الذي خلق الرزق ويسره لعباده'
    },
    {
      'number': '18',
      'arabic': 'الْفَتَّاح',
      'transliteration': 'Al-Fattah',
      'meaning': 'الذي يفتح أبواب الخير والرزق'
    },
    {
      'number': '19',
      'arabic': 'اَلْعَلِيْم',
      'transliteration': 'Al-Aleem',
      'meaning': 'المحيط علمه بجميع الأشياء'
    },
    {
      'number': '20',
      'arabic': 'الْقَابِض',
      'transliteration': 'Al-Qabid',
      'meaning': 'الذي يقبض الرزق والأرواح'
    },
    {
      'number': '21',
      'arabic': 'الْبَاسِط',
      'transliteration': 'Al-Basit',
      'meaning': 'الذي يبسط الرزق لمن يشاء'
    },
    {
      'number': '22',
      'arabic': 'الْخَافِض',
      'transliteration': 'Al-Khafid',
      'meaning': 'الذي يخفض الجبابرة والمتكبرين'
    },
    {
      'number': '23',
      'arabic': 'الرَّافِع',
      'transliteration': 'Ar-Rafi',
      'meaning': 'الذي يرفع المؤمنين بالطاعة'
    },
    {
      'number': '24',
      'arabic': 'الْمُعِز',
      'transliteration': 'Al-Mu\'izz',
      'meaning': 'الذي يعز من يشاء من خلقه'
    },
    {
      'number': '25',
      'arabic': 'الْمُذِل',
      'transliteration': 'Al-Mudhill',
      'meaning': 'الذي يذل من يشاء من عباده'
    },
    {
      'number': '26',
      'arabic': 'السَّمِيع',
      'transliteration': 'As-Sami',
      'meaning': 'الذي لا يخفى عليه شيء في الأرض ولا في السماء'
    },
    {
      'number': '27',
      'arabic': 'الْبَصِير',
      'transliteration': 'Al-Baseer',
      'meaning': 'الذي يرى كل شيء مهما دق أو صغر'
    },
    {
      'number': '28',
      'arabic': 'الْحَكَم',
      'transliteration': 'Al-Hakam',
      'meaning': 'الذي يقضي بين عباده بالعدل'
    },
    {
      'number': '29',
      'arabic': 'الْعَدْل',
      'transliteration': 'Al-Adl',
      'meaning': 'المنزه عن الظلم والجور'
    },
    {
      'number': '30',
      'arabic': 'اللَّطِيف',
      'transliteration': 'Al-Latif',
      'meaning': 'اللطيف بعباده الخبير بأحوالهم'
    },
    {
      'number': '31',
      'arabic': 'الْخَبِير',
      'transliteration': 'Al-Khabeer',
      'meaning': 'العليم بحقائق الأمور'
    },
    {
      'number': '32',
      'arabic': 'الْحَلِيم',
      'transliteration': 'Al-Haleem',
      'meaning': 'الذي لا يعجل بالعقوبة'
    },
    {
      'number': '33',
      'arabic': 'الْعَظِيم',
      'transliteration': 'Al-Azeem',
      'meaning': 'الذي لا شيء أعظم منه'
    },
    {
      'number': '34',
      'arabic': 'الْغَفُور',
      'transliteration': 'Al-Ghafoor',
      'meaning': 'الذي يغفر الذنوب ويستر العيوب'
    },
    {
      'number': '35',
      'arabic': 'الشَّكُور',
      'transliteration': 'Ash-Shakoor',
      'meaning': 'الذي يجازي على القليل بالكثير'
    },
    {
      'number': '36',
      'arabic': 'الْعَلِيّ',
      'transliteration': 'Al-Aliyy',
      'meaning': 'الرفيع القدر العالي المكان'
    },
    {
      'number': '37',
      'arabic': 'الْكَبِير',
      'transliteration': 'Al-Kabeer',
      'meaning': 'العظيم الذي لا أعظم منه'
    },
    {
      'number': '38',
      'arabic': 'الْحَفِيظ',
      'transliteration': 'Al-Hafeedh',
      'meaning': 'الحافظ لكل شيء الذي لا يغيب عنه شيء'
    },
    {
      'number': '39',
      'arabic': 'المُقيِت',
      'transliteration': 'Al-Muqeet',
      'meaning': 'الذي يعطي كل مخلوق قوته'
    },
    {
      'number': '40',
      'arabic': 'الْحسِيب',
      'transliteration': 'Al-Haseeb',
      'meaning': 'الكافي لعباده المحاسب لهم'
    },
    {
      'number': '41',
      'arabic': 'الْجَلِيل',
      'transliteration': 'Al-Jaleel',
      'meaning': 'العظيم الجليل'
    },
    {
      'number': '42',
      'arabic': 'الْكَرِيم',
      'transliteration': 'Al-Kareem',
      'meaning': 'الكثير الخير الجواد المعطي'
    },
    {
      'number': '43',
      'arabic': 'الرَّقِيب',
      'transliteration': 'Ar-Raqeeb',
      'meaning': 'الحافظ الذي لا يغفل'
    },
    {
      'number': '44',
      'arabic': 'الْمُجِيب',
      'transliteration': 'Al-Mujeeb',
      'meaning': 'الذي يجيب دعاء من دعاه'
    },
    {
      'number': '45',
      'arabic': 'الْوَاسِع',
      'transliteration': 'Al-Wasi',
      'meaning': 'الذي وسع كرسيه السماوات والأرض'
    },
    {
      'number': '46',
      'arabic': 'الْحَكِيم',
      'transliteration': 'Al-Hakeem',
      'meaning': 'المحكم لأموره المتقن لخلقه'
    },
    {
      'number': '47',
      'arabic': 'الْوَدُود',
      'transliteration': 'Al-Wadud',
      'meaning': 'المحب لعباده الصالحين'
    },
    {
      'number': '48',
      'arabic': 'الْمَجِيد',
      'transliteration': 'Al-Majeed',
      'meaning': 'الشريف العظيم الكريم'
    },
    {
      'number': '49',
      'arabic': 'الْبَاعِث',
      'transliteration': 'Al-Ba\'ith',
      'meaning': 'الذي يبعث الموتى للحساب'
    },
    {
      'number': '50',
      'arabic': 'الشَّهِيد',
      'transliteration': 'Ash-Shaheed',
      'meaning': 'الذي لا يغيب عن علمه شيء'
    },
    {
      'number': '51',
      'arabic': 'الْحَق',
      'transliteration': 'Al-Haqq',
      'meaning': 'الموجود حقاً المتحقق وجوده'
    },
    {
      'number': '52',
      'arabic': 'الْوَكِيل',
      'transliteration': 'Al-Wakeel',
      'meaning': 'الكفيل بأرزاق العباد'
    },
    {
      'number': '53',
      'arabic': 'الْقَوِيّ',
      'transliteration': 'Al-Qawiyy',
      'meaning': 'الكامل القوة الذي لا يعجزه شيء'
    },
    {
      'number': '54',
      'arabic': 'الْمَتِين',
      'transliteration': 'Al-Mateen',
      'meaning': 'الشديد الذي لا يلحقه في أفعاله مشقة'
    },
    {
      'number': '55',
      'arabic': 'الْوَلِيّ',
      'transliteration': 'Al-Waliyy',
      'meaning': 'الناصر المحب المتولي لأمور عباده'
    },
    {
      'number': '56',
      'arabic': 'الْحَمِيد',
      'transliteration': 'Al-Hameed',
      'meaning': 'المستحق للحمد والثناء'
    },
    {
      'number': '57',
      'arabic': 'الْمُحْصِي',
      'transliteration': 'Al-Muhsee',
      'meaning': 'الذي أحصى كل شيء علماً'
    },
    {
      'number': '58',
      'arabic': 'الْمُبْدِئ',
      'transliteration': 'Al-Mubdi',
      'meaning': 'الذي بدأ خلق الأشياء'
    },
    {
      'number': '59',
      'arabic': 'الْمُعِيد',
      'transliteration': 'Al-Mu\'eed',
      'meaning': 'الذي يعيد الخلق بعد الموت'
    },
    {
      'number': '60',
      'arabic': 'الْمُحْيِي',
      'transliteration': 'Al-Muhyi',
      'meaning': 'الذي يحيي الموتى'
    },
    {
      'number': '61',
      'arabic': 'اَلْمُمِيتُ',
      'transliteration': 'Al-Mumeet',
      'meaning': 'الذي يميت الأحياء'
    },
    {
      'number': '62',
      'arabic': 'الْحَيّ',
      'transliteration': 'Al-Hayy',
      'meaning': 'الباقي الذي لا يموت'
    },
    {
      'number': '63',
      'arabic': 'الْقَيُّوم',
      'transliteration': 'Al-Qayyoom',
      'meaning': 'القائم بنفسه الذي قامت به الأشياء'
    },
    {
      'number': '64',
      'arabic': 'الْوَاجِد',
      'transliteration': 'Al-Wajid',
      'meaning': 'الذي لا يحتاج إلى شيء'
    },
    {
      'number': '65',
      'arabic': 'الْمَاجِد',
      'transliteration': 'Al-Majid',
      'meaning': 'الواسع الكرم والمجد'
    },
    {
      'number': '66',
      'arabic': 'الْواحِد',
      'transliteration': 'Al-Wahid',
      'meaning': 'المنفرد الذي لا شريك له'
    },
    {
      'number': '67',
      'arabic': 'اَلاَحَد',
      'transliteration': 'Al-Ahad',
      'meaning': 'الواحد المتفرد في ذاته وصفاته'
    },
    {
      'number': '68',
      'arabic': 'الصَّمَد',
      'transliteration': 'As-Samad',
      'meaning': 'السيد المقصود في الحوائج'
    },
    {
      'number': '69',
      'arabic': 'الْقَادِر',
      'transliteration': 'Al-Qadir',
      'meaning': 'الذي يقدر على كل شيء'
    },
    {
      'number': '70',
      'arabic': 'الْمُقْتَدِر',
      'transliteration': 'Al-Muqtadir',
      'meaning': 'الكامل القدرة الذي لا يعجزه شيء'
    },
    {
      'number': '71',
      'arabic': 'الْمُقَدِّم',
      'transliteration': 'Al-Muqaddim',
      'meaning': 'الذي يقدم من يشاء من عباده'
    },
    {
      'number': '72',
      'arabic': 'الْمُؤَخِّر',
      'transliteration': 'Al-Mu\'akhkhir',
      'meaning': 'الذي يؤخر من يشاء من عباده'
    },
    {
      'number': '73',
      'arabic': 'الأوَّل',
      'transliteration': 'Al-Awwal',
      'meaning': 'الذي لا بداية لوجوده'
    },
    {
      'number': '74',
      'arabic': 'الآخِر',
      'transliteration': 'Al-Akhir',
      'meaning': 'الباقي بعد فناء خلقه'
    },
    {
      'number': '75',
      'arabic': 'الظَّاهِر',
      'transliteration': 'Adh-Dhahir',
      'meaning': 'الظاهر وجوده بدلائله'
    },
    {
      'number': '76',
      'arabic': 'الْبَاطِن',
      'transliteration': 'Al-Batin',
      'meaning': 'العالم ببواطن الأمور'
    },
    {
      'number': '77',
      'arabic': 'الْوَالِي',
      'transliteration': 'Al-Wali',
      'meaning': 'المالك لجميع الأمور'
    },
    {
      'number': '78',
      'arabic': 'الْمُتَعَالِي',
      'transliteration': 'Al-Muta\'ali',
      'meaning': 'المتعالي عن صفات المخلوقين'
    },
    {
      'number': '79',
      'arabic': 'الْبَرُّ',
      'transliteration': 'Al-Barr',
      'meaning': 'الكثير الإحسان العظيم البر'
    },
    {
      'number': '80',
      'arabic': 'التَّوَاب',
      'transliteration': 'At-Tawwab',
      'meaning': 'الذي يقبل التوبة من عباده'
    },
    {
      'number': '81',
      'arabic': 'الْمُنْتَقِم',
      'transliteration': 'Al-Muntaqim',
      'meaning': 'الذي ينتقم من أعدائه'
    },
    {
      'number': '82',
      'arabic': 'العَفُوّ',
      'transliteration': 'Al-Afuww',
      'meaning': 'الذي يمحو الذنوب ويتجاوز عنها'
    },
    {
      'number': '83',
      'arabic': 'الرَّؤُوف',
      'transliteration': 'Ar-Ra\'oof',
      'meaning': 'الرحيم الرفيق بعباده'
    },
    {
      'number': '84',
      'arabic': 'مَالِكُ الْمُلْك',
      'transliteration': 'Malik-ul-Mulk',
      'meaning': 'المتصرف في ملكه كيف يشاء'
    },
    {
      'number': '85',
      'arabic': 'ذُوالْجَلاَلِ وَالإكْرَام',
      'transliteration': 'Dhul-Jalali wal-Ikram',
      'meaning': 'صاحب العظمة والجلال'
    },
    {
      'number': '86',
      'arabic': 'الْمُقْسِط',
      'transliteration': 'Al-Muqsit',
      'meaning': 'العادل في حكمه'
    },
    {
      'number': '87',
      'arabic': 'الْجَامِع',
      'transliteration': 'Al-Jami',
      'meaning': 'الذي يجمع الخلق ليوم الحساب'
    },
    {
      'number': '88',
      'arabic': 'الْغَنِيّ',
      'transliteration': 'Al-Ghaniyy',
      'meaning': 'الذي لا يحتاج إلى أحد'
    },
    {
      'number': '89',
      'arabic': 'الْمُغْنِي',
      'transliteration': 'Al-Mughni',
      'meaning': 'الذي يغني من يشاء من عباده'
    },
    {
      'number': '90',
      'arabic': 'اَلْمَانِعُ',
      'transliteration': 'Al-Mani',
      'meaning': 'الذي يمنع ما يشاء'
    },
    {
      'number': '91',
      'arabic': 'الضَّار',
      'transliteration': 'Ad-Dharr',
      'meaning': 'الذي يقدر على إنزال الضر'
    },
    {
      'number': '92',
      'arabic': 'النَّافِع',
      'transliteration': 'An-Nafi',
      'meaning': 'الذي يقدر على إيصال النفع'
    },
    {
      'number': '93',
      'arabic': 'النُّور',
      'transliteration': 'An-Nur',
      'meaning': 'هادي خلقه من الضلالة'
    },
    {
      'number': '94',
      'arabic': 'الْهَادِي',
      'transliteration': 'Al-Hadi',
      'meaning': 'الدال على الطريق المستقيم'
    },
    {
      'number': '95',
      'arabic': 'الْبَدِيع',
      'transliteration': 'Al-Badi',
      'meaning': 'المبدع لخلقه على غير مثال'
    },
    {
      'number': '96',
      'arabic': 'اَلْبَاقِي',
      'transliteration': 'Al-Baqi',
      'meaning': 'الدائم الذي لا ينتهي'
    },
    {
      'number': '97',
      'arabic': 'الْوَارِث',
      'transliteration': 'Al-Warith',
      'meaning': 'الباقي بعد فناء خلقه'
    },
    {
      'number': '98',
      'arabic': 'الرَّشِيد',
      'transliteration': 'Ar-Rasheed',
      'meaning': 'الذي أرشد الخلق إلى مصالحهم'
    },
    {
      'number': '99',
      'arabic': 'الصَّبُور',
      'transliteration': 'As-Saboor',
      'meaning': 'الذي لا يعاجل العصاة بالعقوبة'
    },
  ];

  List<Map<String, String>> get _filteredNames {
    if (_searchQuery.isEmpty) return _names;
    return _names.where((name) {
      return name['arabic']!.contains(_searchQuery) ||
          name['transliteration']!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          name['meaning']!.contains(_searchQuery);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredNames;

    return AppScaffold(
      title: 'أسماء الله الحسنى',
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'ابحث عن اسم...',
                hintStyle: GoogleFonts.cairo(color: Colors.grey),
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).primaryColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'عدد الأسماء: ${filteredList.length} من 99',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

          // Names Grid
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد نتائج',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return _buildNameCard(filteredList[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCard(Map<String, String> name) {
    return GestureDetector(
      onTap: () => _showNameDetails(name),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Number badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                name['number']!,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Arabic name
            Text(
              name['arabic']!,
              style: GoogleFonts.amiri(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),

            // Transliteration
            Text(
              name['transliteration']!,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showNameDetails(Map<String, String> name) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Number badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'الاسم رقم ${name['number']}',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Arabic name - large
              Text(
                name['arabic']!,
                style: GoogleFonts.amiri(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 12),

              // Transliteration
              Text(
                name['transliteration']!,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),

              // Divider
              Container(
                height: 2,
                width: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Theme.of(context).primaryColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Meaning
              Text(
                'المعنى',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                name['meaning']!,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  height: 1.8,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),

              // Close button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'إغلاق',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
