# Al-Adkar Flutter App - AI Coding Agent Instructions

## Project Overview
Al-Adkar is a comprehensive Islamic companion app built with **Flutter 3.0+** and **Dart 3.3+** targeting Android/iOS. The app provides daily Islamic prayers (adhkar), precise prayer times, Qibla direction, Quran radio, and favorites management—all with a beautiful Arabic RTL interface using Google Fonts (Cairo).

**Core Identity**: Privacy-first, offline-capable, notification-driven Islamic adhkar app for the Muslim Ummah.

## Critical Architecture Patterns

### 1. Widget Hierarchy & Reusability
- **All screens MUST use `AppScaffold`** from `lib/widgets/app_scaffold.dart` for consistent layout, theme application, and footer
- **All dhikr/adkar content MUST use `DhikrCard`** from `lib/widgets/dhikr_card.dart` (includes automatic favorites integration)
- Replace legacy `_buildTextWidget()` patterns with `DhikrCard` when updating old screens

```dart
// ✅ CORRECT: Modern pattern with favorites
import '../widgets/app_scaffold.dart';
import '../widgets/dhikr_card.dart';

DhikrCard(
  text: 'أَسْتَغْفِرُ اللَّهَ',
  category: 'أذكار الصباح', // Screen category name for favorites grouping
  source: 'رواه مسلم',      // Optional hadith reference
  fontSize: 24,
  textColor: widgetColors[0],
  containerColor: containerColors[0],
)

// ❌ AVOID: Legacy pattern (pre-favorites)
_buildTextWidget('أَسْتَغْفِرُ اللَّهَ', ...)
```

### 2. State Management Philosophy
- **Lightweight SharedPreferences for all persistence** (settings, favorites, notification schedules)
- **StatefulWidget only when necessary** (timers, animations, user input forms)
- **StatelessWidget for display-only screens** (static adhkar lists, info pages)
- No Redux/Bloc/Riverpod—keep it simple with local state + SharedPreferences

### 3. Notification System (Critical for UX)
**Android 12+ Exact Alarm Compliance**:
- Use `AndroidScheduleMode.exactAllowWhileIdle` for all scheduled notifications
- ALWAYS request `requestExactAlarmsPermission()` before scheduling
- Channel setup is in `main.dart:initNotifications()` using importance: `Importance.high`
- Notification scheduling MUST handle timezone offsets (`tz.TZDateTime`)
- **Daily Repeat**: Use `matchDateTimeComponents: DateTimeComponents.time` for repeating at same time daily
- **Wake from Sleep**: Include `enableLights: true, fullScreenIntent: true` in AndroidNotificationDetails

**Key Implementation Files**:
- `lib/main.dart`: Global notification init, scheduling functions (`scheduleMorning()`, `scheduleEvening()`)
- `lib/services/notification_helper.dart`: Prayer time notifications helper
- Settings screen (`lib/settings_screen.dart`): User-facing notification controls with error handling

**Permission Flow Pattern**:
```dart
// 1. Check permission with comprehensive error handling
final ok = await ensureNotificationPermissions();
if (!ok) {
  // Show user-friendly error with link to settings
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('يرجى السماح للإشعارات من إعدادات النظام'),
      action: SnackBarAction(
        label: 'فتح الإعدادات',
        onPressed: () => openAppSettings(),
      ),
    ),
  );
  return;
}

// 2. Schedule with exact alarm mode and daily repeat
await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  tzTime,
  NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      fullScreenIntent: true, // Wake device from sleep
    ),
  ),
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // REQUIRED
  matchDateTimeComponents: DateTimeComponents.time, // Daily repeat
);
```

**Timezone Setup**: The app tries multiple methods for robust timezone detection:
1. First attempts to match common Islamic region timezones (Morocco, Egypt, Saudi Arabia, etc.)
2. Falls back to UTC offset-based timezone (`Etc/GMT±X`)
3. Final fallback to UTC if all else fails

### 4. Favorites System Architecture
**Singleton Service Pattern** (`lib/services/favorites_service.dart`):
- Uses `FavoritesService.getInstance()` for app-wide access
- Storage key: `'favorites_dhikr'` in SharedPreferences
- ID generation: `'${category}_${text.hashCode}'` prevents duplicates
- JSON serialization via `DhikrItem` model (`lib/models/dhikr_item.dart`)

