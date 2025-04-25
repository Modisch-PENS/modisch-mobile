import 'package:flutter/material.dart';
import 'package:modisch/constants/typography.dart';
import 'package:modisch/pages/dashboard.dart';
import 'package:modisch/pages/onboard.dart';
import 'constants/colors.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background
      ),
      home: const OnboardPage(),
      routes: {
        '/dashboard' : (context) => const DashboardPage(),
      },
    );    
  }
}