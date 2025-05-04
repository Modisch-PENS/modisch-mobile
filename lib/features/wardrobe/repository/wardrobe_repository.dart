import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modisch/core/database/models/wardrobe_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class WardrobeRepository {
  final Box<ClothingModel> _clothingBox;
  
  WardrobeRepository(): _clothingBox = Hive.box<ClothingModel>('clothing');
  
  // Get all clothing items
  List<ClothingModel> getAllClothingItems() {
    return _clothingBox.values.toList();
  }
  
  // Get items by category
  List<ClothingModel> getItemsByCategory(String category) {
    return _clothingBox.values
        .where((item) => item.category == category)
        .toList();
  }
  
  // Add a new clothing item
  Future<ClothingModel> addClothingItem({
    required String tempImagePath,
    required String category,
    required String name,
  }) async {
    // Generate a unique ID
    final id = const Uuid().v4();
    
    // Get application directory
    final appDir = await getApplicationDocumentsDirectory();
    final savedPath = '${appDir.path}/$id.jpg';
    
    // Copy the image to permanent storage
    await File(tempImagePath).copy(savedPath);
    
    // Create the model
    final model = ClothingModel(
      id: id,
      category: category,
      imagePath: savedPath,
      name: name,
    );
    
    // Save to Hive
    await _clothingBox.put(id, model);
    
    return model;
  }
  
  // Delete a clothing item
  Future<void> deleteClothingItem(String id) async {
    final item = _clothingBox.get(id);
    
    // Delete the file if it exists
    if (item != null) {
      final file = File(item.imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    
    // Remove from Hive
    await _clothingBox.delete(id);
  }
  
  // Update a clothing item
  Future<void> updateClothingItem(ClothingModel item) async {
    await _clothingBox.put(item.id, item);
  }
  
  // Listen for changes
  ValueListenable<Box<ClothingModel>> listenForChanges() {
    return _clothingBox.listenable();
  }
}