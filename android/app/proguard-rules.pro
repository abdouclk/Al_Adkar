# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Fonts
-keep class com.google.android.gms.fonts.** { *; }

# Prevent obfuscation of notification classes
-keep class com.dexterous.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }

# Gson rules for flutter_local_notifications
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
-keep class com.google.gson.** { *; }
# Keep generic type information for Gson
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type { *; }

# audio_service, just_audio, audio_session
-keep class com.ryanheise.audioservice.** { *; }
-keep class com.ryanheise.audioservice.AudioService { *; }
-keep class com.ryanheise.audioservice.AudioServiceActivity { *; }
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audio_session.** { *; }
-dontwarn com.ryanheise.**

# Flutter deferred components / Play Core references (present even if not used)
-dontwarn com.google.android.play.**
-keep class com.google.android.play.** { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }
