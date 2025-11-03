# Al-Adkar | تطبيق الأذكار

<div align="center">

**🕌 Islamic Adhkar & Prayer Times App**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

*من الكتاب والسنة*

[English](#english) | [العربية](#arabic)

</div>

---

## English

### 📱 About

**Al-Adkar** is a comprehensive Islamic companion app built with Flutter, featuring:

- ⏰ **Precise Prayer Times** – Location-based calculations with next-prayer notifications
- 🌅 **Morning & Evening Adhkar** – Scheduled reminders with exact alarm support (Android 12+)
- 📖 **Daily Quranic Dua** – Rotating inspirational verses
- 📻 **Quran Radio** – Live streaming
- 🧭 **Qibla Compass** – Find prayer direction
- 📿 **Tasbih Counter** – Digital dhikr tracker
- 📆 **Hijri Calendar** – Islamic date converter
- ⭐ **Favorites** – Save your most-used duas
- 🎨 **Beautiful UI** – Arabic RTL interface with Google Fonts (Cairo)
- 🌙 **Dark Mode** – Eye-friendly theme

### ✨ Key Features

- **Exact Notifications**: Uses `exactAllowWhileIdle` for reliable scheduling on Android 13+
- **Location-Aware**: GPS-based prayer times with automatic timezone detection
- **Offline-Ready**: Core features work without internet
- **Customizable**: Adjustable notification times, font size, and themes
- **Privacy-First**: No analytics, no tracking—your data stays on your device

### 🚀 Getting Started

#### Prerequisites
- Flutter SDK 3.0+
- Android Studio / Xcode
- Android 5.0+ / iOS 12+

#### Installation

```bash
# Clone the repository
git clone https://github.com/<your-username>/Al-Adkar.git

# Navigate to project
cd Al-Adkar

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

#### Build Release APK

```bash
flutter build apk --release
```

The APK will be in `build/app/outputs/flutter-apk/app-release.apk`.

### 🔧 Configuration

#### Android Permissions
The app requests:
- **Notifications** (Android 13+)
- **Exact Alarms** (Android 12+)
- **Location** (for prayer times)

#### iOS Setup
Location permissions are pre-configured in `Info.plist`.

### 📦 Dependencies

- `flutter_local_notifications` – Scheduled notifications
- `timezone` – Timezone handling
- `geolocator` – GPS location
- `adhan` – Prayer time calculations
- `google_fonts` – Cairo Arabic font
- `audioplayers` – Quran radio streaming
- `shared_preferences` – Local settings storage

### 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repo
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 🙏 Acknowledgments

- Islamic content sourced from authentic Quran and Sunnah references
- Prayer time calculations via the [adhan](https://pub.dev/packages/adhan) package
- UI inspiration from modern Islamic apps

---

## Arabic

<div dir="rtl" align="right">

### 📱 عن التطبيق

**تطبيق الأذكار** هو تطبيق إسلامي شامل مبني بتقنية Flutter، يتضمن:

- ⏰ **أوقات الصلاة الدقيقة** – حسابات تعتمد على الموقع مع تنبيهات للصلاة القادمة
- 🌅 **أذكار الصباح والمساء** – تذكيرات مجدولة مع دعم المنبهات الدقيقة (أندرويد 12+)
- 📖 **دعاء اليوم من القرآن** – آيات ملهمة تتغير يوميًا
- 📻 **إذاعة القرآن الكريم** – بث مباشر
- 🧭 **اتجاه القبلة** – بوصلة لتحديد اتجاه الصلاة
- 📿 **عداد التسبيح** – مسبحة رقمية
- 📆 **التقويم الهجري** – محول التاريخ الإسلامي
- ⭐ **المفضلة** – احفظ الأدعية الأكثر استخدامًا
- 🎨 **واجهة جميلة** – تصميم عربي من اليمين لليسار بخط Cairo
- 🌙 **الوضع الليلي** – مريح للعين

### ✨ المميزات الرئيسية

- **إشعارات دقيقة**: يستخدم `exactAllowWhileIdle` لجدولة موثوقة على أندرويد 13+
- **يدعم الموقع**: أوقات الصلاة بناءً على GPS مع اكتشاف تلقائي للمنطقة الزمنية
- **يعمل بدون إنترنت**: الميزات الأساسية لا تحتاج اتصال
- **قابل للتخصيص**: أوقات الإشعارات، حجم الخط، والثيمات
- **خصوصية أولاً**: لا تحليلات، لا تتبع—بياناتك تبقى على جهازك

### 🚀 البدء

#### المتطلبات
- Flutter SDK 3.0+
- Android Studio أو Xcode
- أندرويد 5.0+ أو iOS 12+

#### التثبيت

```bash
# استنساخ المشروع
git clone https://github.com/<your-username>/Al-Adkar.git

# الانتقال للمجلد
cd Al-Adkar

# تثبيت الحزم
flutter pub get

# تشغيل على الجهاز
flutter run
```

#### بناء APK للإصدار

```bash
flutter build apk --release
```

ستجد الملف في `build/app/outputs/flutter-apk/app-release.apk`.

### 🔧 الإعدادات

#### صلاحيات أندرويد
يطلب التطبيق:
- **الإشعارات** (أندرويد 13+)
- **المنبهات الدقيقة** (أندرويد 12+)
- **الموقع** (لأوقات الصلاة)

#### إعداد iOS
صلاحيات الموقع مُعدّة مسبقًا في `Info.plist`.

### 📦 الحزم المستخدمة

- `flutter_local_notifications` – الإشعارات المجدولة
- `timezone` – معالجة المناطق الزمنية
- `geolocator` – تحديد الموقع GPS
- `adhan` – حساب أوقات الصلاة
- `google_fonts` – خط Cairo العربي
- `audioplayers` – بث إذاعة القرآن
- `shared_preferences` – تخزين الإعدادات محليًا

### 🤝 المساهمة

المساهمات مرحب بها! يرجى:
1. عمل Fork للمشروع
2. إنشاء فرع للميزة (`git checkout -b feature/amazing-feature`)
3. حفظ التغييرات (`git commit -m 'إضافة ميزة رائعة'`)
4. رفع الفرع (`git push origin feature/amazing-feature`)
5. فتح Pull Request

### 📄 الترخيص

هذا المشروع مرخص بموجب MIT License - انظر ملف [LICENSE](LICENSE) للتفاصيل.

### 🙏 شكر وتقدير

- المحتوى الإسلامي من مصادر موثوقة من القرآن والسنة
- حسابات أوقات الصلاة عبر حزمة [adhan](https://pub.dev/packages/adhan)
- الإلهام من تطبيقات إسلامية حديثة

</div>

---

<div align="center">

**Made with ❤️ for the Muslim Ummah**

**صُنع بـ ❤️ للأمة الإسلامية**

</div>
