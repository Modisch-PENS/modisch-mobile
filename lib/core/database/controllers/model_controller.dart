import 'package:hive/hive.dart';
import 'package:modisch/core/database/models/outfit_model_database.dart';

class OutfitModelController {
  Future<List<OutfitModel>> getAllModels() async {
    final box = await Hive.openBox<OutfitModel>('models');
    return box.values.toList();
  }

  Future<void> addModel(OutfitModel model) async {
    final box = await Hive.openBox<OutfitModel>('models');
    await box.put(model.id, model);
  }

  Future<void> updateModelItem({
    required String id,
    String? newShirt,
    String? newPants,
    String? newDress,
    String? newShoes,
  }) async {
    final box = await Hive.openBox<OutfitModel>('models');
    final existing = box.get(id);

    if (existing != null) {
      final updated = OutfitModel(
        id: existing.id,
        name: existing.name,
        shirt: newShirt ?? existing.shirt,
        pants: newPants ?? existing.pants,
        dress: newDress ?? existing.dress,
        shoes: newShoes ?? existing.shoes,
        createdAt: existing.createdAt,
      );
      await box.put(id, updated);
    }
  }


  Future<void> deleteModel(String id) async {
    final box = await Hive.openBox<OutfitModel>('models');
    await box.delete(id);
  }

  Future<OutfitModel?> getModelById(String id) async {
    final box = await Hive.openBox<OutfitModel>('models');
    return box.get(id);
  }
}
