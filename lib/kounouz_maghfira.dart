// ignore_for_file: prefer_const_constructors, unused_element, use_super_parameters, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'widgets/app_scaffold.dart';

class KounouzMaghfira extends StatelessWidget {
  const KounouzMaghfira({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> texts = [
      'قال الله عز و جل : إِنَّ اللَّهَ لَا يَغْفِرُ أَنْ يُشْرَكَ بِهِ وَيَغْفِرُ مَا دُونَ ذَلِكَ لِمَنْ يَشَاءُ',
      'من صام رمضان إيمانا واحتسابا غفر له ما تقدم من ذنبه',
      'من قام ليلة القدر إيمانا واحتسابا غفر له ما تقدم من ذنبه',
      'من توضأ نحو وضوئي هذا ثم صلى ركعتين لا يحدث فيها نفسه غفر له ما تقدم من ذنبه',
      'إذا قال الإمام سمع الله لمن حمده فقولوا: اللهم ربنا لك الحمد، فإنه من وافق قوله قول الملائكة غفر له ما تقدم من ذنبه',
      'إذا أمن الإمام فأمنوا فإنه من وافق تأمينه تأمين الملائكة غفر له ما تقدم من ذنبه',
      'من أكل طعاما فقال الحمد لله الذي أطعمني هذا ورزقنيه من غير حول مني ولا قوة غفر له ما تقدم من ذنبه',
      'من حج لله فلم يرفث ولم يفسق رجع كيوم ولدته أمه',
      ' الصلوات الخمس والجمعة إلى الجمعة ورمضان إلى رمضان مكفرات لما بينهن إذا اجتنبت الكبائر',
      'الَّلهمَّ اقْسِم لَنَا مِنْ خَشْيَتِكَ ما تحُولُ بِه بَيْنَنَا وبَينَ مَعٌصَِيتِك، ومن طَاعَتِكَ ماتُبَلِّغُنَا بِه جَنَّتَكَ، ومِنَ اْليَقيٍن ماتُهِوِّنُ بِه عَلَيْنا مَصَائِبَ الدُّنيَا . الَّلهُمَّ مَتِّعْنا بأسْمَاعِناَ، وأبْصَارناَ، وِقُوّتِنا ما أحييْتَنَا ، واجْعَلْهُ الوَارِثَ منَّا ، وِاجعَل ثَأرَنَا عَلى مَنْ ظَلَمَنَا، وانْصُرْنا عَلى مَنْ عادَانَا ، وَلا تَجْعلْ مُِصيَبتَنا في دينَنا ، وَلا تَجْعلِ الدُّنْيَا أكبَرَ همِّنا ولا مبلغ عِلْمٍنَا ، وَلا تُسَلِّط عَلَيَنَا مَنْ لا يْرْحَمُناَ',
    ];

    return AppScaffold(
      title: 'كنوز المغفرة',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionCard(
              title: 'أحاديث صحيحة تنص على أعمال يغفر لعاملها ما تقدم من ذنبه',
              child: const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            ...texts.map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SectionCard(
                    title: '',
                    child: Builder(
                      builder: (context) => Text(
                        text,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Theme.of(context).textTheme.bodyLarge?.color ?? 
                                 (Theme.of(context).brightness == Brightness.dark 
                                   ? Colors.white 
                                   : Colors.black87),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) => Text(
                'aladkar.com©${DateTime.now().year}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ??
                         (Theme.of(context).brightness == Brightness.dark
                           ? Colors.white70
                           : Color.fromARGB(211, 0, 0, 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
