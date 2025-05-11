import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/spacing.dart';
import 'package:Modisch/core/constants/typography.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';
import 'package:Modisch/features/wardrobe/riverpod/wardrobe_provider.dart';

/// Widget displaying recent wardrobe/clothing items
class RecentWardrobeWidget extends ConsumerWidget {
  final int itemCount;

  const RecentWardrobeWidget({
    super.key,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get recent clothing items from the wardrobe provider
    final recentItems = ref.watch(recentClothingProvider(limit: itemCount));

    return Column(
      children: [
        _buildHeader(context),
        verticalSpace(16),
        recentItems.isEmpty
            ? _buildEmptyState(context)
            : _buildClothingList(context, recentItems),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return RecentHeader(title: 'Recent Clothes');
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      itemType: 'clothes',
      onAddPressed: () => context.goNamed('camera_picker'),
    );
  }

  Widget _buildClothingList(BuildContext context, List<ClothingModel> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          horizontalSpace(24),
          ...items.asMap().entries.map((entry) {
            final item = entry.value;
            final isLast = entry.key == items.length - 1;

            return Padding(
              padding: EdgeInsets.only(right: isLast ? 24 : 16),
              child: ClothingItemCard(clothing: item),
            );
          }),
        ],
      ),
    );
  }
}

/// Widget for displaying a single clothing item
class ClothingItemCard extends StatelessWidget {
  final ClothingModel clothing;

  const ClothingItemCard({
    super.key,
    required this.clothing,
  });

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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SizedBox(
            height: 125,
            width: 125,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19), // Slightly smaller to account for border
              child: Image.file(
                File(clothing.imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: AppColors.disabled,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 125,
          child: Text(
            clothing.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTypography.cardLabel(context).copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 125,
          child: Text(
            clothing.category,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.cardLabel(context).copyWith(
              fontSize: 11,
              color: AppColors.searchBarComponents,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Common header widget for recent sections
class RecentHeader extends StatelessWidget {
  final String title;

  const RecentHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.recentInfoLabel(context),
          ),
          // See All button can be re-enabled here if needed
          // TextButton(
          //   onPressed: () {
          //     final String tabPath = title.toLowerCase().contains('outfit') ? '/model' : '/wardrobe';
          //     context.go(tabPath);
          //   },
          //   style: TextButton.styleFrom(
          //     foregroundColor: AppColors.tertiary,
          //     padding: const EdgeInsets.symmetric(horizontal: 8),
          //     minimumSize: Size.zero,
          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //   ),
          //   child: const Text('See All'),
          // ),
        ],
      ),
    );
  }
}

/// Widget displayed when no items are available
class EmptyStateWidget extends StatelessWidget {
  final String itemType;
  final VoidCallback onAddPressed;

  const EmptyStateWidget({
    super.key,
    required this.itemType,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final String displayText = 'No $itemType added yet';
    final String buttonText = 'Add ${itemType == 'outfits' ? 'Outfit' : 'Clothes'}';
    final IconData icon =
    itemType == 'outfits' ? Icons.checkroom_outlined : Icons.category_outlined;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.disabled,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                displayText,
                style: TextStyle(color: AppColors.disabled),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: onAddPressed,
                icon: const Icon(Icons.add, size: 16),
                label: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}