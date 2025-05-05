import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/features/home/pages/homepage.dart';
import 'package:modisch/features/main/riverpod/main_page_provider.dart';
import 'package:modisch/features/home/widgets/home_expandable_fab.dart';
import 'package:modisch/features/model/pages/model_page.dart';
import 'package:modisch/features/model/widgets/model_expandable_fab.dart'; 
import 'package:modisch/features/wardrobe/pages/wardrobe_page.dart';
import 'package:modisch/features/wardrobe/widgets/wardrobe_expandable_fab.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainPage extends ConsumerStatefulWidget {
  final int initialTab;
  const MainPage({super.key, this.initialTab = 0}); // default to Home

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}


class _MainPageState extends ConsumerState<MainPage> {
  late final PageController pageController = PageController(initialPage: widget.initialTab);


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainPageNotifierProvider.notifier)
          .changePageToIndex(widget.initialTab);
    });
  }



  final Map<MainPageTab, Widget> _fabMap = {
    MainPageTab.home: const CustomExpandableFab(),
    MainPageTab.wardrobe: const WardrobeExpandableFab(),
    MainPageTab.model: const ModelExpandableFab(),
  };

  @override
  Widget build(BuildContext context) {
    final mainPageState = ref.watch(mainPageNotifierProvider);
    final selectedPage = mainPageState.index;

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          ref.read(mainPageNotifierProvider.notifier).changePageToIndex(index);
        },
        children: const [
          Center(child: HomePage()),
          Center(child: WardrobePage()),
          Center(child: ModelPage()),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: _fabMap.entries.map((entry) {
          return Visibility(
            visible: mainPageState == entry.key,
            maintainState: true, 
            maintainAnimation: true,
            maintainSize: true,
            child: entry.value,
          );
        }).toList(),
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
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
                color: selectedPage == 0
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
                color: selectedPage == 1
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
                color: selectedPage == 2
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
          ref.read(mainPageNotifierProvider.notifier).changePageToIndex(index);
        },
      ),
    );
  }
}