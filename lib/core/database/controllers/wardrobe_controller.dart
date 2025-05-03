import 'package:hive/hive.dart';
import 'package:modisch/core/database/wardrobe_database.dart';

class WardrobeController {
  Future<List<ClothingModel>> getAllClothes() async {
    final box = await Hive.openBox<ClothingModel>('clothes');
    return box.values.toList();
  }

  Future<List<ClothingModel>> getClothesByCategory(String category) async {
    final box = await Hive.openBox<ClothingModel>('clothes');
    return box.values.where((item) => item.category == category).toList();
  }

  Future<void> addClothing(ClothingModel clothing) async {
    final box = await Hive.openBox<ClothingModel>('clothes');
    await box.put(clothing.id, clothing);
  }

  Future<void> updateClothing({
    required String id,
    String? category,
    String? imagePath,
  }) async {
    final box = await Hive.openBox<ClothingModel>('clothes');
    final existing = box.get(id);

    if (existing != null) {
      final updated = ClothingModel(
        id: existing.id,
        category: category ?? existing.category,
        imagePath: imagePath ?? existing.imagePath,
      );
      await box.put(id, updated);
    }
  }

  Future<void> deleteClothing(String id) async {
    final box = await Hive.openBox<ClothingModel>('clothes');
    await box.delete(id);
  }

  Future<ClothingModel?> getClothingById(String id) async {
  final box = await Hive.openBox<ClothingModel>('clothes');
  return box.get(id);
}

}
