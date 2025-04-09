// lib/services/flutter_config_service.dart
import 'dart:io';

class FlutterConfigService {
  static Future<void> addGoogleMapsDependency(String path) async {
    final pubspec = File('$path/pubspec.yaml');
    if (!pubspec.existsSync()) {
      throw Exception('pubspec.yaml not found at $path');
    }
    var content = await pubspec.readAsString();

    // Check if google_maps_flutter is already in dependencies
    if (!content.contains('google_maps_flutter:')) {
      // Find the dependencies section
      final lines = content.split('\n');
      var dependenciesIndex = -1;
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].trim() == 'dependencies:') {
          dependenciesIndex = i;
          break;
        }
      }

      if (dependenciesIndex == -1) {
        // If no dependencies section exists, add it
        content += '\ndependencies:\n  google_maps_flutter: ^2.5.0\n';
      } else {
        // Add the dependency under the existing dependencies section
        lines.insert(dependenciesIndex + 1, '  google_maps_flutter: ^2.5.0');
        content = lines.join('\n');
      }

      await pubspec.writeAsString(content);
    }
    // print('Running flutter pub get in: $path');
    // try {
    //   final result = await Process.run(
    //     'flutter',
    //     ['pub', 'get'],
    //     workingDirectory: path,
    //   );
    //   if (result.exitCode != 0) {
    //     print('Error running flutter pub get:');
    //     print(result.stderr); // Print any error messages
    //     throw Exception('flutter pub get failed: ${result.stderr}');
    //   } else {
    //     print('flutter pub get finished successfully');
    //   }
    // } on ProcessException catch (e) {
    //   print(e.message);
    //   throw e;
    // }
  }

  static Future<void> injectMapExample(String path) async {
    // Create widgets directory if it doesn't exist
    final widgetsDir = Directory('$path/lib/widgets');
    if (!widgetsDir.existsSync()) {
      await widgetsDir.create(recursive: true);
    }

    // Create the map widget file
    final mapWidgetFile = File('$path/lib/widgets/map_widget.dart');
    await mapWidgetFile.writeAsString('''
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});
  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  bool _isMapCreated = false;

  final LatLng _center = const LatLng(37.42796133580664, -122.085749655962);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _isMapCreated = true;
    });
  }

  @override
  void dispose() {
    if (_isMapCreated) {
      mapController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Map')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.4746,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
''');

    // Update main.dart to use the new MapWidget
    final mainDart = File('$path/lib/main.dart');
    if (mainDart.existsSync()) {
      var content = await mainDart.readAsString();
      if (!content.contains(
          'import \'package:google_maps_flutter/google_maps_flutter.dart\';')) {
        content = content.replaceFirst(
          'import \'package:flutter/material.dart\';',
          'import \'package:flutter/material.dart\';\nimport \'package:google_maps_flutter/google_maps_flutter.dart\';\nimport \'widgets/map_widget.dart\';',
        );
      }

      // Replace the home widget with MapWidget if it's a simple MaterialApp
      if (content.contains('home:') && content.contains('MaterialApp')) {
        content = content.replaceAll(
          RegExp(r'home:\s*[^,}]+'),
          'home: const MapWidget()',
        );
      }

      await mainDart.writeAsString(content);
    }
  }
}
