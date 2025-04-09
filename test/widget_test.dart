import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_package_integrator/main.dart';
import 'package:flutter_package_integrator/ui/home_screen.dart';
import 'package:flutter_package_integrator/widgets/project_picker.dart';

// Import all service tests
import 'services/project_service_test.dart' as project_service_test;
import 'services/flutter_config_service_test.dart'
    as flutter_config_service_test;
import 'services/android_config_service_test.dart'
    as android_config_service_test;
import 'services/ios_config_service_test.dart' as ios_config_service_test;

void main() {
  // Ensure the Flutter test binding is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  // Run all service tests
  project_service_test.main();
  flutter_config_service_test.main();
  android_config_service_test.main();
  ios_config_service_test.main();

  // Widget tests
  testWidgets('HomeScreen Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: HomeScreen(),
    ));

    // Verify that the app title is displayed
    expect(find.text('Plugin Integrator'), findsOneWidget);

    // Verify initial state
    expect(find.text('No project selected.'), findsOneWidget);
    expect(find.text('Integrate Google Maps'), findsOneWidget);

    // Verify that the project picker is present
    expect(find.byType(ProjectPicker), findsOneWidget);
  });

  testWidgets('API Key Dialog Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: HomeScreen(),
    ));

    // Tap the integrate button
    await tester.tap(find.text('Integrate Google Maps'));
    await tester.pumpAndSettle();

    // Verify dialog is shown
    expect(find.text('Enter Google Maps API Key'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
