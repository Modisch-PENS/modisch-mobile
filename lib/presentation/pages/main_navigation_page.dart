import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/presentation/pages/home_page.dart';
import 'package:modisch/presentation/pages/model_page.dart';
import 'package:modisch/presentation/pages/wardrobe_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    WardrobePage(),
    ModelPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex:  _currentIndex,
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.tertiary,
        unselectedItemColor: AppColors.disabled,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: ''),
        ],
      ),
    );
  }
}