import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';
import 'package:modisch/presentation/widgets/carousel_slides.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hello User', style: AppTypography.pageTitle(context)),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: SearchBar(
                leading: Icon(
                  Icons.menu,
                  // color: AppColors.secondary.withOpacity(0.4),
                  color: AppColors.searchBarComponents,
                ),
                hintText: 'Himit Outfit',
                hintStyle: WidgetStatePropertyAll(
                  TextStyle(color: AppColors.searchBarComponents),
                ),
                trailing: [
                  Icon(Icons.search, color: AppColors.searchBarComponents),
                ],
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  AppColors.disabled.withValues(alpha: 0.4),
                ),
                elevation: const WidgetStatePropertyAll(0),
                onTap: () {},
              ),
            ),

            CarouselContainer(),
          ],
        ),
      ),
    );
  }
}
