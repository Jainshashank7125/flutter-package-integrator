import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../lib/services/project_service.dart';

void main() {
  // Ensure the Flutter test binding is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProjectService', () {
    late String tempDir;

    setUp(() async {
      final directory = await getTemporaryDirectory();
      tempDir = directory.path;
    });

    test('should return false for non-existent pubspec.yaml', () {
      expect(ProjectService.isValidFlutterProject(tempDir), false);
    });

    test('should return true for valid Flutter project', () async {
      // Create a temporary pubspec.yaml
      final pubspecFile = File(path.join(tempDir, 'pubspec.yaml'));
      await pubspecFile.writeAsString(
          '''\nname: test_project\ndescription: A test project\nversion: 1.0.0+1\n\nenvironment:\n  sdk: ">=3.1.0 <4.0.0"\n\ndependencies:\n  flutter:\n    sdk: flutter\n''');

      expect(ProjectService.isValidFlutterProject(tempDir), true);
    });
  });
}
