import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/database/models/wardrobe_database.dart';
import 'package:modisch/features/model/providers/outfit_provider.dart';
import 'package:modisch/features/model/widgets/item_card.dart';
import 'package:modisch/features/wardrobe/riverpod/dummy_assets_provider.dart';
import 'package:modisch/features/wardrobe/riverpod/wardrobe_provider.dart';

class ItemCategoryScreen extends ConsumerWidget {
  final String category;
  
  const ItemCategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current outfit being edited
    final outfitEditor = ref.watch(outfitEditorNotifierProvider);
    
    // Get the clothing items from the wardrobe
    final clothingState = ref.watch(clothingByCategoryProvider(category));
    
    // Get the dummy assets for this category
    final dummyAssets = ref.watch(dummyAssetsByCategoryProvider(category));
    
    // Determine which item is currently selected
    String? selectedItem;
    switch (category) {
      case 'Shirt':
        selectedItem = outfitEditor.shirt;
        break;
      case 'Pants':
        selectedItem = outfitEditor.pants;
        break;
      case 'Dress':
        selectedItem = outfitEditor.dress;
        break;
      case 'Shoes':
        selectedItem = outfitEditor.shoes;
        break;
    }
    
    // Handle item selection
    void selectItem(String? imagePath, bool isDummy) {
      // For validation purposes (especially for shirts and dresses)
      String? validationError;
      
      switch (category) {
        case 'Shirt':
          validationError = ref.read(outfitEditorNotifierProvider.notifier)
              .validateTopSelection(target: 'shirt');
          if (validationError != null) {
            _showValidationError(context, validationError);
            return;
          }
          ref.read(outfitEditorNotifierProvider.notifier).setShirt(imagePath);
          break;
        case 'Pants':
          ref.read(outfitEditorNotifierProvider.notifier).setPants(imagePath);
          break;
        case 'Dress':
          validationError = ref.read(outfitEditorNotifierProvider.notifier)
              .validateTopSelection(target: 'dress');
          if (validationError != null) {
            _showValidationError(context, validationError);
            return;
          }
          ref.read(outfitEditorNotifierProvider.notifier).setDress(imagePath);
          break;
        case 'Shoes':
          ref.read(outfitEditorNotifierProvider.notifier).setShoes(imagePath);
          break;
      }
    }
    
    // Create grid items for clothing items
    List<Widget> clothingCards = clothingState.isEmpty
        ? []
        : clothingState.map((item) {
            return ItemCard(
              image: item.imagePath,
              onTap: () => selectItem(item.imagePath, false),
              isSelected: selectedItem == item.imagePath,
              isDummy: false,
            );
          }).toList();
    
    // Create grid items for dummy assets
    List<Widget> dummyCards = dummyAssets.map((assetPath) {
      return ItemCard(
        image: assetPath,
        onTap: () => selectItem(assetPath, true),
        isSelected: selectedItem == assetPath,
        isDummy: true,
      );
    }).toList();
    
    // Create a "None" option
    final noneCard = ItemCard(
      image: ' ', // Empty space indicates the "None" option
      onTap: () => selectItem(null, false),
      isSelected: selectedItem == null,
    );
    
    // Combine all items - user's items first, then dummy items
    final allCards = [noneCard, ...clothingCards, ...dummyCards];
    
    return clothingState.isNotEmpty || dummyAssets.isNotEmpty
        ? GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: allCards.length,
            itemBuilder: (_, index) => allCards[index],
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getCategoryIcon(category),
                  size: 64,
                  color: AppColors.disabled.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${category.toLowerCase()} items available',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.disabled,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
  }
  
  void _showValidationError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warning'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Shirt':
        return Icons.checkroom;
      case 'Pants':
        return Icons.border_color;
      case 'Dress':
        return Icons.accessibility_new;
      case 'Shoes':
        return Icons.hiking;
      default:
        return Icons.checkroom;
    }
  }
}