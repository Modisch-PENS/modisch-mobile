import 'package:flutter/material.dart';
import 'package:modisch/core/constants/spacing.dart';
import 'package:modisch/features/home/widgets/carousel_slides.dart';
import 'package:modisch/features/home/widgets/homepage_header.dart';
import 'package:modisch/features/home/widgets/recent_info.dart';
import 'package:modisch/features/home/widgets/search_bar.dart';
import 'package:modisch/features/home/widgets/weather_location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

final List<String> shirtImages = [
  'assets/clothes/shirt/shirt_beige.webp',
  'assets/clothes/shirt/shirt_black.webp',
  'assets/clothes/shirt/shirt_blackplain.webp',
  'assets/clothes/shirt/shirt_jaslab.webp',
  'assets/clothes/shirt/shirt_lightblue.webp',
  'assets/clothes/shirt/shirt_plaid.webp',
  'assets/clothes/shirt/shirt_white.webp',
  'assets/clothes/shirt/shirt_whiteplain.webp',
];

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              HomepageHeader(),
              verticalSpace(16),
              // SearchBarComponent(),
              WeatherLocationHeader(),
              verticalSpace(24),
              CarouselContainer(),
              verticalSpace(24),
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
