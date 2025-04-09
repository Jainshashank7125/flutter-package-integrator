import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import '../../lib/services/flutter_config_service.dart';

void main() {
  group('FlutterConfigService', () {
    late Directory tempDir;
    late String projectPath;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('flutter_test_');
      projectPath = tempDir.path;

      // Create basic Flutter project structure
      await Directory(path.join(projectPath, 'lib')).create(recursive: true);
      await Directory(path.join(projectPath, 'android'))
          .create(recursive: true);
      await Directory(path.join(projectPath, 'ios')).create(recursive: true);

      // Create pubspec.yaml
      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      await pubspecFile.writeAsString('''
name: test_project
description: A test project
version: 1.0.0+1

environment:
  sdk: ">=3.1.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
''');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('should add Google Maps dependency to pubspec.yaml', () async {
      await FlutterConfigService.addGoogleMapsDependency(projectPath);

      final pubspecContent =
          await File(path.join(projectPath, 'pubspec.yaml')).readAsString();
      expect(pubspecContent.contains('google_maps_flutter:'), true);
    });

    test('should create map widget file', () async {
      await FlutterConfigService.injectMapExample(projectPath);

      final mapWidgetFile =
          File(path.join(projectPath, 'lib/widgets/map_widget.dart'));
      expect(await mapWidgetFile.exists(), true);

      final content = await mapWidgetFile.readAsString();
      expect(content.contains('GoogleMap'), true);
      expect(content.contains('MapWidget'), true);
    });

    test('should update main.dart with map widget', () async {
      // Create initial main.dart
      final mainFile = File(path.join(projectPath, 'lib/main.dart'));
      await mainFile.writeAsString('''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Hello World')),
      ),
    );
  }
}
''');

      await FlutterConfigService.injectMapExample(projectPath);

      final content = await mainFile.readAsString();
      expect(content.contains('import \'widgets/map_widget.dart\''), true);
      expect(content.contains('MapWidget'), true);
    });
  });
}
