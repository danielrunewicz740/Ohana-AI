import 'package:flutter/material.dart';
import 'screens/kiosk_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const OhanaKioskApp());
}

class OhanaKioskApp extends StatelessWidget {
  const OhanaKioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ohana Dog Training — Check-In Kiosk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const KioskScreen(),
    );
  }
}
