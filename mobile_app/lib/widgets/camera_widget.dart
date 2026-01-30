import 'package:flutter/material.dart';
import '../services/upload_service.dart';
import '../screens/result_screen.dart';

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key});

  Future<void> _handleCapture(BuildContext context) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Capture & analyze
    String result = await UploadService.captureAndAnalyze();

    // Close loading
    Navigator.pop(context);

    // Navigate to result screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.camera_alt),
      label: const Text("Capture & Analyze"),
      onPressed: () => _handleCapture(context),
    );
  }
}