**Integration**: DhikrCard automatically handles favorites—just provide `category` parameter.

### 5. RTL & Localization
- **Global RTL enforced** in `MaterialApp.builder` with `Directionality(textDirection: TextDirection.rtl)`
- Locale: `const Locale('ar')` with `flutter_localizations` delegates
- **Always use `TextAlign.center` for Arabic content** (reads better than start/end)
- Font: Google Fonts Cairo (700-800 weight for titles, 400-600 for body)

## Development Workflows

### Building Release APK
```powershell
flutter clean
flutter pub get
flutter build apk --release
# Output: build\app\outputs\flutter-apk\app-release.apk
```

**Signing**: Configured via `android/key.properties` (referenced in `android/app/build.gradle` signingConfigs)

### Running on Device/Emulator
```powershell
flutter pub get
flutter run
# Hot reload: press 'r' in terminal
# Hot restart: press 'R'
```

### Testing Notifications Locally
Use Settings screen → "إرسال إشعار تجريبي" button (calls `sendTestNotification()` in main.dart)

### Updating Screens with Favorites
See `QUICK_GUIDE.md` and `FAVORITES_GUIDE.md` for the 3-step pattern to migrate legacy screens:
1. Import `DhikrCard`
2. Replace `_buildTextWidget` → `DhikrCard`
3. Add `category` parameter

**Status**: 3/32 adhkar screens migrated (sabah, after_pray, ahadit). 29 remaining in `lib/alyaoum/`, `lib/a3ibadat/`, `lib/divers_aldkar/`.

## Project-Specific Conventions

### Color Palette (Islamic Theme)
```dart
// Define once per screen, pass to DhikrCard
final List<Color> widgetColors = [Colors.black, ...]; // Text colors
final List<Color> containerColors = [Colors.white, ...]; // Card backgrounds

// App theme colors (don't change):
primary: Color(0xFF0B6623),     // Deep Islamic green
secondary: Color(0xFFF3D18A),   // Warm gold
background: Color(0xFFFBF8F0),  // Soft cream (light mode)
```

### File Organization (Strictly Enforced)
```
lib/
├── main.dart                    # App entry, navigation, global notification setup
├── [feature]_screen.dart        # Top-level screens (settings, favorites, prayer_times)
├── models/                      # Data classes (dhikr_item.dart)
├── services/                    # Business logic (favorites_service, notification_helper, daily_reminder_service)
├── widgets/                     # Reusable UI (app_scaffold, dhikr_card)
├── alyaoum/                     # Daily adhkar screens (sabah, massae, sleep, etc.)
├── a3ibadat/                    # Worship adhkar (after_pray, woudoue, etc.)
├── divers_aldkar/               # Miscellaneous adhkar (karab, safar, etc.)
└── tassbih/                     # Tasbih counter variants
```

### Ignore Rules
- `// ignore_for_file: use_super_parameters, prefer_const_constructors, deprecated_member_use` is common—inherited from template
- Avoid adding new ignores; fix lints instead when possible

### Naming Conventions
- **Arabic transliterations**: Use phonetic spelling (sabah, massae, woudoue, karab)
- **Screens**: PascalCase classes, lowercase filenames (e.g., `class Sabah` in `sabah.dart`)
- **Services**: Suffix with `Service` or `Helper`

## Integration Points & Dependencies

### Key Pub Packages
- **`flutter_local_notifications`**: Scheduled adhkar reminders (requires channel setup)
- **`timezone`**: TZ-aware scheduling (init in `main.dart:initNotifications()`)
- **`geolocator`**: GPS for prayer times (`prayer_times.dart`)
- **`adhan`**: Prayer time calculations with Madhab support
- **`flutter_qiblah`**: Compass heading for Qibla direction
- **`audioplayers`**: Quran radio streaming
- **`shared_preferences`**: All local storage (settings, favorites)
- **`google_fonts`**: Cairo font for Arabic text
- **`webview_flutter`**: Embedded web content (if needed)

