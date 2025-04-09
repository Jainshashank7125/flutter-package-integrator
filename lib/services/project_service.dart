// lib/services/project_service.dart
import 'dart:io';

class ProjectService {
  static bool isValidFlutterProject(String path) {
    return File('$path/pubspec.yaml').existsSync();
  }
}
