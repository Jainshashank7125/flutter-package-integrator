import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import '../../lib/services/android_config_service.dart';

void main() {
  group('AndroidConfigService', () {
    late Directory tempDir;
    late String projectPath;
    const testApiKey = 'test_api_key_123';

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('flutter_test_');
      projectPath = tempDir.path;

      // Create Android project structure
      final androidDir =
          Directory(path.join(projectPath, 'android/app/src/main'));
      await androidDir.create(recursive: true);

      // Create initial AndroidManifest.xml
      final manifestFile =
          File(path.join(androidDir.path, 'AndroidManifest.xml'));
      await manifestFile.writeAsString('''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application>
    </application>
</manifest>
''');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('should add API key and permissions to AndroidManifest.xml', () async {
      await AndroidConfigService.configureAndroid(projectPath, testApiKey);

      final manifestContent = await File(path.join(
              projectPath, 'android/app/src/main/AndroidManifest.xml'))
          .readAsString();

      expect(manifestContent.contains(testApiKey), true);
      expect(manifestContent.contains('ACCESS_FINE_LOCATION'), true);
      expect(manifestContent.contains('com.google.android.geo.API_KEY'), true);
    });

    test('should update existing API key if present', () async {
      // First configuration
      await AndroidConfigService.configureAndroid(projectPath, 'old_api_key');

      // Second configuration with new key
      await AndroidConfigService.configureAndroid(projectPath, testApiKey);

      final manifestContent = await File(path.join(
              projectPath, 'android/app/src/main/AndroidManifest.xml'))
          .readAsString();

      expect(manifestContent.contains(testApiKey), true);
      expect(manifestContent.contains('old_api_key'), false);
    });
  });
}
