import 'package:hive/hive.dart';
import 'package:modisch/core/database/models/outfit_model_database.dart';

class ModelClothingController {
  Future<List<ModelClothing>> getAllModels() async {
    final box = await Hive.openBox<ModelClothing>('models');
    return box.values.toList();
  }

  Future<void> addModel(ModelClothing model) async {
    final box = await Hive.openBox<ModelClothing>('models');
    await box.put(model.id, model);
  }

  Future<void> updateModelItem({
    required String id,
    String? newShirtId,
    String? newPantsId,
    String? newDressId,
    String? newShoesId,
  }) async {
    final box = await Hive.openBox<ModelClothing>('models');
    final existing = box.get(id);

    if (existing != null) {
      final updated = ModelClothing(
        id: existing.id,
        shirtId: newShirtId ?? existing.shirtId,
        pantsId: newPantsId ?? existing.pantsId,
        dressId: newDressId ?? existing.dressId,
        shoesId: newShoesId ?? existing.shoesId,
        createdAt: existing.createdAt,
      );
      await box.put(id, updated);
    }
  }

  Future<void> deleteModel(String id) async {
    final box = await Hive.openBox<ModelClothing>('models');
    await box.delete(id);
  }

  Future<ModelClothing?> getModelById(String id) async {
    final box = await Hive.openBox<ModelClothing>('models');
    return box.get(id);
  }
}
