import 'package:flutter/material.dart';
import 'constants/typography.dart';
import 'constants/colors.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/wardrobe_page.dart';
import 'presentation/pages/model_page.dart';
import 'presentation/pages/make_model_page.dart';
import 'presentation/pages/add_clothes_page.dart';
import 'presentation/widgets/expanding_fab.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const ModischApp());
}

class ModischApp extends StatelessWidget {
  const ModischApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modisch',
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
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/home': (context) => const HomePage(),
        '/wardrobe': (context) => const WardrobePage(),
        '/model': (context) => const ModelPage(),
        '/add_clothes': (context) => const AddClothesPage(),
        '/make_model': (context) => const MakeModelPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const WardrobePage(),
    ModelPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.tertiary,
        unselectedItemColor: AppColors.secondary,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.toiletPortable),
            label: 'Wardrobe',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.shirt),
            label: 'Model',
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const CustomExpandableFab(),
    );
  }
}
