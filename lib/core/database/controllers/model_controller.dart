import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:modisch/core/database/model_database.dart';

class ModelClothingController with ChangeNotifier {
  List<ModelClothing> _models = [];

  List<ModelClothing> get allModels => _models;

  Future<void> loadModels() async {
    final box = await Hive.openBox<ModelClothing>('models');
    _models = box.values.toList();
    notifyListeners();
  }

  Future<void> addModel(ModelClothing model) async {
    final box = await Hive.openBox<ModelClothing>('models');
    await box.put(model.id, model);
    await loadModels();
  }

  Future<void> deleteModel(String id) async {
    final box = await Hive.openBox<ModelClothing>('models');
    await box.delete(id);
    await loadModels();
  }

  Future<void> updateModel(String id, ModelClothing updatedModel) async {
    final box = await Hive.openBox<ModelClothing>('models');
    await box.put(id, updatedModel);
    await loadModels();
  }

  Future<void> updateModelItem({
    required String id,
    String? newShirtId,
    String? newPantsId,
    String? newDressId,
    String? newShoesId,
  }) async {
    final box = await Hive.openBox<ModelClothing>('models');
    final currentModel = box.get(id);

    if (currentModel != null) {
      final updatedModel = ModelClothing(
        id: currentModel.id,
        shirtId: newShirtId ?? currentModel.shirtId,
        pantsId: newPantsId ?? currentModel.pantsId,
        dressId: newDressId ?? currentModel.dressId,
        shoesId: newShoesId ?? currentModel.shoesId,
        createdAt: currentModel.createdAt,
      );

      await box.put(id, updatedModel);
      await loadModels();
    }
  }

  ModelClothing? getModelById(String id) {
    return _models.firstWhere((model) => model.id == id);
  }
}
