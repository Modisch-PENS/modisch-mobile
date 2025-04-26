import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';
import 'package:gap/gap.dart';

class DashboardFragment extends StatelessWidget {
  const DashboardFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hi, User!',
                style: AppTypography.pageTitle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: Icon(Icons.person, color: AppColors.background),
              ),
            ],
          ),
        ),
        //search bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.disabled.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.menu, color: AppColors.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Hinted search text',
                      hintStyle: AppTypography.inputTextPlaceholder,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const Icon(Icons.search, color: AppColors.secondary),
              ],
            ),
          ),
        ),
        //main content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DECIDE WHAT YOU WANNA WEAR TODAY!',
                      style: AppTypography.pageTitle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: () {
                        //nav
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tertiary,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'TRY NOW!',
                        style: AppTypography.buttonLabel.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //gambar cewe centil
              Expanded(
                child: Image.asset(
                  'assets/images/foto_centil.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.disabled,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.disabled,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        //recent model
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
          child: Text(
            'Recent Models',
            style: AppTypography.pageTitle.copyWith(fontSize: 18),
          ),
        ),
        // Add model card
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 24),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.add, size: 40, color: AppColors.secondary),
              ),
            ),
          ),
        ),

        // Recent Clothes section
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
          child: Text(
            'Recent Clothes',
            style: AppTypography.pageTitle.copyWith(fontSize: 18),
          ),
        ),
        //add cloth
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.add, size: 40, color: AppColors.secondary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
