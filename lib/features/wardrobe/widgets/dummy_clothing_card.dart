import 'package:flutter/material.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/features/wardrobe/riverpod/dummy_assets_provider.dart';

class DummyClothingCard extends StatelessWidget {
  final String assetPath;
  
  const DummyClothingCard({
    Key? key,
    required this.assetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayName = DummyAssetsNotifier.getDisplayName(assetPath);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.disabled,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image with "Sample" indicator
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)),
              child: Stack(
                children: [
                  // Asset image
                  Positioned.fill(
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.disabled.withOpacity(0.2),
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.disabled,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Sample indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
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
          
          // Item name
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Text(
              displayName,
              textAlign: TextAlign.center,
              style: AppTypography.cardLabel(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}