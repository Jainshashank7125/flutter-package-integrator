# Flutter Package Integrator

A desktop application that simplifies the integration of Flutter packages, specifically designed for Google Maps integration. This tool automates the process of adding Google Maps to your Flutter project by handling all the necessary configurations for both Android and iOS platforms.

## Features

- 🚀 One-click Google Maps integration
- 📱 Automatic configuration for both Android and iOS
- 🔑 Secure API key management
- 📝 Automatic code generation
- 🎯 Proper widget structure
- 🔄 Handles all platform-specific configurations

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / Xcode (for platform-specific configurations)
- Google Maps API key

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/flutter-package-integrator.git
```

2. Navigate to the project directory:
```bash
cd flutter-package-integrator
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## Usage

1. Launch the application
2. Select your Flutter project directory
3. Click "Integrate Google Maps"
4. Enter your Google Maps API key when prompted
5. The tool will automatically:
   - Add the Google Maps dependency
   - Configure Android manifest
   - Configure iOS settings
   - Create a map widget
   - Update your main.dart file

## Project Structure

```
lib/
├── services/
│   ├── android_config_service.dart
│   ├── flutter_config_service.dart
│   ├── ios_config_service.dart
│   └── project_service.dart
├── ui/
│   └── home_screen.dart
└── widgets/
    └── project_picker.dart
```

## Configuration

### Android Configuration
The tool automatically:
- Adds the Google Maps API key to AndroidManifest.xml
- Adds location permissions
- Configures the necessary meta-data

### iOS Configuration
The tool automatically:
- Adds the Google Maps API key to AppDelegate.swift
- Configures Info.plist with required permissions
- Sets up the necessary frameworks

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT License

Copyright (c) 2024 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Support

If you encounter any issues or have questions, please:
1. Check the [existing issues](https://github.com/yourusername/flutter-package-integrator/issues)
2. Create a new issue if your problem isn't already documented

## Acknowledgments

- Flutter team for the amazing framework
- Google Maps team for the Flutter plugin
- All contributors who have helped improve this tool
