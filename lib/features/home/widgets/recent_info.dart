import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/spacing.dart';
import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/core/database/models/wardrobe_database.dart';
import 'package:modisch/features/wardrobe/riverpod/wardrobe_provider.dart';

class RecentInfo extends ConsumerWidget {
  final String title;

  const RecentInfo({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get recent items from the wardrobe provider
    final recentItems = ref.watch(recentClothingProvider(limit: 10));

    // If there are no items, show empty state
    if (recentItems.isEmpty) {
      return Column(
        children: [
          _buildHeader(context),
          verticalSpace(16),
          _buildEmptyState(context),
        ],
      );
    }

    return Column(
      children: [
        _buildHeader(context),
        verticalSpace(16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              horizontalSpace(24),
              ...recentItems.asMap().entries.map((entry) {
                final isLast = entry.key == recentItems.length - 1;
                return Padding(
                  padding: EdgeInsets.only(right: isLast ? 24 : 16),
                  child: _ClothingListItem(clothing: recentItems[entry.key]),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Recent $title',
          style: AppTypography.recentInfoLabel(context),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.disabled, width: 1),
        ),
        child: SizedBox(
          height: 125,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'No $title added yet',
                style: TextStyle(color: AppColors.disabled),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClothingListItem extends StatelessWidget {
  final ClothingModel clothing;

  const _ClothingListItem({required this.clothing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.disabled, width: 1),
          ),
          child: SizedBox(
            height: 125,
            width: 125,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(clothing.imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, color: AppColors.disabled),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 125,
          child: Text(
            clothing.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: AppTypography.cardLabel(context),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}