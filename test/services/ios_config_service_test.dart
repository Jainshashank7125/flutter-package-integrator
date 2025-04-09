import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import '../../lib/services/ios_config_service.dart';

void main() {
  group('IOSConfigService', () {
    late Directory tempDir;
    late String projectPath;
    const testApiKey = 'test_api_key_123';

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('flutter_test_');
      projectPath = tempDir.path;

      // Create iOS project structure
      final iosDir = Directory(path.join(projectPath, 'ios/Runner'));
      await iosDir.create(recursive: true);

      // Create initial Info.plist
      final plistFile = File(path.join(iosDir.path, 'Info.plist'));
      await plistFile.writeAsString('''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
</dict>
</plist>
''');

      // Create initial AppDelegate.swift
      final appDelegateFile = File(path.join(iosDir.path, 'AppDelegate.swift'));
      await appDelegateFile.writeAsString('''
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
''');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('should add location permission to Info.plist', () async {
      await IOSConfigService.configureIOS(projectPath, testApiKey);

      final plistContent =
          await File(path.join(projectPath, 'ios/Runner/Info.plist'))
              .readAsString();
      expect(
          plistContent.contains('NSLocationWhenInUseUsageDescription'), true);
      expect(plistContent.contains('io.flutter.embedded_views_preview'), true);
    });

    test('should add Google Maps configuration to AppDelegate.swift', () async {
      await IOSConfigService.configureIOS(projectPath, testApiKey);

      final appDelegateContent =
          await File(path.join(projectPath, 'ios/Runner/AppDelegate.swift'))
              .readAsString();
      expect(appDelegateContent.contains('import GoogleMaps'), true);
      expect(
          appDelegateContent
              .contains('GMSServices.provideAPIKey("$testApiKey")'),
          true);
    });

    test('should update existing API key if present', () async {
      // First configuration
      await IOSConfigService.configureIOS(projectPath, 'old_api_key');

      // Second configuration with new key
      await IOSConfigService.configureIOS(projectPath, testApiKey);

      final appDelegateContent =
          await File(path.join(projectPath, 'ios/Runner/AppDelegate.swift'))
              .readAsString();
      expect(
          appDelegateContent
              .contains('GMSServices.provideAPIKey("$testApiKey")'),
          true);
      expect(
          appDelegateContent
              .contains('GMSServices.provideAPIKey("old_api_key")'),
          false);
    });
  });
}
