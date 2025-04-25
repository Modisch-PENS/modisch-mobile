// lib/main.dart
import 'package:flutter/material.dart';
import 'package:modisch/features/home/presentation/pages/homepage.dart';
import 'package:modisch/config/theme/app_theme.dart';

void main() {
  runApp(const ModischApp());
}

class ModischApp extends StatelessWidget {
  const ModischApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modisch',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}


