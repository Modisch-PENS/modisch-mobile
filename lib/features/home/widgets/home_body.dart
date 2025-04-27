import 'package:flutter/material.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';
import 'section_title.dart';
import 'recent_tile.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const SearchField(),
          const SizedBox(height: 24),
          const HeroSection(),
          const SizedBox(height: 16),
          const PageIndicator(),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Recent Models'),
          const SizedBox(height: 8),
          const RecentTile(),
          const SizedBox(height: 16),
          const SectionTitle(title: 'Recent Clothes'),
          const SizedBox(height: 8),
          const RecentTile(),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Find what you want to wear',
        hintStyle: AppTypography.searchBarHintText(context), // << updated
        prefixIcon: const Icon(Icons.menu),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DECIDE WHAT\nYOU WANNA\nWEAR TODAY!',
                style: AppTypography.pageTitle(context), // << updated
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'TRY NOW!',
                  style: AppTypography.buttonLabel(context), // << updated
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/foto_orang.png',
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
        ),
      ],
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle, size: 8, color: Colors.grey),
        SizedBox(width: 4),
        Icon(Icons.circle_outlined, size: 8, color: Colors.grey),
        SizedBox(width: 4),
        Icon(Icons.circle_outlined, size: 8, color: Colors.grey),
      ],
    );
  }
}
