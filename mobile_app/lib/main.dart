import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AccessibilityApp());
}

class AccessibilityApp extends StatelessWidget {
  const AccessibilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
