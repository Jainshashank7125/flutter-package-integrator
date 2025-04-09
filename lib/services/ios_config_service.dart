// lib/services/ios_config_service.dart
import 'dart:io';

class IOSConfigService {
  static Future<void> configureIOS(String path, String apiKey) async {
    // Update Info.plist
    final plistPath = '$path/ios/Runner/Info.plist';
    final plistFile = File(plistPath);
    String plistContent = await plistFile.readAsString();

    if (!plistContent.contains('NSLocationWhenInUseUsageDescription')) {
      plistContent = plistContent.replaceFirst(
        '</dict>',
        '''<key>NSLocationWhenInUseUsageDescription</key>
<string>App needs location permission</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
</dict>''',
      );
    }
    await plistFile.writeAsString(plistContent);

    // Update AppDelegate.swift
    final appDelegatePath = '$path/ios/Runner/AppDelegate.swift';
    final appDelegateFile = File(appDelegatePath);
    String appDelegateContent = await appDelegateFile.readAsString();

    // Check if GoogleMaps import exists
    if (!appDelegateContent.contains('import GoogleMaps')) {
      appDelegateContent = appDelegateContent.replaceFirst(
        'import Flutter',
        'import Flutter\nimport GoogleMaps',
      );
    }

    // Check if API key is already set
    if (!appDelegateContent.contains('GMSServices.provideAPIKey')) {
      // Find the right place to insert the API key
      final lines = appDelegateContent.split('\n');
      var insertIndex = -1;
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].contains('didFinishLaunchingWithOptions')) {
          // Find the opening brace of the method
          for (var j = i; j < lines.length; j++) {
            if (lines[j].contains('{')) {
              insertIndex = j + 1;
              break;
            }
          }
          break;
        }
      }

      if (insertIndex != -1) {
        lines.insert(insertIndex, '    GMSServices.provideAPIKey("$apiKey")');
        appDelegateContent = lines.join('\n');
      }
    } else {
      // Update existing API key
      appDelegateContent = appDelegateContent.replaceAll(
        RegExp(r'GMSServices\.provideAPIKey\("[^"]*"\)'),
        'GMSServices.provideAPIKey("$apiKey")',
      );
    }

    await appDelegateFile.writeAsString(appDelegateContent);
  }
}
