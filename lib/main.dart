import 'package:flutter/material.dart';
import 'package:modisch/constants/typography.dart';
import 'package:modisch/pages/home_page.dart';
import 'constants/colors.dart';

// Tambahkan RouteObserver global
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.background,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
        ),
        textTheme: AppTypography.getM3TextTheme(),
      ),
      navigatorObservers: [routeObserver], // Aktifkan RouteObserver di sini
      home: const HomePage(),
    );
  }
}
