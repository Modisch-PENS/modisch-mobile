import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:modisch/core/database/wardrobe_database.dart';

class WardrobeController with ChangeNotifier {
  List<ClothingModel> _clothes = [];

  List<ClothingModel> get allClothes => _clothes;

  Future<void> loadClothes() async {
    final box = await Hive.openBox<ClothingModel>('clothes');
    _clothes = box.values.toList();
    notifyListeners();
  }

  Future<void> addClothing(ClothingModel clothing) async {
    final box = await Hive.openBox<ClothingModel>('clothes');
    await box.put(clothing.id, clothing);
    await loadClothes();
  }

  Future<void> deleteClothing(String id) async {
    final box = await Hive.openBox<ClothingModel>('clothes');
    await box.delete(id);
    await loadClothes();
  }

  Future<void> updateClothing({
    required String id,
    String? category,
    String? imagePath,
  }) async {
    final box = await Hive.openBox<ClothingModel>('clothes');
    final currentClothing = box.get(id);

    if (currentClothing != null) {
      final updatedClothing = ClothingModel(
        id: currentClothing.id,
        category: category ?? currentClothing.category,
        imagePath: imagePath ?? currentClothing.imagePath,
      );

      await box.put(id, updatedClothing);
      await loadClothes();
    }
  }

  ClothingModel? getClothingById(String id) {
    return _clothes.firstWhere((c) => c.id == id);
  }
}
