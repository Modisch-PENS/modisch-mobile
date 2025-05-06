import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Modisch/features/model/providers/outfit_provider.dart';

class OutfitPreview extends ConsumerWidget {
  const OutfitPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfit = ref.watch(outfitEditorNotifierProvider);
    
    return Container(
      width: 348,
      height: 437,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display outfit items in stacked order
          if (_hasItem(outfit.shirt))
            _buildItemImage(context, outfit.shirt!),
            
          if (_hasItem(outfit.dress))
            _buildItemImage(context, outfit.dress!),
            
          if (_hasItem(outfit.pants))
            _buildItemImage(context, outfit.pants!),
            
          if (_hasItem(outfit.shoes))
            _buildItemImage(context, outfit.shoes!),
            
          // Show guidance text if no items are selected
          if (!_hasItem(outfit.shirt) && 
              !_hasItem(outfit.dress) && 
              !_hasItem(outfit.pants) && 
              !_hasItem(outfit.shoes))
            const Text(
              'Choose your outfit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
  
  // Helper to check if an item exists
  bool _hasItem(String? path) {
    return path != null && path.isNotEmpty;
  }
  
  // Build an image widget for either asset or file
  Widget _buildItemImage(BuildContext context, String imagePath) {
    // Check if the image is an asset path or a file path
    final bool isAssetPath = !imagePath.startsWith('/');
    
    return SizedBox(
      height: 100,
      child: isAssetPath
          ? Image.asset(
              imagePath,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Text('Image not found: $imagePath');
              },
            )
          : Image.file(
              File(imagePath),
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Text('Image not found: $imagePath');
              },
            ),
    );
  }
}