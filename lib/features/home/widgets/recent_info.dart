import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/spacing.dart';
import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/core/database/models/wardrobe_database.dart';
import 'package:modisch/features/wardrobe/riverpod/wardrobe_provider.dart';
import 'package:modisch/features/wardrobe/riverpod/dummy_assets_provider.dart';

class RecentInfo extends ConsumerWidget {
  final String title;
  final List<String>? assetImages; // Optional fallback images

  const RecentInfo({
    super.key, 
    required this.title, 
    this.assetImages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get recent items from the wardrobe provider
    final recentItems = ref.watch(recentClothingProvider(limit: 10));
    final allDummyAssets = ref.watch(dummyAssetsNotifierProvider);
    
    // Collect all dummy assets into a single list for "clothes"
    List<String> dummyAssets = [];
    if (title.toLowerCase() == 'clothes') {
      allDummyAssets.values.forEach((list) {
        dummyAssets.addAll(list);
      });
      // Shuffle and limit to 10 items for variety
      dummyAssets.shuffle();
      if (dummyAssets.length > 10) {
        dummyAssets = dummyAssets.sublist(0, 10);
      }
    } else if (title.toLowerCase() == 'model') {
      // For "model", we might not have data yet, so use the shirt assets as placeholders
      dummyAssets = allDummyAssets['Shirt'] ?? [];
      if (dummyAssets.length > 10) {
        dummyAssets = dummyAssets.sublist(0, 10);
      }
    }
    
    // If there are no items and no fallback images, show empty state
    if (recentItems.isEmpty && dummyAssets.isEmpty) {
      return Column(
        children: [
          _buildHeader(context),
          verticalSpace(16),
          _buildEmptyState(context),
        ],
      );
    }
    
    // If there are no real items but we have dummy assets, use those
    final useAssets = recentItems.isEmpty;
    
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
              if (useAssets)
                ...dummyAssets.asMap().entries.map((entry) {
                  final isLast = entry.key == dummyAssets.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(right: isLast ? 24 : 16),
                    child: _AssetListItem(
                      imagePath: dummyAssets[entry.key],
                      itemName: DummyAssetsNotifier.getDisplayName(dummyAssets[entry.key]),
                      isSample: true,
                    ),
                  );
                })
              else
                ...recentItems.asMap().entries.map((entry) {
                  final isLast = entry.key == recentItems.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(right: isLast ? 24 : 16),
                    child: _ClothingListItem(
                      clothing: recentItems[entry.key],
                    ),
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

  // Helper method to extract item name from asset path
  String _getItemNameFromAsset(String path) {
    // Extract filename from path and remove extension
    String fileName = path.split('/').last;
    // Remove extension
    String nameWithoutExtension = fileName.split('.').first;
    // Replace underscores with spaces and capitalize each word
    List<String> words = nameWithoutExtension.split('_');
    if (words.length >= 2) {
      // Skip the first word if it's "shirt" to get only the color/style
      String colorOrStyle = words.sublist(1).join(' ');
      return '${words[0]} ${colorOrStyle}'.trim();
    }
    return nameWithoutExtension.replaceAll('_', ' ');
  }
}

class _AssetListItem extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final bool isSample;

  const _AssetListItem({
    required this.imagePath, 
    required this.itemName,
    this.isSample = false,
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
          ),
          child: SizedBox(
            height: 125,
            width: 125,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imagePath, 
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
                if (isSample)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Sample',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 125,
          child: Text(
            itemName,
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