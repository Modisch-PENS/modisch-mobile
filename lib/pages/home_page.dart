import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/pages/home_content_page.dart';
import 'package:modisch/pages/make_model_page.dart';
import 'package:modisch/pages/wardrobe_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      HomeContentPage(),
      WardrobePage(),
      MakeModelPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.disabled,
        unselectedItemColor: AppColors.secondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (idx) {
          setState(() => _currentIndex = idx);
        },
        items: [
          _buildAnimatedBarItem(FontAwesomeIcons.home, 0, 'Home'),
          _buildAnimatedBarItem(FontAwesomeIcons.toiletPortable, 1, 'Wardrobe'),
          _buildAnimatedBarItem(FontAwesomeIcons.tshirt, 2, 'Model'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildAnimatedBarItem(IconData icon, int index, String label) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: SizedBox(
        width: 48, // Kasih lebar tetap supaya semua item align center
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Icon(
                icon,
                size: 24, // Fix size semua icon biar konsisten
                color: isSelected ? AppColors.secondary : AppColors.disabled,
              ),
            ),
            const SizedBox(height: 6), // Jarak icon ke garis bawah
          
          ],
        ),
      ),
      label: label,
    );
  }
}