### External Services
- **Quran Radio Stream**: Hardcoded URLs in `quran_radio.dart` (no API key needed)
- **No Analytics**: Privacy-first—no Firebase Analytics, no tracking
- **No Backend**: Fully offline except radio streaming

### Android-Specific
- **minSdk**: Defined by `flutter.minSdkVersion` (check `android/app/build.gradle`)
- **targetSdk**: Latest (defined by `flutter.targetSdkVersion`)
- **Permissions**: Location (for prayer times), notifications, exact alarms (in `AndroidManifest.xml`)
- **ProGuard**: Enabled for release builds (`minifyEnabled true`)

## Common Pitfalls & Solutions

### Issue: Notifications not appearing on Android 13+
**Solution**: The app now has comprehensive permission handling in `settings_screen.dart`:
- Checks both notification permission AND exact alarm permission
- Provides user-friendly error messages with "Open Settings" button
- Uses `AndroidIntent` to directly open app notification settings
- Validates permissions before attempting to schedule

### Issue: Notifications not waking device from sleep
**Solution**: Added `fullScreenIntent: true` and `enableLights: true` to AndroidNotificationDetails. This ensures notifications appear even when device is in deep sleep.

### Issue: Notifications not repeating daily
**Solution**: Fixed by ensuring `matchDateTimeComponents: DateTimeComponents.time` is used. This makes notifications repeat at the same time every day instead of being one-time only.

### Issue: Prayer times incorrect timezone
**Solution**: Enhanced `initNotifications()` with multi-level timezone detection:
1. Tries to match common Islamic region timezones first
2. Falls back to UTC offset-based timezone
3. Logs timezone selection in debug mode for troubleshooting

### Issue: Favorites not persisting
**Solution**: Ensure `FavoritesService.getInstance()` is awaited before operations. Check JSON serialization in `dhikr_item.dart`.

### Issue: RTL layout broken
**Solution**: Verify `Directionality(textDirection: TextDirection.rtl)` wraps the app in `MaterialApp.builder`. All screens should automatically inherit RTL.

### Issue: Font not loading
**Solution**: Google Fonts auto-downloads. Check internet connection on first run, or add `google_fonts` to assets for offline use.

## Testing Checklist (Before Committing)

- [ ] Run `flutter analyze` (should have zero errors)
- [ ] Test on Android 12+ device (exact alarm permissions)
- [ ] Verify notifications appear at scheduled time
- [ ] Check favorites persistence (add → close app → reopen)
- [ ] Test prayer times with real GPS location
- [ ] Verify RTL layout on all new/modified screens
- [ ] Build release APK and check size (<50MB ideal)

## CI/CD Notes
- **Codemagic**: Configured for iOS TestFlight releases (`codemagic.yaml`)
- **Android**: Manual builds via `flutter build apk --release`
- **Signing**: Uses `key.properties` for Android (NOT committed to git)

## Quick Reference: File Roles

| File | Purpose | Modify When... |
|------|---------|----------------|
| `lib/main.dart` | App entry, navigation, global notifications | Adding new main menu items, changing theme |
| `lib/widgets/app_scaffold.dart` | Layout template for all screens | Changing global UI structure, footer |
| `lib/widgets/dhikr_card.dart` | Reusable adhkar card with favorites | Changing card design/behavior |
| `lib/services/favorites_service.dart` | Favorites CRUD operations | Changing storage format, adding features |
| `lib/settings_screen.dart` | Notification settings, theme toggle | Adding new user preferences |
| `lib/prayer_times.dart` | GPS + Adhan calculation | Changing prayer time algorithm |
| `pubspec.yaml` | Dependencies, version | Adding packages, updating versions |

## Additional Documentation
- See `README.md` for user-facing features and installation
- See `QUICK_GUIDE.md` for visual guide on adding favorites to screens
- See `FAVORITES_GUIDE.md` for complete favorites implementation details
- See `FAVORITES_SUMMARY.md` for current implementation status

---

**When in doubt**: Follow existing patterns in `lib/alyaoum/sabah.dart` (fully updated with modern DhikrCard + favorites) or ask user for clarification.
