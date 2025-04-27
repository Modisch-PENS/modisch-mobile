import 'package:flutter/material.dart';
import '../../constants/typography.dart';
import '../../constants/colors.dart';
import 'package:modisch/presentation/pages/wardrobe_page.dart';
import 'package:modisch/presentation/pages/model_page.dart';
import 'package:modisch/presentation/widgets/wardrobe_card.dart';
import 'package:modisch/presentation/widgets/carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    "Hi, Guest!",
                    style: AppTypography.pageTitle(
                      context,
                    ).copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const CarouselContainer(),
            SafeArea(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: const TabBar(
                  tabs: [
                    Tab(text: 'Recent Wardrobe'),
                    Tab(text: 'Recent Model'),
                  ],
                  labelColor: AppColors.secondary,
                  unselectedLabelColor: AppColors.disabled,
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(children: [ModelPage(), ModelPage()]),
            ),
          ],
        ),
      ),
    );
  }
}
