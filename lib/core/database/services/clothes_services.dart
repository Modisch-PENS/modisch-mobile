import 'package:hive/hive.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String _clothingBoxName = 'clothing_items';
  
  /// Initialize Hive and register adapters
  static Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    Hive.registerAdapter(ClothingModelAdapter());
    await Hive.openBox<ClothingModel>(_clothingBoxName);
  }
  
  /// Save a clothing item to the database
  static Future<void> saveClothingItem(ClothingModel item) async {
    final box = Hive.box<ClothingModel>(_clothingBoxName);
    await box.put(item.id, item);
  }
  
  /// Get all clothing items by category
  static List<ClothingModel> getClothingByCategory(String category) {
    final box = Hive.box<ClothingModel>(_clothingBoxName);
    return box.values
        .where((item) => item.category == category)
        .toList();
  }
  
  /// Get all clothing items
  static List<ClothingModel> getAllClothingItems() {
    final box = Hive.box<ClothingModel>(_clothingBoxName);
    return box.values.toList();
  }
  
  /// Delete a clothing item
  static Future<void> deleteClothingItem(String id) async {
    final box = Hive.box<ClothingModel>(_clothingBoxName);
    await box.delete(id);
  }
}