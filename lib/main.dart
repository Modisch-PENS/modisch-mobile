import 'package:flutter/material.dart';
import 'package:modisch/pages/dashboard.dart';
import 'package:modisch/pages/onboard.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modisch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: const OnboardPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardPage(),
        '/dashboard' : (context) => const DashboardPage(),
      },
    );    
  }
}