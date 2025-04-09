// lib/ui/home_screen.dart
import 'package:flutter/material.dart';

import '../../services/android_config_service.dart';
import '../../services/flutter_config_service.dart';
import '../../services/ios_config_service.dart';
import '../../services/project_service.dart';
import '../../widgets/project_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? projectPath;
  String status = 'No project selected.';
  final _apiKeyController = TextEditingController();
  bool _isValidProject = false;

  Future<void> _showApiKeyDialog() async {
    if (!_isValidProject) {
      _showErrorDialog('Invalid Flutter Project',
          'Please select a valid Flutter project with pubspec.yaml');
      return;
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Google Maps API Key'),
        content: TextField(
          controller: _apiKeyController,
          decoration: const InputDecoration(
            hintText: 'Enter your Google Maps API key',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_apiKeyController.text.isNotEmpty) {
                Navigator.pop(context);
                integrateGoogleMaps(_apiKeyController.text);
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> integrateGoogleMaps(String apiKey) async {
    if (projectPath == null || !_isValidProject) return;
    setState(() => status = 'Integrating google_maps_flutter...');

    try {
      await FlutterConfigService.addGoogleMapsDependency(projectPath!);
      await AndroidConfigService.configureAndroid(projectPath!, apiKey);
      await IOSConfigService.configureIOS(projectPath!, apiKey);
      await FlutterConfigService.injectMapExample(projectPath!);

      setState(() => status = 'Google Maps integrated successfully!');
    } catch (e) {
      setState(() => status = 'Error: ${e.toString()}');
      _showErrorDialog('Integration Error', e.toString());
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin Integrator')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProjectPicker(
                  onPathSelected: (path) {
                    setState(() {
                      projectPath = path;
                      _isValidProject =
                          ProjectService.isValidFlutterProject(path);
                      status = _isValidProject
                          ? 'Selected: $path'
                          : 'Error: Invalid Flutter project. Please select a project with pubspec.yaml';
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isValidProject ? _showApiKeyDialog : null,
                  child: const Text('Integrate Google Maps'),
                ),
                const SizedBox(height: 16),
                Text(
                  status,
                  style: TextStyle(
                    color: _isValidProject ? Colors.black : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
