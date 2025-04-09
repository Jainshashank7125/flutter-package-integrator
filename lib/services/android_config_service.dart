// lib/services/android_config_service.dart
import 'dart:io';

class AndroidConfigService {
  static Future<void> configureAndroid(String path, String apiKey) async {
    final manifestPath = '$path/android/app/src/main/AndroidManifest.xml';
    final manifest = File(manifestPath);
    String content = await manifest.readAsString();

    if (!content.contains('com.google.android.geo.API_KEY')) {
      content = content.replaceFirst('</application>', '''<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="$apiKey"/>
</application>''');
    } else {
      // Update existing API key
      content = content.replaceAll(
        RegExp(r'android:value="[^"]*"'),
        'android:value="$apiKey"',
      );
    }

    if (!content.contains('ACCESS_FINE_LOCATION')) {
      content = content.replaceFirst(
        '<manifest',
        '<manifest\n    xmlns:android="http://schemas.android.com/apk/res/android">\n<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>',
      );
    }

    await manifest.writeAsString(content);
  }
}
