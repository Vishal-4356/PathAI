import 'package:flutter/material.dart';
import '../services/upload_service.dart';
import 'result_screen.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  bool loading = false;

  Future<void> analyze() async {
    setState(() => loading = true);

    // Simulate different stages of AI processing for better UX
    final result = await UploadService.captureAndAnalyze();

    if (!mounted) return;
    setState(() => loading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme for camera-centric feel
      appBar: AppBar(
        title: const Text("Barrier Scanner"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // 1. Viewfinder UI
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.camera_alt_outlined, 
                            color: Colors.white10, size: 100),
                        _buildScannerOverlay(),
                      ],
                    ),
                  ),
                ),
              ),
              
              // 2. Instructions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  children: [
                    const Text(
                      "Scan Environment",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Point your camera at ramps, stairs, or sidewalks for AI barrier analysis.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // 3. Action Button
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: _buildCaptureButton(),
              ),
            ],
          ),

          // 4. Loading Overlay
          if (loading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(30),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Corner(angle: 0),
              _Corner(angle: 90),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Corner(angle: 270),
              _Corner(angle: 180),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: loading ? null : analyze,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.psychology, color: Colors.black, size: 30),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black87,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blueAccent),
          const SizedBox(height: 24),
          const Text(
            "AI Analyzing Barriers...",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            "Identifying incline levels and obstacles",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final double angle;
  const _Corner({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * 3.14159 / 180,
      child: Container(
        height: 30,
        width: 30,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.blueAccent, width: 4),
            left: BorderSide(color: Colors.blueAccent, width: 4),
          ),
        ),
      ),
    );
  }
}