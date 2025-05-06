import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/typography.dart';
import 'package:Modisch/core/database/models/outfit_model_database.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';

enum ItemType {
  clothing,
  outfit,
}

class ItemPreviewCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? subtitle;
  final ItemType itemType;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double width;
  final double height;
  final bool showBadge;
  final Widget? customContent;

  const ItemPreviewCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.subtitle,
    required this.itemType,
    this.onTap,
    this.onLongPress,
    this.width = 125,
    this.height = 125,
    this.showBadge = true,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Container
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.disabled, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha :0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Custom content (for outfits with multiple items) or image
                if (customContent != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: customContent!,
                  )
                else if (imagePath.isNotEmpty)
                  _buildImage(context)
                else
                  Center(
                    child: Icon(
                      itemType == ItemType.outfit ? Icons.checkroom : Icons.image,
                      color: AppColors.disabled,
                      size: 40,
                    ),
                  ),

                // Badge (optional)
                if (showBadge)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: itemType == ItemType.outfit
                            ? AppColors.tertiary.withValues(alpha :0.2)
                            : AppColors.secondary.withValues(alpha :0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        itemType == ItemType.outfit ? 'Outfit' : 'Clothing',
                        style: TextStyle(
                          color: itemType == ItemType.outfit
                              ? AppColors.tertiary
                              : AppColors.secondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Title & Subtitle
          const SizedBox(height: 8),
          SizedBox(
            width: width,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.cardLabel(context).copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (subtitle != null)
            SizedBox(
              width: width,
              child: Text(
                subtitle!,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.cardLabel(context).copyWith(
                  fontSize: 11,
                  color: AppColors.searchBarComponents,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    // Check if the image is an asset path or a file path
    final bool isAssetPath = !imagePath.startsWith('/');

    return ClipRRect(
      borderRadius: BorderRadius.circular(19), // Slightly smaller to account for border
      child: isAssetPath
          ? Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              color: AppColors.disabled,
            ),
          );
        },
      )
          : Image.file(
        File(imagePath),
        width: width,
        height: height,
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
    );
  }
}

// Outfit-specific card for displaying multiple stacked items
class OutfitPreviewCard extends StatelessWidget {
  final String name;
  final String? shirt;
  final String? pants;
  final String? dress;
  final String? shoes;
  final int itemCount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double width;
  final double height;
  final bool showBadge;

  const OutfitPreviewCard({
    super.key,
    required this.name,
    this.shirt,
    this.pants,
    this.dress,
    this.shoes,
    required this.itemCount,
    this.onTap,
    this.onLongPress,
    this.width = 140,
    this.height = 160,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return ItemPreviewCard(
      imagePath: '', // Empty because we're providing custom content
      title: name,
      subtitle: '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
      itemType: ItemType.outfit,
      onTap: onTap,
      onLongPress: onLongPress,
      width: width,
      height: height,
      showBadge: showBadge,
      customContent: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isValid(shirt)) _buildItemPreview(shirt!, 40),
            if (_isValid(dress)) _buildItemPreview(dress!, 40),
            if (_isValid(pants)) _buildItemPreview(pants!, 40),
            if (_isValid(shoes)) _buildItemPreview(shoes!, 40),
            if (!_isValid(shirt) && !_isValid(dress) &&
                !_isValid(pants) && !_isValid(shoes))
              Icon(
                Icons.checkroom,
                size: 40,
                color: AppColors.disabled.withValues(alpha :0.5),
              ),
          ],
        ),
      ),
    );
  }

  // Helper to check if an item exists
  bool _isValid(String? path) => path != null && path.isNotEmpty;

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

// Factory to create an OutfitPreviewCard from an OutfitModel
extension OutfitModelExt on OutfitModel {
  OutfitPreviewCard toPreviewCard({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double width = 140,
    double height = 160,
    bool showBadge = true,
  }) {
    // Calculate item count
    int count = 0;
    if (shirt != null && shirt!.isNotEmpty) count++;
    if (pants != null && pants!.isNotEmpty) count++;
    if (dress != null && dress!.isNotEmpty) count++;
    if (shoes != null && shoes!.isNotEmpty) count++;

    return OutfitPreviewCard(
      name: name,
      shirt: shirt,
      pants: pants,
      dress: dress,
      shoes: shoes,
      itemCount: count,
      onTap: onTap,
      onLongPress: onLongPress,
      width: width,
      height: height,
      showBadge: showBadge,
    );
  }
}

// Factory to create an ItemPreviewCard from a ClothingModel
extension ClothingModelExt on ClothingModel
{
  ItemPreviewCard toPreviewCard({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double width = 125,
    double height = 125,
    bool showBadge = false,
  }) {
    return ItemPreviewCard(
      imagePath: imagePath,
      title: name,
      subtitle: category,
      itemType: ItemType.clothing,
      onTap: onTap,
      onLongPress: onLongPress,
      width: width,
      height: height,
      showBadge: showBadge,
    );
  }
}