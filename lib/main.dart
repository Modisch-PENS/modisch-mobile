import 'package:flutter/material.dart';
import 'package:modisch/constants/typography.dart';
import 'package:modisch/presentation/pages/main_navigation_page.dart';
import 'package:modisch/presentation/pages/model_page.dart';
import 'package:modisch/presentation/pages/wardrobe_page.dart';
import 'constants/colors.dart';
import 'package:modisch/presentation/pages/home_page.dart';
import 'package:modisch/services/hive_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveServices.init();
  await HiveServices.addDummyData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.background,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
        ),
        textTheme: AppTypography.getM3TextTheme(),
        scaffoldBackgroundColor: AppColors.background
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => const MainNavigationPage(),
        '/home': (context) => const HomePage(),
        '/wardrobe': (context) => const WardrobePage(),
        '/model': (context) => const ModelPage()
      },
    );
  }
}

