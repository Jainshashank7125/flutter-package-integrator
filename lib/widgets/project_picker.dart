// lib/widgets/project_picker.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProjectPicker extends StatelessWidget {
  final Function(String) onPathSelected;
  const ProjectPicker({super.key, required this.onPathSelected});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String? selectedDir = await FilePicker.platform.getDirectoryPath();
        if (selectedDir != null) {
          onPathSelected(selectedDir);
        }
      },
      child: const Text('Select Flutter Project'),
    );
  }
}
