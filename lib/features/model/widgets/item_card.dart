import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/features/wardrobe/riverpod/dummy_assets_provider.dart';

class ItemCard extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isDummy;
  
  const ItemCard({
    super.key,
    required this.image,
    required this.onTap,
    this.isSelected = false,
    this.isDummy = false,
  });

  @override
  Widget build(BuildContext context) {
    // For "None" option
    if (image.trim().isEmpty) {
      return _buildNoneOption();
    }
    
    // Check if the image is an asset path or a file path
    final bool isAssetPath = !image.startsWith('/');
    
    final displayName = isDummy && isAssetPath
        ? DummyAssetsNotifier.getDisplayName(image)
        : '';
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.tertiary : Colors.black12,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppColors.tertiary.withOpacity(0.3) 
                  : Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isAssetPath
                        ? Image.asset(
                            image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.disabled,
                                  size: 48,
                                ),
                              );
                            },
                          )
                        : Image.file(
                            File(image),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.disabled,
                                  size: 48,
                                ),
                              );
                            },
                          ),
                  ),
                ),
                if (isDummy && displayName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            
            // Selected indicator
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            
            // Sample indicator for dummy items
            if (isDummy)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
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
    );
  }
  
  Widget _buildNoneOption() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tertiary.withOpacity(0.1) : AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.tertiary : Colors.black12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.remove_circle_outline,
                size: 36,
                color: isSelected ? AppColors.tertiary : AppColors.disabled,
              ),
              const SizedBox(height: 8),
              Text(
                'None',
                style: TextStyle(
                  color: isSelected ? AppColors.tertiary : AppColors.disabled,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}