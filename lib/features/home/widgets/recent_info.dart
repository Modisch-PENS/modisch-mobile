import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/spacing.dart';
import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/core/database/models/wardrobe_database.dart';
import 'package:modisch/core/database/models/outfit_model_database.dart';
import 'package:modisch/features/main/riverpod/main_page_provider.dart';
import 'package:modisch/features/wardrobe/riverpod/wardrobe_provider.dart';
import 'package:modisch/features/model/providers/outfit_provider.dart';

class RecentInfo extends ConsumerWidget {
  final String type; // 'clothes' or 'model'
  final int itemCount; // Number of items to display

  const RecentInfo({
    super.key,
    required this.type,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Based on type, we'll either get recent clothing or outfit items
    if (type.toLowerCase() == 'clothes') {
      return _buildRecentClothes(context, ref);
    } else if (type.toLowerCase() == 'model' || type.toLowerCase() == 'outfit') {
      return _buildRecentOutfits(context, ref);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildRecentClothes(BuildContext context, WidgetRef ref) {
    // Get recent clothing items from the wardrobe provider
    final recentItems = ref.watch(recentClothingProvider(limit: itemCount));

    return Column(
      children: [
        _buildHeader(context, ref, 'Recent Clothes'),
        verticalSpace(16),
        recentItems.isEmpty
            ? _buildEmptyState(context, 'clothes')
            : _buildClothingList(context, recentItems),
      ],
    );
  }

  Widget _buildRecentOutfits(BuildContext context, WidgetRef ref) {
    // Get recent outfits from the outfit provider
    final outfitsState = ref.watch(outfitNotifierProvider);

    return outfitsState.when(
      loading: () => Column(
        children: [
          _buildHeader(context, ref, 'Recent Outfits'),
          verticalSpace(16),
          const Center(
            child: CircularProgressIndicator(color: AppColors.tertiary),
          ),
        ],
      ),
      error: (error, _) => Column(
        children: [
          _buildHeader(context, ref, 'Recent Outfits'),
          verticalSpace(16),
          _buildEmptyState(context, 'outfits'),
        ],
      ),
      data: (outfits) {
        // Sort outfits by creation date, most recent first
        final sortedOutfits = [...outfits];
        sortedOutfits.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // Take only the requested number of items
        final recentOutfits = sortedOutfits.take(itemCount).toList();

        return Column(
          children: [
            _buildHeader(context, ref, 'Recent Outfits'),
            verticalSpace(16),
            recentOutfits.isEmpty
                ? _buildEmptyState(context, 'outfits')
                : _buildOutfitList(context, recentOutfits),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.recentInfoLabel(context),
          ),
          // TextButton(
          //   onPressed: () {
          //     // Navigate directly to the appropriate tab path
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

  Widget _buildEmptyState(BuildContext context, String itemType) {
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
                itemType == 'outfits'
                    ? Icons.checkroom_outlined
                    : Icons.category_outlined,
                color: AppColors.disabled,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'No $itemType added yet',
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
                onPressed: () {
                  if (itemType == 'outfits') {
                    context.goNamed('outfit_editor_new');
                  } else {
                    context.goNamed('camera_picker');
                  }
                },
                icon: const Icon(Icons.add, size: 16),
                label: Text('Add ${itemType == 'outfits' ? 'Outfit' : 'Clothes'}'),
              ),
            ],
          ),
        ),
      ),
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
              child: _ClothingItem(clothing: item),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOutfitList(BuildContext context, List<OutfitModel> outfits) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          horizontalSpace(24),
          ...outfits.asMap().entries.map((entry) {
            final outfit = entry.value;
            final isLast = entry.key == outfits.length - 1;

            return Padding(
              padding: EdgeInsets.only(right: isLast ? 24 : 16),
              child: GestureDetector(
                onTap: () {
                  // Navigate to outfit editor with the outfit ID
                  context.goNamed(
                    'outfit_editor_existing',
                    pathParameters: {'outfitId': outfit.id},
                  );
                },
                child: _OutfitItem(outfit: outfit),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ClothingItem extends StatelessWidget {
  final ClothingModel clothing;

  const _ClothingItem({required this.clothing});

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

class _OutfitItem extends StatelessWidget {
  final OutfitModel outfit;

  const _OutfitItem({required this.outfit});

  @override
  Widget build(BuildContext context) {
    // Helper function to check if an item exists
    bool isValid(String? path) => path != null && path.isNotEmpty;

    // Count items in outfit
    int itemCount = 0;
    if (isValid(outfit.shirt)) itemCount++;
    if (isValid(outfit.pants)) itemCount++;
    if (isValid(outfit.dress)) itemCount++;
    if (isValid(outfit.shoes)) itemCount++;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 140,
          height: 160,
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
          child: Stack(
            children: [
              // Items stacked within the card
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isValid(outfit.shirt)) _buildItemPreview(outfit.shirt!, 40),
                    if (isValid(outfit.dress)) _buildItemPreview(outfit.dress!, 40),
                    if (isValid(outfit.pants)) _buildItemPreview(outfit.pants!, 40),
                    if (isValid(outfit.shoes)) _buildItemPreview(outfit.shoes!, 40),
                    if (!isValid(outfit.shirt) && !isValid(outfit.dress) &&
                        !isValid(outfit.pants) && !isValid(outfit.shoes))
                      Icon(
                        Icons.checkroom,
                        size: 40,
                        color: AppColors.disabled.withOpacity(0.5),
                      ),
                  ],
                ),
              ),

              // "Outfit" badge at the top
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Outfit',
                    style: TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 140,
          child: Text(
            outfit.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTypography.cardLabel(context).copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 140,
          child: Text(
            '${itemCount} ${itemCount == 1 ? 'item' : 'items'}',
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

  // Helper to build an image preview based on the path
  Widget _buildItemPreview(String path, double height) {
    // Check if the image is an asset path or a file path
    final bool isAssetPath = !path.startsWith('/');

    return SizedBox(
      height: height,
      child: isAssetPath
          ? Image.asset(
        path,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 24, color: AppColors.disabled);
        },
      )
          : Image.file(
        File(path),
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 24, color: AppColors.disabled);
        },
      ),
    );
  }
}