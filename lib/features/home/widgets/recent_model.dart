import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/spacing.dart';
import 'package:Modisch/core/constants/typography.dart';
import 'package:Modisch/core/database/models/outfit_model_database.dart';
import 'package:Modisch/features/model/providers/outfit_provider.dart';
import 'recent_wardrobe.dart';

/// Widget displaying recent outfit models
class RecentModelWidget extends ConsumerWidget {
  final int itemCount;

  const RecentModelWidget({
    super.key,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get recent outfits from the outfit provider
    final outfitsState = ref.watch(outfitNotifierProvider);

    return outfitsState.when(
      loading: () => _buildLoadingState(context),
      error: (error, _) => _buildErrorState(context),
      data: (outfits) => _buildDataState(context, outfits),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        verticalSpace(16),
        const Center(
          child: CircularProgressIndicator(color: AppColors.tertiary),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        verticalSpace(16),
        _buildEmptyState(context),
      ],
    );
  }

  Widget _buildDataState(BuildContext context, List<OutfitModel> outfits) {
    // Sort outfits by creation date, most recent first
    final sortedOutfits = [...outfits];
    sortedOutfits.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Take only the requested number of items
    final recentOutfits = sortedOutfits.take(itemCount).toList();

    return Column(
      children: [
        _buildHeader(context),
        verticalSpace(16),
        recentOutfits.isEmpty
            ? _buildEmptyState(context)
            : _buildOutfitList(context, recentOutfits),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const RecentHeader(title: 'Recent Outfits');
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      itemType: 'outfits',
      onAddPressed: () => context.goNamed('outfit_editor_new'),
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
              child: OutfitItemCard(outfit: outfit),
            );
          }),
        ],
      ),
    );
  }
}

/// Widget for displaying a single outfit item
class OutfitItemCard extends StatelessWidget {
  final OutfitModel outfit;

  const OutfitItemCard({
    super.key,
    required this.outfit,
  });

  @override
  Widget build(BuildContext context) {
    // Count items in outfit
    int itemCount = _countOutfitItems();

    return GestureDetector(
      onTap: () => _navigateToOutfitEditor(context),
      child: Column(
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
            child: _buildOutfitPreview(itemCount),
          ),
          const SizedBox(height: 8),
          _buildOutfitTitle(context),
          _buildOutfitItemCount(itemCount, context),
        ],
      ),
    );
  }

  void _navigateToOutfitEditor(BuildContext context) {
    context.goNamed(
      'outfit_editor_existing',
      pathParameters: {'outfitId': outfit.id},
    );
  }

  int _countOutfitItems() {
    int count = 0;
    if (_isValidPath(outfit.shirt)) count++;
    if (_isValidPath(outfit.pants)) count++;
    if (_isValidPath(outfit.dress)) count++;
    if (_isValidPath(outfit.shoes)) count++;
    return count;
  }

  bool _isValidPath(String? path) => path != null && path.isNotEmpty;

  Widget _buildOutfitPreview(int itemCount) {
    return Stack(
      children: [
        // Items stacked within the card
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isValidPath(outfit.shirt)) _buildItemPreview(outfit.shirt!, 40),
              if (_isValidPath(outfit.dress)) _buildItemPreview(outfit.dress!, 40),
              if (_isValidPath(outfit.pants)) _buildItemPreview(outfit.pants!, 40),
              if (_isValidPath(outfit.shoes)) _buildItemPreview(outfit.shoes!, 40),
              if (itemCount == 0)
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
    );
  }

  Widget _buildOutfitTitle(BuildContext context) {
    return SizedBox(
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
    );
  }

  Widget _buildOutfitItemCount(int itemCount, BuildContext context) {
    return SizedBox(
      width: 140,
      child: Text(
        '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
        style: AppTypography.cardLabel(context).copyWith(
          fontSize: 11,
          color: AppColors.searchBarComponents,
        ),
        textAlign: TextAlign.center,
      ),
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