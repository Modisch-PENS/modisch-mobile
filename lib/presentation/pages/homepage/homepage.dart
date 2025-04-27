import 'package:flutter/material.dart';
import 'package:horizontal_scroll_view/horizontal_scroll_view.dart';
import 'package:modisch/constants/spacing.dart';
import 'package:modisch/constants/typography.dart';
import 'package:modisch/presentation/widgets/carousel_slides.dart';
import 'package:modisch/presentation/widgets/homepage_header.dart';
import 'package:modisch/presentation/widgets/recent_info.dart';
import 'package:modisch/presentation/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<String> shirtImages = [
  'assets/clothes/shirt/shirt_beige.webp',
  'assets/clothes/shirt/shirt_black.webp',
  'assets/clothes/shirt/shirt_blackplain.png',
  'assets/clothes/shirt/shirt_jaslab.png',
  'assets/clothes/shirt/shirt_lightblue.png',
  'assets/clothes/shirt/shirt_plaid.webp',
  'assets/clothes/shirt/shirt_white.png',
  'assets/clothes/shirt/shirt_whiteplain.png',
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              HomepageHeader(),
              verticalSpace(24),
              SearchBarComponent(),

              verticalSpace(24),
              CarouselContainer(),

              verticalSpace(24),

              // SizedBox(height: 30),
              RecentInfo(title: 'model', imageAssets: shirtImages),
              verticalSpace(24),
              RecentInfo(title: 'clothes', imageAssets: shirtImages),
            ],
          ),
        ),
      ),
    );
  }
}
