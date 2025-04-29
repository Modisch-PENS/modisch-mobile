import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/presentation/pages/home/home_page.dart';
import 'package:modisch/presentation/pages/model/model_page.dart';
import 'package:modisch/presentation/pages/wardrobe/wardrobe_page.dart';
import 'package:modisch/presentation/widgets/expanding_fab.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged:
                (value) => setState(() {
                  selectedPage = value;
                }),
            children: const [
              Center(child: HomePage(title: 'HomePage')),
              Center(child: WardrobePage()),
              Center(child: ModelPage()),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation:
          selectedPage != 0 ? ExpandableFab.location : null,
      floatingActionButton:
          selectedPage != 0 ? const CustomExpandableFab() : null,
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          // Set to simple icon style
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.simple,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            title: const Text('Home'),
            backgroundColor: AppColors.secondary,
          ),
          BottomBarItem(
            icon: const Icon(Icons.checkroom_outlined),
            selectedIcon: const Icon(Icons.auto_awesome_mosaic),
            title: const Text('Wardrobe'),
            backgroundColor: AppColors.secondary,
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            title: const Text('Model'),
            backgroundColor: AppColors.secondary,
          ),
        ],
        currentIndex: selectedPage,
        onTap: (index) {
          pageController.jumpToPage(index);
          setState(() {
            selectedPage = index;
          });

          // pageController.animateToPage(
          //   index,
          //   duration: const Duration(milliseconds: 200),
          //   curve: Curves.easeInOut,
          // );
        },
      ),
    );
  }
}
