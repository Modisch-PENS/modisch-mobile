import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/features/home/pages/homepage.dart';
import 'package:modisch/features/main/widgets/expanding_fab.dart';
import 'package:modisch/features/model/pages/model_page.dart';
import 'package:modisch/features/wardrobe/pages/wardrobe_page.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;
  final PageController pageController = PageController();

  // @override
  // void dispose() {
  //   pageController.dispose();
  //   super.dispose();
  // }

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
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const CustomExpandableFab(),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          // Set to simple icon style
          barAnimation: BarAnimation.blink,
          iconStyle: IconStyle.animated,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined, color: AppColors.disabled),
            selectedIcon: const Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(
                color:
                    selectedPage == 0
                        ? AppColors.secondary
                        : AppColors.disabled,

                fontSize: 12,
              ),
            ),
            backgroundColor: AppColors.secondary,
          ),
          BottomBarItem(
            icon: const Icon(
              Icons.door_sliding_outlined,
              color: AppColors.disabled,
            ),
            selectedIcon: const Icon(Icons.door_sliding),
            title: Text(
              'Wardrobe',
              style: TextStyle(
                color:
                    selectedPage == 1
                        ? AppColors.secondary
                        : AppColors.disabled,
                fontSize: 12,
              ),
            ),
            backgroundColor: AppColors.secondary,
          ),
          BottomBarItem(
            icon: const Icon(
              Icons.dashboard_customize_outlined,
              color: AppColors.disabled,
            ),
            selectedIcon: const Icon(
              Icons.dashboard_customize,
              color: AppColors.secondary,
            ),
            title: Text(
              'Model',
              style: TextStyle(
                color:
                    selectedPage == 2
                        ? AppColors.secondary
                        : AppColors.disabled,
                fontSize: 12,
              ),
            ),
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
